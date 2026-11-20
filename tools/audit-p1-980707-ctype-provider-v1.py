#!/usr/bin/env python3
"""Audit KCC 980707 exit/abort ownership when hosted libc supplies isspace.

The original KCC PDP-6 test links a private __test_exit-aware exit and
abort. The default libc archive also supplies both while resolving
isspace. Link-only success without private routines is not guest PASS.
"""

import csv
import hashlib
import io
import os
from pathlib import Path
import re
import subprocess
import tarfile
import tempfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = ROOT / "tests/todo/generic/980707-1.c"
ORIGINAL_SHA = "43c389a719d17d876d0f9f942d5db81f737c8eed7608de204862f23a6359e7b7"
ARCHIVE = ROOT / "refs/p10tk-p1-980707-ctype-provider-20261120-v1.tar.gz"
MANIFEST = ROOT / "docs/PDP10-P1-980707-CTYPE-PROVIDER-EVIDENCE-20261120-v1.tsv"
LIBC_SHA = "c38253782d1ad94649c83f1751e49618608e1d7fd844ddff3a97c2c73b216091"
LIBGCC_SHA = "9bead1fd78365d1fa96f868c24e3234d035673e16db01301946f553aa4b097d2"
INPUTS = (
    "inputs/01-crt0.dobj", "inputs/02-original.dobj",
    "inputs/03-exit.dobj", "inputs/04-abort.dobj",
    "inputs/05-strcmp.dobj", "inputs/06-string.dobj",
)
CASES = (
    ("with-test-exit-abort", (0, 1, 2, 3, 4, 5), True, False,
     b"dlink: duplicate global: exit\n"),
    ("without-test-exit", (0, 1, 3, 4, 5), True, False,
     b"dlink: duplicate global: abort\n"),
    ("without-test-exit-abort", (0, 1, 4, 5), True, True, b""),
    ("without-default-libc", (0, 1, 2, 3, 4, 5), False, False,
     b"dlink: undefined symbol: isspace\n"),
    ("libc-only", (0, 1), True, True, b""),
)
MEMBERS = set(INPUTS)
for case in CASES:
    MEMBERS.add("cases/" + case[0] + ".out")
    if case[3]:
        MEMBERS.add("cases/" + case[0] + ".map")
FIELDS = ("member", "sha256", "size_bytes")


def digest(data):
    return hashlib.sha256(data).hexdigest()


def load():
    with MANIFEST.open(encoding="ascii", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def verify(rows, payload):
    if (len(rows) != 13 or tuple(rows[0]) != FIELDS or
            {r["member"] for r in rows} != MEMBERS or
            len({r["member"] for r in rows}) != 13):
        raise ValueError("980707 original object/case inventory is invalid")
    if digest(ORIGINAL.read_bytes()) != ORIGINAL_SHA:
        raise ValueError("980707 historical source changed")
    data = {}
    try:
        with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != 13 or {m.name for m in members} != MEMBERS or
                    any(not m.isfile() for m in members)):
                raise ValueError("unsafe or missing 980707 linker artifact")
            for row in rows:
                stream = tar.extractfile(row["member"])
                if stream is None:
                    raise ValueError("missing 980707 object or map")
                content = stream.read()
                if (digest(content) != row["sha256"] or
                        str(len(content)) != str(row["size_bytes"])):
                    raise ValueError("original 980707 linker object digest mismatch")
                data[row["member"]] = content
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("980707 evidence archive is corrupt") from exc
    for name, slots, libc, success, message in CASES:
        if data["cases/" + name + ".out"] != message:
            raise ValueError("980707 duplicate/undefined diagnostic changed")
        if success:
            symbols = data["cases/" + name + ".map"].decode("ascii")
            for sym in ("exit", "abort", "isspace", "strcpy", "strcmp",
                        "main", "__test_exit"):
                if len(re.findall(r"^" + sym + r"\s+[0-7]+\s*$",
                                  symbols, re.M)) != 1:
                    raise ValueError("default libc map lacks one " + sym)
    return data


def cross_tools():
    prefix = Path(os.environ.get("PDP10_PREFIX", Path.home() / "cross"))
    paths = {
        "dlink": prefix / "bin/dlink",
        "objdump": prefix / "bin/pdp10-objdump",
        "libc": prefix / "lib/libc.a",
        "libgcc": prefix / "lib/gcc-lib/pdp10-dec-none/3.2/libgcc.a",
    }
    if any(not path.is_file() for path in paths.values()):
        raise ValueError("canonical PDP-10 linker and archives unavailable")
    if (digest(paths["libc"].read_bytes()) != LIBC_SHA or
            digest(paths["libgcc"].read_bytes()) != LIBGCC_SHA):
        raise ValueError("production archive changed; update original evidence")
    return paths


def replay(data):
    tools = cross_tools()
    tmp = Path(os.environ.get("TMPDIR", str(Path.home() / "tmp")))
    tmp.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="p10tk-ctype-owner-v1-", dir=tmp) as scratch:
        work = Path(scratch)
        objects = []
        for name in INPUTS:
            path = work / Path(name).name
            path.write_bytes(data[name])
            objects.append(path)
        counts = {"exit": 0, "abort": 0}
        for path in objects:
            result = subprocess.run([str(tools["objdump"]), "-t", str(path)],
                                    stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            if result.returncode:
                raise ValueError("cannot inspect exact original linker object")
            for symbol in counts:
                counts[symbol] += len(re.findall(
                    rb"^\s*\d+ DEF\s+\S+\s+[0-7,]+ " +
                    symbol.encode("ascii") + rb"$", result.stdout, re.M))
        if counts != {"exit": 1, "abort": 1}:
            raise ValueError("explicit 980707 objects no longer single-owner")
        for name, selected, with_libc, expect_success, expected in CASES:
            cmd = [str(tools["dlink"]), "-o", str(work / (name + ".dxr")),
                   "-M", str(work / (name + ".map"))]
            cmd.extend(str(objects[i]) for i in selected)
            if with_libc:
                cmd.append(str(tools["libc"]))
            cmd.append(str(tools["libgcc"]))
            result = subprocess.run(cmd, stdout=subprocess.PIPE,
                                    stderr=subprocess.STDOUT)
            if (result.stdout != expected or
                    (result.returncode == 0) != expect_success):
                raise ValueError("980707 linked runtime ownership changed: " + name)
            if expect_success and (work / (name + ".map")).read_bytes() != data[
                    "cases/" + name + ".map"]:
                raise ValueError("980707 linked libc symbol address map changed")
    print("PASS: live dlink identifies default-libc exit/abort conflict "
          "when resolving real isspace; guest execution untested")


def audit(require_cross=False):
    data = verify(load(), ARCHIVE.read_bytes())
    print("PASS: original 980707 six KCC objects and five source-pinned "
          "default-libc linking comparisons")
    if require_cross:
        replay(data)


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-cross", action="store_true")
    audit(parser.parse_args().require_cross)
