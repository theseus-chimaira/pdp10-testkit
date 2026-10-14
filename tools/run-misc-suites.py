"""Specialized suite dispatcher for run-misc-tests.sh.

Ordered suite commands are intentionally explicit, preserving the former
Makefile's verification list rather than running unrelated globbed scripts.
"""
import os
import csv
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
PREFIX = os.environ["PDP10_PREFIX"]
TMP = os.environ.get("TMPDIR") or str(Path.home() / "tmp")
Path(TMP).mkdir(parents=True, exist_ok=True)
ENV = dict(os.environ, TMPDIR=TMP)

VERIFY_PY = """verify-optimization-common-source check-gcc-symbol-length test-stubselect verify-type-semantics verify-wide-int-adapters""".split()
DAS_FAST = """run-das-fast-tests.sh check-das-phase-ir.sh check-das-phase2-transport.sh check-reloc-negative-addend.sh check-symbol-leading-data.sh check-s6filter.sh run-das-stream-tests.sh check-s6text.sh""".split()

def run_special(group):
    with (ROOT / "SPECIAL_TESTS.tsv").open(encoding="utf-8") as f:
        rows = list(csv.DictReader(f, delimiter="\t"))
    for row in rows:
        if row["group"] != group or row["enabled"] != "yes":
            continue
        path = ROOT / row["path"]
        if row["runner"] not in ("sh", "python3") or not path.is_file():
            raise SystemExit("invalid special test: " + row["id"])
        run(row["runner"], path)

def run(*args, env=ENV):
    print("+", " ".join(map(str, args)), flush=True)
    subprocess.run(list(map(str, args)), cwd=ROOT, env=env, check=True)

def main(suite):
    if suite == "verify":
        for name in VERIFY_PY:
            run(sys.executable, ROOT / "tools" / (name + ".py"))
        run_special("compat")
        run_special("validation")
    elif suite in ("das-fast", "das", "das-native"):
        das = Path(os.environ.get("DAS_ROOT", "../das")).resolve()
        if not (das / "das.c").is_file():
            raise SystemExit("invalid DAS_ROOT: " + str(das))
        env = dict(ENV, DAS_ROOT=str(das), DAIMOS_REPO=os.environ.get("DAIMOS_REPO", "../DAIMOS"))
        if suite == "das-native":
            run("sh", "misc/das/build-das-native-phases.sh", env=env)
        else:
            run("make", "-C", das, "PDP10_PREFIX=" + PREFIX, "all", env=env)
            for name in DAS_FAST:
                run("sh", "misc/das/" + name, env=env)
            if suite == "das":
                for name in ("run-das-tests.sh", "run-dobj-link-tests.sh"):
                    run("sh", "misc/das/" + name, env=env)
    elif suite == "gcc-bare-libgcc":
        run_special("gcc-bare-libgcc")
    elif suite == "pdp10-tools":
        repo = Path(os.environ.get("PDP10_TOOLS_REPO", "../DAIMOS/tools/host")).resolve()
        if not (repo / "Makefile").is_file():
            raise SystemExit("invalid PDP10_TOOLS_REPO: " + str(repo))
        run("sh", "misc/tools/run.sh", env=dict(ENV, PDP10_TOOLS_REPO=str(repo)))
    elif suite in ("kcc-regression", "kcc-all"):
        run_special("kcc-regression")
    elif suite == "compat":
        run_special("compat")
    elif suite == "kcc-host":
        # These scripts inspect/build the host KCC source tree, not CPU cells.
        run_special("kcc-host")
    elif suite == "kcc-semantic":
        run("./run-tests.sh", "--kind", "semantic")
    elif suite == "clean":
        for path in ("workdir", "__pycache__", "tools/__pycache__", "misc/das/__pycache__", "misc/kcc-regression/__pycache__", "misc/compat/__pycache__"):
            shutil.rmtree(ROOT / path, ignore_errors=True)
        for pattern in ("*~", "*.pyc"):
            for path in ROOT.rglob(pattern):
                if path.is_file():
                    path.unlink()
    else:
        raise SystemExit("unknown suite " + suite)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: run-misc-suites.py SUITE")
    main(sys.argv[1])
