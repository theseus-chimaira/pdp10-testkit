"""Auxiliary test suite dispatcher for run-tests.sh.

Ordered suite commands are intentionally explicit, preserving the former
Makefile's verification list rather than running unrelated globbed scripts.
"""
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
PREFIX = os.environ["PDP10_PREFIX"]
TMP = os.environ.get("TMPDIR") or str(Path.home() / "tmp")
Path(TMP).mkdir(parents=True, exist_ok=True)
ENV = dict(os.environ, TMPDIR=TMP)

VERIFY_PY = """verify-testkit-layout verify-optimization-common-source check-gcc-symbol-length test-stubselect verify-type-semantics verify-wide-int-adapters""".split()
VERIFY_SH = """int71-header wide-int-modes wide-call-abi wide-varargs-abi wide-data-layout pointer-abi aggregate-return-abi extended-aggregate-abi layout-float-abi symbol-runtime-abi-v11 mixed-fixed-exec-v12 mixed-call-depth-v24 small-aggregate-arg-abi-v25 gcc-cross-word-bitfield-v26 kcc-gcc-cross-word-bitfield-v27 kcc-gcc-aggregate-stack-v28 kcc-gcc-nested-union-v29 kcc-gcc-varargs-matrix-v30 kcc-gcc-layout-edge-v31 kcc-gcc-negative-dimode-v32 gcc-dimode-divmod-v33 kcc-gcc-runtime-helper-v34 kcc-gcc-reloc-v35 kcc-gcc-direct-abi-v36 kcc-gcc-object-symbol-v37 kcc-gcc-representation-adapter-v38 gcc-scalar-move-order-v39 gcc-callee-save-pushpop-v41 language-compat-v13 language-promotions-v14 language-casts-v15 language-conversions-v17 language-full-range-v18 language-direct-widening-v19 language-char-enum-v20 packed-char-v21 packed-bitptr-v22 packed-bitptr-arith-v23""".split()
DAS_FAST = """run-das-fast-tests.sh check-das-phase-ir-v1.sh check-das-phase2-transport-v1.sh check-reloc-negative-addend-v1.sh check-symbol-leading-data-v1.sh check-s6filter.sh run-das-stream-tests.sh check-s6text.sh""".split()

def run(*args, env=ENV):
    print("+", " ".join(map(str, args)), flush=True)
    subprocess.run(list(map(str, args)), cwd=ROOT, env=env, check=True)

def main(suite):
    if suite == "verify":
        for name in VERIFY_PY:
            run(sys.executable, ROOT / "tools" / (name + ".py"))
        for name in VERIFY_SH:
            run("sh", ROOT / "tests/compat" / ("test-" + name + ".sh"))
        run("sh", ROOT / "tests/validation/gcc/byteptr2/test-no-xkl2-byte-extend-v40.sh")
    elif suite in ("das-fast", "das", "das-native"):
        das = Path(os.environ.get("DAS_ROOT", "../das")).resolve()
        if not (das / "das.c").is_file():
            raise SystemExit("invalid DAS_ROOT: " + str(das))
        env = dict(ENV, DAS_ROOT=str(das), DAIMOS_REPO=os.environ.get("DAIMOS_REPO", "../DAIMOS"))
        if suite == "das-native":
            run("sh", "tests/das/build-das-native-phases-v1.sh", env=env)
        else:
            run("make", "-C", das, "PDP10_PREFIX=" + PREFIX, "all", env=env)
            for name in DAS_FAST:
                run("sh", "tests/das/" + name, env=env)
            if suite == "das":
                for name in ("run-das-tests.sh", "run-dobj-link-tests.sh"):
                    run("sh", "tests/das/" + name, env=env)
    elif suite == "gcc-bare-libgcc":
        run("sh", "tests/validation/gcc/bare-runtime/test-badl-tables-v1.sh")
    elif suite == "pdp10-tools":
        repo = Path(os.environ.get("PDP10_TOOLS_REPO", "../DAIMOS/tools/host")).resolve()
        if not (repo / "Makefile").is_file():
            raise SystemExit("invalid PDP10_TOOLS_REPO: " + str(repo))
        run("sh", "tests/pdp10-tools/run.sh", env=dict(ENV, PDP10_TOOLS_REPO=str(repo)))
    elif suite.startswith("kcc-"):
        modes = {"kcc-regression": "fast", "kcc-semantic": "semantic", "kcc-all": "all"}
        if suite not in modes:
            raise SystemExit("unknown suite " + suite)
        run("sh", "./run-kcc-regressions.sh", modes[suite])
    elif suite == "clean":
        for path in ("workdir", "__pycache__", "tools/__pycache__", "tests/das/__pycache__"):
            shutil.rmtree(ROOT / path, ignore_errors=True)
        for pattern in ("*~", "*.pyc"):
            for path in ROOT.rglob(pattern):
                if path.is_file():
                    path.unlink()
    else:
        raise SystemExit("unknown suite " + suite)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: p10tk-suites-v1.py SUITE")
    main(sys.argv[1])
