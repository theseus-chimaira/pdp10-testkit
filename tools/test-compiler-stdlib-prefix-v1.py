#!/usr/bin/env python3
"""Fail-closed tests for compiler-owned PDP-10 runtime library policy."""

import importlib.util
import os
from pathlib import Path
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

from compiler_stdlib_prefix_v1 import (
    POLICY, archive_path, archive_sha256, env_for_cell,
    overlay_path, prepare, prepare_script_prefix)


def fail(call, description):
    try:
        call()
    except ValueError:
        return
    raise AssertionError("accepted incorrect compiler library: " + description)


def runner():
    spec = importlib.util.spec_from_file_location(
        "p10tk_runner_compiler_stdlib_v1", ROOT / "tools/run-tests.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def main():
    installed = Path(os.environ["PDP10_PREFIX"]).resolve()
    stdlib = {name: archive_path(installed, name) for name in ("kcc", "gcc")}
    assert stdlib["kcc"] != installed / "lib/libc.a"
    assert stdlib["gcc"] != installed / "lib/libc.a"
    for name in ("kcc", "gcc"):
        assert stdlib[name].is_file() and len(archive_sha256(installed, name)) == 64
    count = 0

    base = Path(os.environ.get("TMPDIR") or Path.home() / "tmp")
    base.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="p10tk-compiler-stdlib-v1-",
                                     dir=base) as work:
        testroot = Path(work)
        prefix = testroot / "prefix"
        (prefix / "bin").mkdir(parents=True)
        (prefix / "lib/kcc/freestanding").mkdir(parents=True)
        (prefix / "lib/gcc-lib/pdp10-dec-none/3.2/freestanding").mkdir(parents=True)
        (prefix / "lib/libc.a").write_bytes(b"DAIMOS_UNRELATED_ARCHIVE")
        sources = {}
        for compiler in ("kcc", "gcc"):
            source = prefix / ("lib/kcc/freestanding/libp10c-v2.a"
                                if compiler == "kcc" else
                                "lib/gcc-lib/pdp10-dec-none/3.2/freestanding/libp10c-v2.a")
            source.write_bytes(("genuine-%s-compiler-archive" % compiler).encode("ascii"))
            sources[compiler] = source.resolve()
        outputs = prepare(testroot, prefix, ("kcc", "gcc"))
        for compiler in ("kcc", "gcc"):
            overlay = outputs[compiler]
            assert overlay == overlay_path(testroot, compiler)
            assert (overlay / "lib/libc.a").is_symlink()
            assert (overlay / "lib/libc.a").resolve() == sources[compiler]
            assert (overlay / "lib/libc.a").read_bytes() != b"DAIMOS_UNRELATED_ARCHIVE"
            env = env_for_cell(testroot, prefix, compiler, {"TEST_STDLIB": "1"})
            assert env["PDP10_PREFIX"] == str(overlay) and env["TEST_STDLIB"] == "1"
            assert archive_sha256(prefix, compiler) in (
                overlay / "compiler-stdlib-policy-v1.txt").read_text(encoding="ascii")
        assert outputs == prepare(testroot, prefix, ("kcc", "gcc"))

        # A GCC-only direct script must keep its compiler-only runtime
        # even when the KCC archive has different bytes (unlike a mixed
        # compiler special suite, which intentionally fails closed).
        isolated = prepare_script_prefix(testroot / "raw-gcc", prefix, "gcc")
        assert (isolated / "lib/libc.a").resolve() == sources["gcc"]
        assert (isolated / "lib/gcc-lib").resolve() == (
            prefix / "lib/gcc-lib").resolve()

        fail(lambda: archive_path(prefix, "unknown"), "unknown compiler")
        count += 1
        bad = prefix / "lib/kcc/freestanding/libp10c-v2.a"
        bad.unlink()
        fail(lambda: prepare(testroot, prefix, ("kcc",)), "missing compiler archive")
        bad.write_bytes(b"genuine-kcc-compiler-archive")
        count += 1
        with bad.open("ab") as stream:
            stream.write(b"-changed")
        fail(lambda: prepare(testroot, prefix, ("kcc",)), "changed archive fingerprint")
        count += 1
        solo = prepare_script_prefix(testroot / "raw-gcc-mismatch", prefix, "gcc")
        assert (solo / "lib/libc.a").resolve() == sources["gcc"]
        count += 1
        bad.write_bytes(b"genuine-kcc-compiler-archive")
        link = overlay_path(testroot, "gcc") / "lib/libc.a"
        link.unlink()
        link.symlink_to(prefix / "lib/libc.a")
        fail(lambda: prepare(testroot, prefix, ("gcc",)), "hosted OS libc redirected")
        count += 1
        fail(lambda: env_for_cell(testroot, prefix, "gcc"), "wrong runtime symlink")
        count += 1
        link.unlink()
        link.write_bytes(b"not-a-compiler-library-link")
        fail(lambda: prepare(testroot, prefix, ("gcc",)),
             "foreign regular libc.a in compiler prefix")
        count += 1
        stamp = overlay_path(testroot, "kcc") / "compiler-stdlib-policy-v1.txt"
        stamp.unlink()
        stamp.symlink_to(prefix / "lib/libc.a")
        fail(lambda: prepare(testroot, prefix, ("kcc",)),
             "runtime policy marker redirected outside prefix")
        count += 1

        # A semantic checkpoint from the previous default-libc policy
        # must not be reused as an accepted compiler-stdlib PASS.
        run = runner()
        target = testroot / "checkpoints"
        src = "tests/semantic/regression/pdp10-record-fetch-copy-v1.c"
        cell = {"compiler": "gcc", "profile": "gcc-pdp6-o0",
                "machine": "pdp6", "kind": "semantic"}
        run.write_status_file(target, [src, "pdp6", "gcc", "gcc-pdp6-o0",
                                       "semantic", "pass", "0.1", "", "synthetic"])
        assert run.read_cell_status(target, src, cell)["status"] == "pass"
        status = run.status_path(target, src, cell)
        contents = status.read_text(encoding="ascii")
        assert "runtime_library_policy=" + POLICY in contents
        status.write_text(contents.replace("runtime_library_policy=" + POLICY,
                                          "runtime_library_policy=legacy-hosted"),
                          encoding="ascii")
        assert run.read_cell_status(target, src, cell) is None
        count += 1
        status.write_text(contents.replace("runtime_library_sha256=",
                                          "runtime_library_sha256=incorrect-"),
                          encoding="ascii")
        assert run.read_cell_status(target, src, cell) is None
        count += 1
        status.write_text("\n".join(
            line for line in contents.splitlines()
            if not line.startswith("runtime_library_policy=")) + "\n",
            encoding="ascii")
        assert run.read_cell_status(target, src, cell) is None
        count += 1
        status.write_text(contents, encoding="ascii")
        rerun, _other, counts, _statuses = run.plan_restart(
            target, [(src, cell)], [], False)
        assert not rerun and counts["old_green"] == 1

    print("PASS: compiler stdlib library isolation and stale checkpoint "
          "rejection (%d controls); no DAIMOS libc selected" % count)


if __name__ == "__main__":
    main()
