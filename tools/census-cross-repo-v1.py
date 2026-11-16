#!/usr/bin/env python3
"""Read-only cross-repository PDP-10 toolchain test inventory.

This is a source/registration census, not a test runner.  Static references
indicate possible delegation, never proven execution or equivalent coverage.
The output is deterministic for a fixed collection of Git checkouts.
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
FIELDS = ("repository", "path", "kind", "registration", "evidence")


def tracked(repo, prefix=None):
    cmd = ["git", "-C", str(repo), "ls-files", "--cached", "--full-name"]
    if prefix:
        cmd.extend(["--", prefix])
    return subprocess.check_output(cmd, text=True).splitlines()


def revision(repo):
    return subprocess.check_output(
        ["git", "-C", str(repo), "rev-parse", "--short=12", "HEAD"],
        text=True).strip()


def read_rows(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        lines = (line for line in stream if line.strip() and
                 (not comments or not line.startswith("#")))
        return list(csv.DictReader(lines, delimiter="\t"))


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sources_index(paths):
    by_name = collections.defaultdict(list)
    by_hash = collections.defaultdict(list)
    for rel in paths:
        by_name[Path(rel).name].append(rel)
        by_hash[sha(ROOT / rel)].append(rel)
    return by_name, by_hash


def scan_refs(script_paths, external_files):
    """Find explicit script basename references, not dynamic shell calls."""
    callers = collections.defaultdict(set)
    by_name = collections.defaultdict(list)
    for rel in script_paths:
        by_name[Path(rel).name].append(rel)
    local = [(p, ROOT / p) for p in script_paths +
             ["tools/run-misc-suites.py"]]
    for parent, path in local + external_files:
        body = path.read_text(encoding="utf-8", errors="replace")
        for name in set(re.findall(r"[A-Za-z0-9_][A-Za-z0-9_.-]*\.(?:sh|py)", body)):
            for child in by_name.get(name, ()):
                if child != parent:
                    callers[child].add(parent)
    return callers


def run(args):
    repos = {
        name: (Path(getattr(args, name.replace("-", "_")))
               if getattr(args, name.replace("-", "_")) else ROOT.parent / name)
        for name in ("kcc", "gcc-pdp10", "das", "pdp10-tools", "DAIMOS")
    }
    for name, repo in repos.items():
        if not (repo / ".git").exists():
            raise ValueError("missing Git checkout for %s: %s" % (name, repo))

    specials = read_rows(ROOT / "SPECIAL_TESTS.tsv")
    matrix = read_rows(ROOT / "COMPILER_MATRIX.tsv", comments=True)
    direct = {row["path"]: row for row in specials}
    test_sources = [p for p in tracked(ROOT, "tests")
                    if Path(p).suffix in (".c", ".s", ".S", ".sh", ".py")]
    by_name, by_hash = sources_index(test_sources)
    all_scripts = [p for p in tracked(ROOT, "misc")
                   if Path(p).suffix in (".sh", ".py")]
    external_files = [
        ("pdp10-tools/Makefile", repos["pdp10-tools"] / "Makefile"),
        ("DAIMOS/tools/host/Makefile", repos["DAIMOS"] / "tools/host/Makefile"),
        ("das/Makefile", repos["das"] / "Makefile"),
        ("kcc/Makefile", repos["kcc"] / "Makefile"),
        ("gcc-pdp10/build.sh", repos["gcc-pdp10"] / "build.sh"),
    ]
    callers = scan_refs(all_scripts, external_files)
    rows = []

    # The original GCC target-specific suite is small enough to enumerate
    # individually; same-name and same-content matches are not equivalents.
    gcc = repos["gcc-pdp10"]
    gcc_target = [p for p in tracked(gcc, "gcc/testsuite/gcc.target/pdp10")
                  if Path(p).suffix in (".c", ".sh", ".s", ".S")]
    for rel in gcc_target:
        exact = by_hash.get(sha(gcc / rel), [])
        names = by_name.get(Path(rel).name, [])
        kind = "gcc-target-source" if rel.endswith(".c") else "gcc-target-script"
        if exact:
            status, evidence = "byte-identical-in-testkit", ";".join(exact)
        elif names:
            status, evidence = "same-name-review", ";".join(names)
        else:
            status, evidence = "no-direct-testkit-source-match", "review-equivalence"
        rows.append(("gcc-pdp10", rel, kind, status, evidence))

    # This is strictly a *reference* graph: shell/Python constructs can
    # dispatch dynamically, and merely mentioning a filename is not execution.
    registry_groups = frozenset(("verify", "compat", "validation",
                                  "gcc-bare-libgcc", "kcc-regression",
                                  "kcc-host", "tools"))
    for rel in all_scripts:
        row = direct.get(rel)
        mentions = sorted(callers[rel])
        if row and row["enabled"] != "yes":
            status = "registered-manual"
        elif row and row["group"] in registry_groups:
            status = "registered-registry-dispatched"
        elif row and row["group"] == "das":
            status = "registered-das-aggregate-only"
        elif row:
            status = "registered-dispatch-unknown"
        elif mentions:
            status = "not-registered-static-reference"
        else:
            status = "not-registered-no-static-reference"
        evidence = ("id=%s;group=%s;enabled=%s" %
                    (row["id"], row["group"], row["enabled"])) if row else ""
        if mentions:
            evidence += (";" if evidence else "") + "mentioned-by=" + ",".join(mentions)
        if not evidence:
            evidence = "no-static-reference-found"
        rows.append(("pdp10-testkit", rel, "misc-script", status, evidence))

    # Report the *source tree being exercised* rather than assuming that the
    # independent tools repository is byte-identical to DAIMOS/tools/host.
    tools = repos["pdp10-tools"]
    daimos = repos["DAIMOS"]
    common = sorted(set(tracked(tools)) &
                    {p[len("tools/host/"):] for p in tracked(daimos, "tools/host")})
    shared_c = [p for p in common if p.endswith((".c", ".h"))]
    divergent = [p for p in shared_c
                 if (tools / p).read_bytes() != (daimos / "tools/host" / p).read_bytes()]
    for rel in divergent:
        rows.append(("pdp10-tools", rel, "divergent-tool-source",
                     "not-identical-to-daimos-host", "DAIMOS/tools/host/" + rel))

    if args.output:
        target = Path(args.output)
        with target.open("w", encoding="utf-8", newline="") as stream:
            writer = csv.writer(stream, delimiter="\t", lineterminator="\n")
            writer.writerow(FIELDS)
            writer.writerows(sorted(rows))
        print("manifest=%s entries=%d" % (target, len(rows)))

    print("revisions=" + " ".join("%s:%s" % (name, revision(repo))
                                for name, repo in sorted(repos.items())) +
          " pdp10-testkit:%s" % revision(ROOT))
    print("matrix=%d special=%d registered_scripts=%d tracked_misc_scripts=%d" %
          (len(matrix), len(specials),
           sum(p in direct for p in all_scripts), len(all_scripts)))
    print("gcc_pdp10_target=%d unmatched_source=%d" %
          (len(gcc_target), sum(r[3] == "no-direct-testkit-source-match"
                                and r[0] == "gcc-pdp10" for r in rows)))
    for sub in ("execute", "compile"):
        prefix = "gcc/testsuite/gcc.c-torture/" + sub
        upstream = [p for p in tracked(gcc, prefix) if p.endswith(".c")]
        names = sum(bool(by_name.get(Path(p).name)) for p in upstream)
        hashes = sum(bool(by_hash.get(sha(gcc / p))) for p in upstream)
        print("gcc_c_torture_%s=%d same_name=%d same_bytes=%d" %
              (sub, len(upstream), names, hashes))
    upstream = [p for p in tracked(gcc, "gcc/testsuite/gcc.dg")
                if p.endswith(".c")]
    print("gcc_dg=%d same_name=%d same_bytes=%d" %
          (len(upstream), sum(bool(by_name.get(Path(p).name)) for p in upstream),
           sum(bool(by_hash.get(sha(gcc / p))) for p in upstream)))
    print("misc_classification=" + " ".join("%s:%d" % (name, count)
          for name, count in sorted(collections.Counter(
              row[3] for row in rows if row[2] == "misc-script").items())))
    print("shared_tool_c_or_h=%d divergent=%d" % (len(shared_c), len(divergent)))
    print("NOTE: static references are not proof of test execution")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    for name in ("kcc", "gcc-pdp10", "das", "pdp10-tools", "DAIMOS"):
        ap.add_argument("--" + name.lower() + "-repo", dest=name.replace("-", "_"))
    ap.add_argument("--output", help="write versioned TSV (no files changed by default)")
    args = ap.parse_args()
    try:
        run(args)
    except (OSError, subprocess.CalledProcessError, ValueError) as exc:
        print("census: %s" % exc, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
