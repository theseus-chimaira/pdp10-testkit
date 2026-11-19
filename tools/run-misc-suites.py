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
import tempfile

ROOT = Path(__file__).resolve().parents[1]
PREFIX = os.environ["PDP10_PREFIX"]
TMP = os.environ.get("TMPDIR") or str(Path.home() / "tmp")
Path(TMP).mkdir(parents=True, exist_ok=True)
ENV = dict(os.environ, TMPDIR=TMP)

def registered_rows():
    with (ROOT / "SPECIAL_TESTS.tsv").open(encoding="utf-8") as source:
        return list(csv.DictReader(source, delimiter="\t"))


def run_selected(test_id, allow_manual=False):
    """Execute exactly one registered root, never a nested helper.

    The direct registry owns the timeout and runner.  Manual roots
    require two explicit choices: the exact ID and --manual.  Do not
    silently reproduce group setup for DAS or independent tools: those
    suites prepare their sources/images before running any child.  The
    manual DAS native-build root is self-contained and prepares its own
    phase images, so it is safe to select individually.
    """
    matches = [row for row in registered_rows() if row["id"] == test_id]
    if len(matches) != 1:
        raise SystemExit("unknown or duplicate registered test ID: " + test_id)
    row = matches[0]
    if row["group"] == "das" and row["profile"] == "nested":
        raise SystemExit("nested DAS helper must run through its owning suite: "
                         + test_id)
    if row["enabled"] not in ("manual", "yes"):
        raise SystemExit("test is not enabled: " + test_id)
    if row["enabled"] == "manual" and not allow_manual:
        raise SystemExit("manual test requires explicit --manual: " + test_id)
    if row["group"] in ("das", "tools") and not (
            test_id == "das-build-das-native" and row["enabled"] == "manual"):
        raise SystemExit("test requires suite preparation; use its named "
                         "suite instead: " + test_id)
    if row["runner"] not in ("sh", "python3"):
        raise SystemExit("invalid registered test runner: " + test_id)
    path = (ROOT / row["path"]).resolve()
    if not path.is_relative_to(ROOT) or not path.is_file():
        raise SystemExit("invalid registered test path: " + test_id)
    try:
        timeout = int(row["timeout"])
    except ValueError:
        raise SystemExit("invalid registered test timeout: " + test_id)
    if timeout <= 0:
        raise SystemExit("nonpositive registered test timeout: " + test_id)
    env = ENV
    if row["group"] == "kcc-host":
        kcc = Path(os.environ.get("KCC_REPO", "../kcc")).resolve()
        if not (kcc / "cc.c").is_file():
            raise SystemExit("invalid KCC_REPO: " + str(kcc))
        env = dict(ENV, KCC_REPO=str(kcc))
    print("selected %s [%s, %s] timeout=%ds" %
          (test_id, row["group"], row["enabled"], timeout), flush=True)
    if test_id == "deferred-libc-probe-v1":
        # Unlike the other manual roots, this diagnostic deliberately has
        # no default source. Require an explicit user-selected fixture;
        # never run an unrelated test simply to make the root pass.
        source = os.environ.get("PDP10_DEFERRED_LIBC_SOURCE")
        if not source:
            raise SystemExit("deferred-libc-probe-v1 requires "
                             "PDP10_DEFERRED_LIBC_SOURCE under tests/")
        run(row["runner"], path, "--source", source, env=env,
            timeout=timeout)
    else:
        run(row["runner"], path, env=env, timeout=timeout)
    print("PASS selected registered test: " + test_id, flush=True)


def run_special(group, env=ENV, profiles=None):
    failures = []
    executed = 0
    for row in registered_rows():
        if (row["group"] != group or row["enabled"] != "yes" or
                (profiles is not None and row["profile"] not in profiles)):
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
            if group == "tools":
                print("PASS %s" % row["id"], flush=True)
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
            failures += run_special("das", env=env, profiles={"native"})
        else:
            run("make", "-C", das, "PDP10_PREFIX=" + PREFIX, "all", env=env)
            failures += run_special("das", env=env, profiles={"fast"})
            if suite == "das":
                failures += run_special("das", env=env, profiles={"full"})
    elif suite == "gcc-bare-libgcc":
        failures += run_special("gcc-bare-libgcc")
    elif suite == "pdp10-tools":
        repo = Path(os.environ.get("PDP10_TOOLS_REPO", "../pdp10-tools")).resolve()
        if not all((repo / name).is_file() for name in
                   ("Makefile", "dobj.c", "p10run.c", "p10fold.c")):
            raise SystemExit("invalid PDP10_TOOLS_REPO: " + str(repo))
        # Snapshot and build the independent repository exactly once. Each
        # registered utility test then receives the same private build root;
        # per-case failures are recorded independently and cleanup is always
        # performed, including after a failed prepare or timed-out case.
        with tempfile.TemporaryDirectory(prefix="pdp10-tools-registry-v2.",
                                         dir=TMP) as work:
            env = dict(ENV, PDP10_TOOLS_REPO=str(repo),
                       PDP10_TOOLS_WORK=work)
            run("sh", ROOT / "misc/tools/prepare-v2.sh", work,
                env=env, timeout=240)
            failures += run_special("tools", env=env)
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
    if len(sys.argv) == 2 and sys.argv[1] == "list-manual":
        for row in registered_rows():
            if row["enabled"] == "manual":
                print("%s\t%s\t%s\t%s" %
                      (row["id"], row["group"], row["profile"], row["path"]))
    elif len(sys.argv) in (3, 4) and sys.argv[1] == "run-id":
        if len(sys.argv) == 4 and sys.argv[3] != "--manual":
            raise SystemExit("usage: run-id TEST_ID [--manual]")
        run_selected(sys.argv[2], allow_manual=len(sys.argv) == 4)
    elif len(sys.argv) == 2:
        main(sys.argv[1])
    else:
        raise SystemExit("usage: run-misc-suites.py SUITE | "
                         "run-id TEST_ID [--manual] | list-manual")
