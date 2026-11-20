#!/usr/bin/env python3
"""Host-only negative controls for installed freestanding source validation."""

import contextlib
import importlib.util
import io
import os
from pathlib import Path
import shutil
import tempfile


ROOT = Path(__file__).resolve().parent
SPEC = importlib.util.spec_from_file_location(
    "installed_freestanding_audit_v1",
    ROOT / "audit-installed-freestanding-v1.py")
AUDIT = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIT)


def check(prefix, expected):
    with contextlib.redirect_stderr(io.StringIO()), \
            contextlib.redirect_stdout(io.StringIO()):
        result = AUDIT.audit(prefix)
    assert (result == 0) == expected, (result, expected)


def main():
    installed = Path(os.environ["PDP10_PREFIX"])
    tempdir = Path(os.environ.get("TMPDIR") or Path.home() / "tmp")
    tempdir.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="p10tk-libc-audit-v1-",
                                     dir=str(tempdir)) as directory:
        prefix = Path(directory)
        dirs = ["lib/kcc/freestanding",
                "lib/gcc-lib/pdp10-dec-none/3.2/freestanding"]
        for subdir in dirs:
            target = prefix / subdir
            target.mkdir(parents=True)
            for name in set(AUDIT.MEMBERS.values()) | {
                    "libp10c-v2.a", "libp10ctype-c-locale-v1.a"}:
                shutil.copyfile(installed / subdir / name, target / name)
        check(prefix, True)
        file = prefix / dirs[0] / "kcc-libc-memmove-v1.s"
        original = file.read_text()
        file.write_text(original.replace("jrst memcpy", "jrst strcmp", 1))
        check(prefix, False)
        file.write_text(original)
        file = prefix / dirs[0] / "kcc-libc-strstr-v1.s"
        original = file.read_text()
        file.write_text(original.replace(".globl\tstrstr", ".globl\tmissing"))
        check(prefix, False)
        file.write_text(original)
        archive = prefix / dirs[1] / "libp10c-v2.a"
        data = archive.read_bytes()
        archive.write_bytes(data[:-1] + bytes([data[-1] ^ 1]))
        check(prefix, False)
        archive.write_bytes(data)
        check(prefix, True)
        ctype_archive = prefix / dirs[0] / "libp10ctype-c-locale-v1.a"
        data = ctype_archive.read_bytes()
        ctype_archive.write_bytes(data[:-1] + bytes([data[-1] ^ 1]))
        check(prefix, False)
        ctype_archive.write_bytes(data)
        check(prefix, True)
        ctype_archive.unlink()
        check(prefix, False)
    print("PASS: installed freestanding audit (baseline and 5 negative controls)")


if __name__ == "__main__":
    main()
