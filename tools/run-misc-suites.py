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

DAS_FAST = """run-das-fast-tests.sh check-das-phase-ir.sh check-das-phase2-transport.sh check-reloc-negative-addend.sh check-symbol-leading-data.sh check-s6filter.sh run-das-stream-tests.sh check-s6text.sh""".split()

def run_special(group, env=ENV):
    failures = []
    executed = 0
    with (ROOT / "SPECIAL_TESTS.tsv").open(encoding="utf-8") as f:
        rows = list(csv.DictReader(f, delimiter="\t"))
    for row in rows:
        if row["group"] != group or row["enabled"] != "yes":
            continue
        executed += 1
        path = ROOT / row["path"]
        if row["runner"] not in ("sh", "python3") or not path.is_file():
            failures.append((row["id"], "invalid runner or path"))
            continue
        try:
            timeout = int(row["timeout"])
            if timeout <= 0:
                raise ValueError("timeout must be positive")
            run(row["runner"], path, env=env, timeout=timeout)
        except (SystemExit, ValueError) as error:
            failures.append((row["id"], str(error)))
    print("suite %s: %d executed, %d passed, %d failed" %
          (group, executed, executed - len(failures), len(failures)), flush=True)
    for name, cause in failures:
        print("FAIL %s: %s" % (name, cause), flush=True)
    return len(failures)

def run(*args, env=ENV, timeout=None):
    print("+", " ".join(map(str, args)), flush=True)
    try:
        subprocess.run(list(map(str, args)), cwd=ROOT, env=env, check=True,
                       timeout=timeout)
    except subprocess.TimeoutExpired:
        raise SystemExit("timeout after %d seconds: %s" %
                         (timeout, " ".join(map(str, args))))
    except subprocess.CalledProcessError as error:
        raise SystemExit("special test failed (exit %d): %s" %
                         (error.returncode, " ".join(map(str, args))))

def main(suite):
    failures = 0
    if suite == "verify":
        failures += run_special("verify")
        failures += run_special("compat")
        failures += run_special("validation")
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
        failures += run_special("gcc-bare-libgcc")
    elif suite == "pdp10-tools":
        repo = Path(os.environ.get("PDP10_TOOLS_REPO", "../DAIMOS/tools/host")).resolve()
        if not (repo / "Makefile").is_file():
            raise SystemExit("invalid PDP10_TOOLS_REPO: " + str(repo))
        # The registry owns this aggregate; its prerequisites are supplied
        # explicitly rather than reimplementing its constituent test script.
        failures += run_special("tools", env=dict(ENV, PDP10_TOOLS_REPO=str(repo)))
    elif suite == "kcc-regression":
        failures += run_special("kcc-regression")
    elif suite == "kcc-all":
        failures += run_special("kcc-regression")
        kcc = Path(os.environ.get("KCC_REPO", "../kcc")).resolve()
        if not (kcc / "cc.c").is_file():
            raise SystemExit("invalid KCC_REPO: " + str(kcc))
        failures += run_special("kcc-host", env=dict(ENV, KCC_REPO=str(kcc)))
    elif suite == "compat":
        failures += run_special("compat")
    elif suite == "kcc-host":
        # These scripts inspect/build the host KCC source tree, not CPU cells.
        kcc = Path(os.environ.get("KCC_REPO", "../kcc")).resolve()
        if not (kcc / "cc.c").is_file():
            raise SystemExit("invalid KCC_REPO: " + str(kcc))
        failures += run_special("kcc-host", env=dict(ENV, KCC_REPO=str(kcc)))
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
    if failures:
        raise SystemExit("%d special test(s) failed in %s" % (failures, suite))

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: run-misc-suites.py SUITE")
    main(sys.argv[1])
