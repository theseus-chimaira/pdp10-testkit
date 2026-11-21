#!/usr/bin/env python3
"""Identify GCC 920501 duplicate vsprintf as overlapping libc providers.

This is a linker-input ownership audit, not a test-only hosted printf
implementation. It reuses source-pinned, real .dobj inputs from the
original failed PDP-6 GCC O0 run, with the installed canonical archives.
The successfully linked case is NOT a verified guest execution.
"""

import csv
import hashlib
import io
import os
from pathlib import Path
import re
import shutil
import subprocess
import tarfile
import tempfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = ROOT / "tests/todo/generic/920501-8.c"
ORIGINAL_SHA = "21884df76c9d24d4d4808d78de8e8a4e7909fffd1ee26a72f96f4be00a22b56a"
ARCHIVE = ROOT / "refs/p10tk-p1-920501-stdio-provider-20261120-v1.tar.gz"
MANIFEST = ROOT / "manifests/PDP10-P1-920501-STDIO-PROVIDER-EVIDENCE-20261120-v1.tsv"
LIBC_SHA = "c38253782d1ad94649c83f1751e49618608e1d7fd844ddff3a97c2c73b216091"
LIBGCC_SHA = "9bead1fd78365d1fa96f868c24e3234d035673e16db01301946f553aa4b097d2"
INPUTS = (
    "inputs/01-crt0.dobj", "inputs/02-920501-original.dobj",
    "inputs/03-exit.dobj", "inputs/04-abort.dobj",
    "inputs/05-formatter.dobj", "inputs/06-strcmp.dobj",
)
OTHER = (
    "cases/with-formatter.out", "cases/without-formatter.out",
    "cases/without-formatter.map", "cases/without-default-libc.out",
)
MEMBERS = set(INPUTS + OTHER)
FIELDS = ("member", "sha256", "size_bytes")
SENTENCES = {
    "cases/with-formatter.out": b"dlink: duplicate global: vsprintf\n",
    "cases/without-formatter.out": b"",
    "cases/without-default-libc.out": b"dlink: undefined symbol: printf\n",
}


def load_manifest():
    with MANIFEST.open(encoding="ascii", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def sha(data):
    return hashlib.sha256(data).hexdigest()


def validate(rows, archive_data):
    if (len(rows) != 10 or tuple(rows[0]) != FIELDS or
            {r["member"] for r in rows} != MEMBERS or
            len({r["member"] for r in rows}) != 10):
        raise ValueError("incomplete or malformed original linker evidence")
    if sha(ORIGINAL.read_bytes()) != ORIGINAL_SHA:
        raise ValueError("historical 920501 C source changed")
    data = {}
    try:
        with tarfile.open(fileobj=io.BytesIO(archive_data), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != 10 or {m.name for m in members} != MEMBERS or
                    any(not m.isfile() for m in members)):
                raise ValueError("unexpected 920501 linker-input archive member")
            for row in rows:
                name = row["member"]
                stream = tar.extractfile(name)
                if stream is None:
                    raise ValueError("missing original linker-input bytes")
                contents = stream.read()
                if (sha(contents) != row["sha256"] or
                        str(len(contents)) != str(row["size_bytes"])):
                    raise ValueError("original linker replay input changed")
                data[name] = contents
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("corrupt 920501 original linker object archive") from exc
    for name, expected in SENTENCES.items():
        if data[name] != expected:
            raise ValueError("linker conflict/missing-printf status rewritten")
    mapping = data["cases/without-formatter.map"].decode("ascii")
    for symbol in ("printf", "sprintf", "vsprintf", "vprintf", "__main"):
        if len(re.findall(r"^" + symbol + r"\s+[0-7]+\s*$",
                          mapping, re.M)) != 1:
            raise ValueError("libc must own exactly one " + symbol)
    return data


def find_prefix():
    prefix = Path(os.environ.get("PDP10_PREFIX", Path.home() / "cross"))
    installed = {
        "dlink": prefix / "bin/dlink",
        "objdump": prefix / "bin/pdp10-objdump",
        "libc": prefix / "lib/libc.a",
        "libgcc": prefix / "lib/gcc-lib/pdp10-dec-none/3.2/libgcc.a",
    }
    if any(not path.is_file() for path in installed.values()):
        raise ValueError("installed canonical cross tools not found")
    if (sha(installed["libc"].read_bytes()) != LIBC_SHA or
            sha(installed["libgcc"].read_bytes()) != LIBGCC_SHA):
        raise ValueError("installed libc/libgcc changed; reprobe provider ownership")
    return installed


def replay(data):
    """Exercise real current dlink; no guest or compiler-wide matrix run."""
    tool = find_prefix()
    tmp = Path(os.environ.get("TMPDIR", str(Path.home() / "tmp")))
    tmp.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="p10tk-stdio-owner-v1-", dir=tmp) as scratch:
        work = Path(scratch)
        objs = []
        for name in INPUTS:
            target = work / Path(name).name
            target.write_bytes(data[name])
            objs.append(target)
        count = 0
        for target in objs:
            result = subprocess.run([str(tool["objdump"]), "-t", str(target)],
                                    stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            if result.returncode:
                raise ValueError("pdp10-objdump could not inspect replay object")
            count += len(re.findall(rb"^\s*\d+ DEF\s+\S+\s+[0-7,]+ vsprintf$",
                                    result.stdout, re.M))
        if count != 1:
            raise ValueError("exact six inputs no longer have one vsprintf DEF")
        for name, formatter, default_libc in (
                ("with-formatter", True, True),
                ("without-formatter", False, True),
                ("without-default-libc", True, False)):
            cmd = [str(tool["dlink"]), "-o", str(work / (name + ".dxr")),
                   "-M", str(work / (name + ".map"))]
            cmd.extend(str(obj) for i, obj in enumerate(objs) if formatter or i != 4)
            if default_libc:
                cmd.append(str(tool["libc"]))
            cmd.append(str(tool["libgcc"]))
            result = subprocess.run(cmd, stdout=subprocess.PIPE,
                                    stderr=subprocess.STDOUT)
            expected = data["cases/" + name + ".out"]
            if result.stdout != expected or bool(result.returncode) == (name == "without-formatter"):
                raise ValueError("installed dlink provider reproduction changed: " + name)
            if name == "without-formatter":
                current_map = (work / (name + ".map")).read_bytes()
                if current_map != data["cases/without-formatter.map"]:
                    raise ValueError("linked default libc provider map changed")
    print("PASS: live dlink reproduces vsprintf provider collision; "
          "default libc alone links printf/sprintf/vsprintf once")


def audit(require_cross=False):
    data = validate(load_manifest(), ARCHIVE.read_bytes())
    print("PASS: pinned GCC 920501 original objects + 3 dlink scenarios "
          "show overlapping stdio provider ownership")
    if require_cross:
        replay(data)


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-cross", action="store_true")
    audit(parser.parse_args().require_cross)
