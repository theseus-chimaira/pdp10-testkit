#!/usr/bin/env python3
"""Fail-closed compiler-only libc routing for special test dispatch.

Runs the real installed-prefix policy but mocks all registered commands.
This is a dispatch/ownership test, not a compiler/CPU sweep.
"""

import contextlib
import importlib.util
import io
import os
from pathlib import Path
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

from compiler_stdlib_prefix_v1 import (
    POLICY, archive_path, archive_sha256, prepare_shared)


def module():
    spec = importlib.util.spec_from_file_location(
        "p10tk_special_compiler_libc_v1", ROOT / "tools/run-misc-suites.py")
    value = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(value)
    return value


def check_compiler_env(env, original):
    base = Path(env["PDP10_PREFIX"])
    assert base != original
    library = base / "lib/libc.a"
    assert library.is_symlink()
    assert library.resolve() == archive_path(original, "gcc")
    assert archive_sha256(original, "kcc") == archive_sha256(original, "gcc")
    assert env["P10TK_RUNTIME_POLICY"] == POLICY
    assert (base / "bin/p10run").is_file()
    assert (base / "lib/kcc/freestanding/libp10c-v2.a").is_file()
    assert (base / "lib/gcc-lib/pdp10-dec-none/3.2/freestanding/libp10c-v2.a").is_file()


def main():
    dispatch = module()
    original_prefix = Path(dispatch.PREFIX).resolve()
    base = Path(os.environ.get("TMPDIR") or Path.home() / "tmp")
    base.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="p10tk-special-libc-dispatch-v1-",
                                     dir=base) as testdir:
        # A mixed-compiler script must reject unlike KCC/GCC archive
        # bytes instead of arbitrarily selecting one compiler's ABI.
        root = Path(testdir)
        fake = root / "fake"
        (fake / "bin").mkdir(parents=True)
        kcc = fake / "lib/kcc/freestanding/libp10c-v2.a"
        gcc = fake / "lib/gcc-lib/pdp10-dec-none/3.2/freestanding/libp10c-v2.a"
        kcc.parent.mkdir(parents=True)
        gcc.parent.mkdir(parents=True)
        kcc.write_bytes(b"compiler-kcc-library")
        gcc.write_bytes(b"compiler-gcc-library")
        try:
            prepare_shared(root, fake)
        except ValueError as exc:
            assert "differ" in str(exc)
        else:
            raise AssertionError("mixed compiler ABI archives were silently merged")

        calls = []
        original_run = dispatch.run

        def record(*args, **kwargs):
            calls.append((tuple(str(arg) for arg in args), kwargs.get("env")))

        dispatch.run = record
        try:
            for test_id in ("upstream-crt-v1", "kcc-pdp6-float-literal-v1",
                            "gcc-9bit-data-section-v1",
                            "compiler-stdlib-prefix-v1"):
                calls[:] = []
                with contextlib.redirect_stdout(io.StringIO()):
                    dispatch.run_selected(test_id)
                assert len(calls) == 1, test_id
                check_compiler_env(calls[0][1], original_prefix)

            for group in ("verify", "compat", "validation",
                          "kcc-regression", "gcc-bare-libgcc"):
                calls[:] = []
                with contextlib.redirect_stdout(io.StringIO()):
                    failures = dispatch.run_special(group)
                assert failures == 0 and calls, group
                for _args, env in calls:
                    check_compiler_env(env, original_prefix)

            for group in ("kcc-host", "tools", "das"):
                calls[:] = []
                with contextlib.redirect_stdout(io.StringIO()):
                    failures = dispatch.run_special(group)
                assert failures == 0 and calls, group
                for _args, env in calls:
                    # The parent dispatcher may itself have selected a
                    # compiler-only prefix. Host/tool groups must retain
                    # the incoming environment, not create a fresh one.
                    assert env["PDP10_PREFIX"] == dispatch.ENV["PDP10_PREFIX"]
                    assert (env.get("P10TK_RUNTIME_POLICY") ==
                            dispatch.ENV.get("P10TK_RUNTIME_POLICY"))
        finally:
            dispatch.run = original_run
    print("PASS: special dispatcher compiler-only libc routing "
          "(4 exact IDs, 5 guest groups, 3 host/tool groups, "
          "incompatible archive negative control)")


if __name__ == "__main__":
    main()
