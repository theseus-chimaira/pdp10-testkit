#!/usr/bin/env python3
"""Check direct GCC stdio scripts never link generic OS/DAIMOS libc.

The real (unmodified) GCC formatter and compiler libp10c archives are
linked in focused --require-cross mode.  This is not a full CPU sweep.
"""

import argparse
import csv
import hashlib
import io
import os
from pathlib import Path
import re
import subprocess
import sys
import tarfile
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from compiler_stdlib_prefix_v1 import archive_path, prepare_shared

FILES = (
    "misc/compat/test-gcc-p10stdio-v1.sh",
    "misc/compat/test-gcc-p10stdio-v2.sh",
)
EVIDENCE = ROOT / "manifests/PDP10-GCC-STDIO-DIRECT-COMPILER-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-gcc-stdio-direct-20261120-v1.tar.gz"
COMPILER_ARCHIVE_SHA_V1 = (
    "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41")
EVIDENCE_FIELDS = ("version", "member", "sha256", "bytes")
ROLES = ("policy.txt", "archive-extraction.map", "guest-memory.report.txt",
         "guest-memory.map", "guest-memory.s", "guest-original.report.txt",
         "guest-original.map", "guest-original.s")


def check_guest_evidence(rows, blob):
    """Keep exactly four real guest PASS reports and archive owners pinned."""
    names = {"v%d/%s" % (v, role) for v in (1, 2) for role in ROLES}
    if (len(rows) != 16 or not rows or tuple(rows[0]) != EVIDENCE_FIELDS or
            {r["member"] for r in rows} != names or
            len({r["member"] for r in rows}) != 16):
        raise ValueError("direct GCC stdio guest evidence inventory changed")
    files = {}
    try:
        with tarfile.open(fileobj=io.BytesIO(blob), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != 16 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("missing or unsafe GCC stdio guest archive")
            for row in rows:
                member = row["member"]
                if row["version"] != member[1] or not re.fullmatch(
                        r"[0-9a-f]{64}", row["sha256"]):
                    raise ValueError("compiler stdio evidence role changed")
                stream = tar.extractfile(member)
                if stream is None:
                    raise ValueError("missing direct guest raw report")
                body = stream.read()
                if (hashlib.sha256(body).hexdigest() != row["sha256"] or
                        str(len(body)) != row["bytes"]):
                    raise ValueError("direct guest SHA256 did not match")
                files[member] = body.decode("utf-8", "replace")
    except (OSError, EOFError, tarfile.TarError) as error:
        raise ValueError("corrupt direct compiler stdio guest archive") from error
    for version in (1, 2):
        base = "v%d/" % version
        policy = files[base + "policy.txt"]
        if ("policy=compiler-stdlib-v1\n" not in policy or
                "compiler=gcc\n" not in policy or
                "sha256=" + COMPILER_ARCHIVE_SHA_V1 not in policy or
                "libp10c-v2.a" not in policy):
            raise ValueError("direct guest used unknown target libc")
        archive_map = files[base + "archive-extraction.map"]
        for symbol in ("sprintf", "vsprintf", "snprintf", "vsnprintf"):
            if len(re.findall(r"^" + symbol + r"\s+[0-7]+\s*$",
                              archive_map, re.M)) != 1:
                raise ValueError("direct stdio archive symbol missing")
        for role in ("memory", "original"):
            report = files[base + "guest-" + role + ".report.txt"]
            mapping = files[base + "guest-" + role + ".map"]
            asm = files[base + "guest-" + role + ".s"]
            if ("machine=pdp6\n" not in report or
                    "rc=0\n" not in report or "result=PASS\n" not in report or
                    "HALT instruction" not in report or
                    re.search(r"__P10RUN_EXPECT__ __test_exit [0-7]+ "
                              r"000000000000", report) is None or
                    (role == "memory" and
                     re.search(r"__P10RUN_EXPECT__ fail_id [0-7]+ "
                               r"000000000000", report) is None)):
                raise ValueError("direct native guest did not complete assertions")
            if ("main:" not in asm or
                    re.search(r"^sprintf\s+[0-7]+\s*$", mapping, re.M) is None):
                raise ValueError("direct GCC program not genuinely linked")
    return files


def check_source(text, version):
    """Reject reintroduction of the generic archive in direct scripts."""
    content = text.splitlines()
    active = "\n".join(line for line in content
                       if line.strip() and not line.lstrip().startswith("#"))
    required = (
        'libdir="$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/freestanding"',
        'compiler_libc="$libdir/libp10c-v2.a"',
        'from compiler_stdlib_prefix_v1 import prepare_script_prefix',
        'print(prepare_script_prefix(os.environ["P10TK_STDIO_RUNTIME_OUT"],',
        'os.environ["PDP10_PREFIX"], "gcc"))',
        '"$libdir/libp10stdio-v%d.a" "$compiler_libc"' % version,
        '"$libdir/p10stdio-format-v%d.s"' % version,
        '"$compiler_libc"',
        '"$PDP10_PREFIX/bin/dlink"',
        '"$P10RUN"',
    )
    for clause in required:
        if clause not in active:
            raise ValueError("missing compiler-only GCC stdio contract: " + clause)
    if (re.search(r"\$\{?PDP10_PREFIX\}?/lib/libc\.a", active) or
            "daimos-libc" in active or
            active.count('"$compiler_libc"') != 2 or
            active.count('PDP10_PREFIX="$compiler_prefix" "$P10RUN"') != 2 or
            active.count('compiler_libc="$libdir/libp10c-v2.a"') != 1):
        raise ValueError("direct GCC stdio script selects a noncompiler libc")


def installed():
    prefix = Path(os.environ["PDP10_PREFIX"]).resolve()
    library = archive_path(prefix, "gcc")
    libdir = prefix / "lib/gcc-lib/pdp10-dec-none/3.2/freestanding"
    for version in (1, 2):
        for name in ("libp10stdio-v%d.a" % version,
                     "p10stdio-format-v%d.s" % version):
            if not (libdir / name).is_file():
                raise ValueError("missing installed compiler formatter: " + name)
    if library == prefix / "lib/libc.a":
        raise ValueError("generic libc must not be selected")
    return prefix, library, libdir


def cross_link(prefix, library, libdir):
    """Run one archive extraction per formatter version, no CPUs swept."""
    binpath = prefix / "bin"
    gcc = binpath / "pdp10-dec-none-gcc"
    das = binpath / "das"
    dlink = binpath / "dlink"
    libgcc = subprocess.check_output(
        [str(gcc), "-print-libgcc-file-name"], text=True).strip()
    if not Path(libgcc).is_file():
        raise ValueError("canonical GCC libgcc archive unavailable")
    temp_root = Path(os.environ.get("TMPDIR") or Path.home() / "tmp")
    temp_root.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="p10tk-gcc-stdio-archive-v1-",
                                     dir=temp_root) as path:
        work = Path(path)
        def run(*args):
            subprocess.run([str(x) for x in args], cwd=ROOT, check=True,
                           stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        c_file = ROOT / "misc/compat/gcc-p10stdio-memory-v1.c"
        assembly = work / "client.s"
        run(gcc, "-std=c89", "-ffreestanding", "-fno-builtin",
            "-march=pdp6", "-O0", "-S", c_file, "-o", assembly)
        pieces = []
        for name, source in (("client", assembly),
                             ("crt0", ROOT / "support/crt0-upstream-v1.s"),
                             ("exit", ROOT / "support/exit-v1.s"),
                             ("abort", ROOT / "support/abort-v1.s")):
            dest = work / (name + ".dobj")
            run(das, "-F", "-C", "-O", dest, source)
            pieces.append(dest)
        for version in (1, 2):
            name = "p10tk-gcc-stdio-compiler-v%d" % version
            mapping = work / (name + ".map")
            run(dlink, "-b", "01000", "-o", work / (name + ".dxr"),
                "-M", mapping, *pieces,
                libdir / ("libp10stdio-v%d.a" % version),
                library, libgcc)
            contents = mapping.read_text(encoding="ascii")
            for symbol in ("sprintf", "vsprintf", "snprintf", "vsnprintf"):
                if len(re.findall(r"^" + symbol + r"\s+[0-7]+\s*$",
                                  contents, re.M)) != 1:
                    raise ValueError("compiler stdio archive did not own " + symbol)
            print("PASS: GCC stdio v%d archive extracted with compiler libc" %
                  version)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-cross", action="store_true")
    args = parser.parse_args()
    with EVIDENCE.open(encoding="ascii", newline="") as evidence_file:
        guest_rows = list(csv.DictReader(evidence_file, delimiter="\t"))
    guest_payload = ARCHIVE.read_bytes()
    check_guest_evidence(guest_rows, guest_payload)
    with (ROOT / "SPECIAL_TESTS.tsv").open(encoding="ascii", newline="") as f:
        registrations = list(csv.DictReader(f, delimiter="\t"))
    for number, filename in enumerate(FILES, 1):
        match = [row for row in registrations if row["path"] == filename]
        if (len(match) != 1 or match[0]["group"] != "compat" or
                match[0]["enabled"] != "yes"):
            raise ValueError("GCC stdio script not registered in compat")
        text = (ROOT / filename).read_text(encoding="ascii")
        check_source(text, number)

    # The controls mutate the actual script text and must be rejected.
    count = 0
    for number, filename in enumerate(FILES, 1):
        original = (ROOT / filename).read_text(encoding="ascii")
        changes = (
            original.replace('compiler_libc="$libdir/libp10c-v2.a"',
                             'compiler_libc="$PDP10_PREFIX/lib/libc.a"'),
            original.replace('"$libdir/libp10stdio-v%d.a" "$compiler_libc"' %
                             number,
                             '"$libdir/libp10stdio-v%d.a" '
                             '"$PDP10_PREFIX/lib/libc.a"' % number),
            original.replace('            "$compiler_libc" \\\n', ''),
            original.replace('"$libdir/p10stdio-format-v%d.s"' % number,
                             '"$libdir/p10stdio-format-v9.s"'),
            original.replace('PDP10_PREFIX="$compiler_prefix" "$P10RUN"',
                             '"$P10RUN"'),
            original.replace('os.environ["PDP10_PREFIX"], "gcc"))',
                             'os.environ["PDP10_PREFIX"], "kcc"))'),
        )
        for changed in changes:
            if changed == original:
                raise AssertionError("inactive stdio mutation")
            try:
                check_source(changed, number)
            except ValueError:
                count += 1
            else:
                raise AssertionError("bad compiler stdio provider accepted")
    changed_rows = [dict(row) for row in guest_rows]
    changed_rows[0]["sha256"] = "0" * 64
    for changed, raw in ((changed_rows, guest_payload),
                         (guest_rows[:-1], guest_payload)):
        try:
            check_guest_evidence(changed, raw)
        except ValueError:
            count += 1
        else:
            raise AssertionError("false direct stdio guest evidence accepted")
    altered = bytearray(guest_payload)
    altered[len(altered) // 2] ^= 1
    try:
        check_guest_evidence(guest_rows, bytes(altered))
    except ValueError:
        count += 1
    else:
        raise AssertionError("corrupt direct stdio archive accepted")
    if args.require_cross:
        prefix, library, libdir = installed()
        cross_link(prefix, library, libdir)
    print("PASS: direct GCC stdio scripts select compiler C library "
          "(2 registered scripts, 4 SHA-pinned guests, %d negative controls)"
          % count)


if __name__ == "__main__":
    main()
