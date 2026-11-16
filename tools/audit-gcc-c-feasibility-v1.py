#!/usr/bin/env python3
"""Conservative, read-only preflight of unmirrored upstream GCC C sources.

This does not decide compatibility. It identifies original tests requiring
individual PDP-10 suitability and assertion-preservation review.
"""

import argparse
import collections
import csv
import hashlib
from pathlib import Path
import re
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]
# Last GCC revision containing the original source corpus (after ITS removal).
# The source tree intentionally no longer ships DejaGNU tests.
GCC_ARCHIVE_REF = "b0f5374"
GROUPS = (
    ("torture-execute", "gcc/testsuite/gcc.c-torture/execute"),
    ("torture-compile", "gcc/testsuite/gcc.c-torture/compile"),
    ("gcc-dg", "gcc/testsuite/gcc.dg"),
    ("pdp10-target", "gcc/testsuite/gcc.target/pdp10"),
)
RISK_PATTERNS = (
    ("floating-point", r"\b(?:float|double|long double|__float128|FLT_\w+|DBL_\w+|"
     r"HUGE_VAL\w*|isnan|isinf|isfinite|signbit|nextafter|ldexp|frexp|"
     r"copysign|__builtin_(?:nan|inf|isnan|isinf|huge_val)\w*)\b|"
     r"\b\d+(?:\.\d*)?[eE][+-]?\d+\b|\b\d+\.\d+\b"),
    ("width-or-endian", r"\b(?:CHAR_BIT|INT_MAX|INT_MIN|UINT_MAX|LONG_MAX|"
     r"LONG_MIN|ULONG_MAX|LLONG_MAX|SIZE_MAX|__INT_MAX__|__LONG_MAX__|"
     r"int(?:8|16|32|64)_t|uint(?:8|16|32|64)_t)\b|"
     r"\b(?:0[xX](?:7fffffff|80000000|ffffffff|7fffffffffffffff|"
     r"8000000000000000|ffffffffffffffff))\b|"
     r"\b(?:sizeof\s*\(|__SIZEOF_)"),
    ("byte-or-layout", r"\b(?:unsigned\s+char|signed\s+char|char\s*\*|"
     r"memcpy|memmove|memset|strcmp|strlen|strncpy|strcpy|"
     r"__attribute__\s*\(\(\s*(?:packed|aligned|size))\b|"
     r"\bstruct\b[^;{]*\{"),
    ("hosted-library", r"#\s*include\s*[<\"](?:stdio\.h|stdlib\.h|"
     r"math\.h|complex\.h|signal\.h|setjmp\.h|unistd\.h|"
     r"sys/[^>\"]+|pthread\.h|time\.h|locale\.h)[>\"]|"
     r"\b(?:printf|fprintf|fopen|fclose|fwrite|malloc|calloc|"
     r"realloc|free|fork|execve|system|pthread_create)\s*\("),
    ("assembler-or-gnu-extension", r"\b(?:__asm__|asm|__attribute__|"
     r"__builtin_\w+|__extension__|typeof|__typeof__|__label__)\b|"
     r"\b__attribute__\s*\("),
    ("target-restriction", r"dg-(?:do|require-effective-target|skip-if)"
     r"[^\n]*(?:target|i\?86|x86|alpha|mips|powerpc|arm|sparc|ia64)"),
    ("dg-diagnostic", r"dg-(?:error|warning|message|bogus|excess-errors)"),
    ("dg-assembler-contract", r"dg-final\s*\{\s*scan-assembler"),
    ("dg-special-options", r"dg-(?:options|additional-options|add-options)"),
    ("preprocessor-contract", r"#\s*(?:if|elif|error|pragma)\b|dg-do\s+preprocess"),
)


def tracked(repo, prefix):
    return subprocess.check_output(["git", "-C", str(repo), "ls-files",
                                    "--", prefix], text=True).splitlines()


def digest(data):
    return hashlib.sha256(data).hexdigest()


def group_source(group, rel):
    return group == "pdp10-target" or rel.endswith(".c")


def archived_c_sources(repo, revision, prefix):
    paths = subprocess.check_output(
        ["git", "-C", str(repo), "ls-tree", "-r", "--name-only",
         revision, "--", prefix], text=True).splitlines()
    paths = [p for p in paths if p.endswith(".c")]
    cmd = ["git", "-C", str(repo), "cat-file", "--batch"]
    with subprocess.Popen(cmd, stdin=subprocess.PIPE,
                          stdout=subprocess.PIPE) as proc:
        for rel in paths:
            proc.stdin.write((revision + ":" + rel + "\n").encode("ascii"))
            proc.stdin.flush()
            header = proc.stdout.readline().split()
            if len(header) != 3 or header[1] != b"blob":
                raise ValueError("invalid Git source object for " + rel)
            size = int(header[2])
            data = proc.stdout.read(size)
            if len(data) != size or proc.stdout.read(1) != b"\n":
                raise ValueError("short Git source object for " + rel)
            yield rel, data
        proc.stdin.close()
        if proc.wait() != 0:
            raise ValueError("git cat-file failed")


def preflight(gcc_repo, revision):
    # A source may be tracked in the index but deleted in the working tree
    # during a deliberate ownership transfer. Compare actual source files.
    local = [p for p in tracked(ROOT, "tests")
             if p.endswith(".c") and (ROOT / p).is_file()]
    by_hash = collections.defaultdict(list)
    by_name = collections.defaultdict(list)
    for rel in local:
        data = (ROOT / rel).read_bytes()
        by_hash[digest(data)].append(rel)
        by_name[Path(rel).name].append(rel)
    rows = []
    for group, prefix in GROUPS:
        for rel, data in archived_c_sources(gcc_repo, revision, prefix):
            source_hash = digest(data)
            if source_hash in by_hash:
                continue
            name_matches = by_name.get(Path(rel).name, [])
            source = data.decode("latin-1")
            # DejaGNU directives are intentionally written in comments.
            # Ordinary language/ABI risks should reflect actual source,
            # not remarks like "16." or historical 32-bit descriptions.
            bare = re.sub(r"/\*.*?\*/|//[^\n]*", " ", source, flags=re.S)
            risks = [name for name, pattern in RISK_PATTERNS
                     if re.search(pattern,
                                  source if name.startswith("dg-") or
                                  name == "target-restriction" else bare,
                                  re.I | re.M)]
            if not risks:
                risks = ["none-detected"]
            dispositions = "review-target-specific" if group == "pdp10-target" else "manual-source-review"
            rows.append((group, rel, source_hash,
                         "same-name-different-bytes" if name_matches else "no-same-name",
                         ";".join(name_matches) if name_matches else "none",
                         ";".join(risks), dispositions))
    return rows


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--gcc-repo", default=str(ROOT.parent / "gcc-pdp10"))
    p.add_argument("--gcc-ref", default=GCC_ARCHIVE_REF,
                   help="historical GCC source revision (default: %(default)s)")
    p.add_argument("--output", help="explicit TSV output path; no other writes")
    args = p.parse_args()
    gcc = Path(args.gcc_repo)
    if not (gcc / ".git").exists():
        p.error("not a GCC Git checkout: " + str(gcc))
    try:
        rows = preflight(gcc, args.gcc_ref)
    except (OSError, subprocess.CalledProcessError, ValueError) as exc:
        p.error(str(exc))
    if args.output:
        with Path(args.output).open("w", encoding="utf-8", newline="") as stream:
            writer = csv.writer(stream, delimiter="\t", lineterminator="\n")
            writer.writerow(("group", "original_source", "source_sha256",
                             "name_match", "central_candidate_path", "risk_flags",
                             "status"))
            writer.writerows(rows)
        print("wrote %d C source preflight rows: %s" % (len(rows), args.output))
    count = collections.Counter(row[0] for row in rows)
    flags = collections.Counter(flag for row in rows
                                for flag in row[5].split(";"))
    print("unmirrored C sources: %d" % len(rows))
    for key, number in sorted(count.items()):
        print("  %s: %d" % (key, number))
    for key, number in sorted(flags.items()):
        print("  risk %s: %d" % (key, number))
    print("WARNING: risk flags are search hints, not compatibility verdicts")
    return 0


if __name__ == "__main__":
    sys.exit(main())
