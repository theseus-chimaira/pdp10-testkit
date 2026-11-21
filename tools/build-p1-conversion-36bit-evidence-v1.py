#!/usr/bin/env python3
"""Reproduce the exact native PDP-6 36-bit conversion checkpoint.

--write collects the named, previously executed versioned guest output
directories under TMPDIR.  Default mode checks the retained manifest,
all preserved raw outputs and the installed-freezing source identities.
It never executes or substitutes a test guest in verification mode.
"""

import argparse
import csv
import gzip
import hashlib
import io
import os
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
TMP = Path(os.environ.get("TMPDIR") or Path.home() / "tmp")
MANIFEST = ROOT / "manifests/PDP10-P1-CONVERSION-36BIT-REPAIR-EVIDENCE-20261120-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-conversion-36bit-repair-20261120-v1.tar.gz"
PROFILES = ("kcc-pdp6-noopt", "kcc-pdp6-opt", "gcc-pdp6-o0",
            "gcc-pdp6-o1", "gcc-pdp6-o2", "gcc-pdp6-os")
ORIGINAL = "tests/semantic/upstream/pdp10/pdp10/conversion.c"
CASES = (
    ("signed-pre", "tests/semantic/regression/pdp10-fp-signed-conversion-v1.c",
     "p10tk-p1-conversion-signed-next-20261120-v1", "run_fail"),
    ("signed-final", "tests/semantic/regression/pdp10-fp-signed-conversion-v1.c",
     "p10tk-p1-conversion-final-signed-24-20261120-v1", "pass"),
    ("signed-locator-final", "tests/semantic/regression/pdp10-fp-conversion-locator-v1.c",
     "p10tk-p1-conversion-final-signed-locator-20261120-v1", "pass"),
    ("unsigned-final", "tests/semantic/regression/pdp10-fp-unsigned36-locator-v1.c",
     "p10tk-p1-conversion-final-unsigned-23-20261120-v1", "pass"),
    ("unsigned-sf-final", "tests/semantic/regression/pdp10-fp-unsigned36-sf-v1.c",
     "p10tk-p1-conversion-final-unsigned-sf-14-20261120-v1", "pass"),
    ("signed-boundary-final", "tests/semantic/regression/pdp10-fp-signed36-boundary-v1.c",
     "p10tk-p1-conversion-final-signed-boundary-22-20261120-v1", "pass"),
    ("original-current", ORIGINAL,
     "p10tk-p1-conversion-final-original-20261120-v1", "original"),
    ("original-line-current",
     "tests/semantic/regression/pdp10-conversion-original-line-v1.c",
     "p10tk-p1-conversion-final-line-20261120-v1", "original"),
)
SOURCE_SHAS = {
    "tests/semantic/regression/pdp10-fp-signed-conversion-v1.c":
        "90a627b3d14f427826fbc6291638824a485e95e65f1f451684b94a7c2ed468e5",
    "tests/semantic/regression/pdp10-fp-conversion-locator-v1.c":
        "0cd4d868658cdb3ab030eec8653ca96f445ec9cb29d4acbd870d58b583abd9d2",
    "tests/semantic/regression/pdp10-fp-unsigned36-locator-v1.c":
        "35ed78ec9781acea3af5e82cb5f2fffd482fdfda960a3e82cece0c7b97bcc926",
    "tests/semantic/regression/pdp10-fp-unsigned36-sf-v1.c":
        "4bcbc3f752fbc9ce419be8400356544b85d139201f7dfbabb40451a5b07a6c98",
    "tests/semantic/regression/pdp10-fp-signed36-boundary-v1.c":
        "d2104c81d398e4e23dd11ea8d9e4999e740166549c584b0e5b470b95899454a5",
    "tests/semantic/regression/pdp10-conversion-original-line-v1.c":
        "87234db87df7c5ca644cd951250571a6d3aeaf0d1d2eed899299247e73a6d950",
    ORIGINAL:
        "2736912e40e1dabd84f7f193ddaaf5ddf9bf00e76edb0cca0611b3f49e5c1beb",
}
CORE = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
KFP = "de4aa2f79db32c5c95747a658c2f4d6366e69efbb626b0f2ff3b21f847e2e7b2"
GFP = "afd520fbbff5db32466d887e49136f09ee2c4517b63eded83325cd721505f960"
TOOL = {"kcc": "0574417c52be0fdd7e4595ba4a23a91967a703f8cd522b9d7c58688985b7a35b",
        "gcc": "67ebf49eb2d7eb896b7f95e0aab9bab3f94c148ce914297f4ff1cf1c61cedfc7"}
ORIGINAL_LIBGCC = "9bead1fd78365d1fa96f868c24e3234d035673e16db01301946f553aa4b097d2"
KFP_SOURCE = "69eaf3c43297b67955adcb77bdde3b54ea785900102bbf9850ea226296dfa6b4"
KINDS = ("log", "status", "asm", "map", "report")
EXT = {"log": ".log.txt", "status": ".status", "asm": ".s",
       "map": ".map", "report": ".report.txt"}
METADATA = ("role", "source", "source_sha256", "profile", "cpu",
            "status", "fail_id", "compiler_sha256", "core_libc_sha256",
            "kcc_fp36_archive_sha256", "gcc_libgcc_sha256")
FIELDS = METADATA + tuple(p for kind in KINDS
                          for p in (kind + "_member", kind + "_sha256"))
EXTRAS = {
    "runtime/kcc-fp36-source-v1.s": KFP_SOURCE,
    "runtime/gcc-fp36-source-v1.s": KFP_SOURCE,
    "runtime/kcc-fp36-archive-v1.a": KFP,
    "runtime/gcc-fp36-archive-v1.a": KFP,
    "runtime/gcc-libgcc-corrected-v1.a": GFP,
    "runtime/gcc-libgcc-original-v1.a": ORIGINAL_LIBGCC,
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def get_word(report, symbol):
    match = re.search(r"__P10RUN_EXPECT__ " + re.escape(symbol) +
                      r" [0-7]+ 000000000000\s*\n[0-7]+:\s*([0-7]{12})",
                      report)
    if not match:
        raise ValueError("native guest symbol missing: " + symbol)
    return int(match.group(1), 8)


def status_for(role, compiler):
    if role == "signed-pre":
        return "run_fail"
    if role in ("original-current", "original-line-current"):
        return "run_fail" if compiler == "kcc" else "link_fail"
    return "pass"


def fail_for(role, profile):
    if role == "signed-pre":
        return {"kcc-pdp6-noopt": 3, "kcc-pdp6-opt": 15}.get(profile, 1)
    if role == "original-line-current":
        return {"kcc-pdp6-noopt": 266, "kcc-pdp6-opt": 58}.get(profile)
    return 0 if role not in ("original-current", "original-line-current") else None


def validate_sources():
    for name, digest in SOURCE_SHAS.items():
        if sha((ROOT / name).read_bytes()) != digest:
            raise ValueError("historical or 36-bit conversion oracle changed: " + name)
    original = (ROOT / ORIGINAL).read_text(encoding="ascii")
    for line in ("if (u2f(0U) != (float) 0U)",
                 "if (f2u(1.99) != 1)",
                 "if (d2u((double) (~0U)) != ~0U)",
                 "unsigned long long int", "test_longlong_integer_to_float();"):
        if line not in original:
            raise ValueError("historical 71-bit original conversion assertion weakened")
    line_test = (ROOT / CASES[-1][1]).read_text(encoding="ascii")
    if ('#include "../upstream/pdp10/pdp10/conversion.c"' not in line_test or
            '#define abort() (fail_id = __LINE__, conversion_abort_v1())' not in line_test):
        raise ValueError("original-line diagnostic no longer includes exact original")
    for source in (CASES[2][1], CASES[3][1], CASES[4][1], CASES[5][1]):
        with (ROOT / "COMPILER_MATRIX.tsv").open(encoding="ascii") as f:
            lines = [line.rstrip("\n").split("\t") for line in f
                     if line.startswith(source + "\t")]
        if len(lines) != 1 or lines[0][1] != "semantic-regression":
            raise ValueError("PDP-6 conversion locator not registered")


def expected_rows():
    out = []
    for role, src, _folder, _class in CASES:
        for profile in PROFILES:
            compiler = profile.split("-", 1)[0]
            status = status_for(role, compiler)
            row = {"role": role, "source": src,
                   "source_sha256": SOURCE_SHAS[src], "profile": profile,
                   "cpu": "pdp6", "status": status,
                   "fail_id": str(fail_for(role, profile)) if status != "link_fail"
                              and fail_for(role, profile) is not None else "-",
                   "compiler_sha256": TOOL[compiler] if role != "signed-pre" else "-",
                   "core_libc_sha256": CORE,
                   "kcc_fp36_archive_sha256": KFP if role != "signed-pre" else "-",
                   "gcc_libgcc_sha256": GFP if role != "signed-pre" else "-"}
            for kind in KINDS:
                name = role + "/pdp6/" + profile + EXT[kind]
                row[kind + "_member"] = (name if status != "link_fail"
                                        or kind in ("log", "status", "asm") else "-")
            out.append(row)
    return out


def verify_rows(rows):
    reference = expected_rows()
    if len(rows) != 48 or tuple(rows[0]) != FIELDS:
        raise ValueError("48 exact native original and compiler oracle cells required")
    for row, exp in zip(rows, reference):
        if any(row[name] != value for name, value in exp.items()):
            raise ValueError("wrong conversion profile/source/status/ABI binding")
        for kind in KINDS:
            digest = row[kind + "_sha256"]
            if row[kind + "_member"] == "-":
                if digest != "-":
                    raise ValueError("conversion link failure invented report")
            elif not re.fullmatch(r"[0-9a-f]{64}", digest):
                raise ValueError("conversion evidence digest invalid")


def verify_archive(rows, raw):
    names = set(EXTRAS)
    for row in rows:
        for kind in KINDS:
            if row[kind + "_member"] != "-":
                names.add(row[kind + "_member"])
    try:
        with tarfile.open(fileobj=io.BytesIO(raw), mode="r:gz") as tar:
            members = tar.getmembers()
            if (len(members) != len(names) or
                    {member.name for member in members} != names or
                    any(not member.isfile() for member in members)):
                raise ValueError("conversion archive membership incomplete")

            def content(name):
                stream = tar.extractfile(name)
                if stream is None:
                    raise ValueError("conversion raw archive item absent")
                return stream.read()

            for name, digest in EXTRAS.items():
                if sha(content(name)) != digest:
                    raise ValueError("real compiler conversion runtime changed")
            for row in rows:
                blobs = {}
                for kind in KINDS:
                    name = row[kind + "_member"]
                    if name == "-":
                        continue
                    data = content(name)
                    if sha(data) != row[kind + "_sha256"]:
                        raise ValueError("native conversion guest raw output modified")
                    blobs[kind] = data.decode("utf-8", "replace")
                if ("status=" + row["status"] + "\n" not in blobs["status"] or
                        "profile=" + row["profile"] + "\n" not in blobs["status"] or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in blobs["status"] or
                        "runtime_library_sha256=" + CORE + "\n" not in blobs["status"] or
                        "main:" not in blobs["asm"]):
                    raise ValueError("compiler-only libc/source result invalid")
                if row["status"] == "link_fail":
                    if "dlink: undefined symbol: __fixunssfdi" not in blobs["log"]:
                        raise ValueError("genuine GNU 71-bit libgcc deficiency hidden")
                    continue
                report = blobs["report"]
                if ("machine=pdp6\n" not in report or "rc=0\n" not in report or
                        "HALT instruction" not in report or
                        "result=" + ("PASS" if row["status"] == "pass" else "FAIL") +
                        "\n" not in report or
                        get_word(report, "__test_exit") != int(row["status"] != "pass")):
                    raise ValueError("real native PDP-6 guest acceptance absent")
                if row["fail_id"] != "-" and get_word(report, "fail_id") != int(row["fail_id"]):
                    raise ValueError("native conversion assertion family changed")
                if ("main" not in blobs["map"] or "exit" not in blobs["map"] or
                        "abort" not in blobs["map"]):
                    raise ValueError("native conversion symbol map incomplete")
                if (row["status"] == "pass" and row["profile"].startswith("kcc-") and
                        "kcc-libc-fp36-pdp6-v1.s" not in blobs["log"]):
                    raise ValueError("native KCC omitted actual 36-bit conversion library")
    except (EOFError, OSError, tarfile.TarError) as exc:
        raise ValueError("versioned conversion archive unreadable") from exc


def audit():
    validate_sources()
    with MANIFEST.open(encoding="ascii", newline="") as f:
        rows = list(csv.DictReader(f, delimiter="\t"))
    verify_rows(rows)
    verify_archive(rows, ARCHIVE.read_bytes())
    return rows


def write():
    validate_sources()
    rows = expected_rows()
    saved = {}
    for row in rows:
        role = row["role"]
        folder = next(item[2] for item in CASES if item[0] == role)
        candidates = list((TMP / folder / "cells").glob(
            "*__" + row["profile"] + "__pdp6__*"))
        if len(candidates) != 1:
            raise ValueError("missing real versioned conversion guest: " + role)
        cell = candidates[0]
        paths = {"log": cell / "cell.log", "status": cell / "status",
                 "asm": list((cell / "asm").glob("*.s")),
                 "map": list((cell / "run").glob("*.map")),
                 "report": list((cell / "run").glob("*.report.txt"))}
        for kind in ("asm", "map", "report"):
            expected = 0 if row[kind + "_member"] == "-" else 1
            if len(paths[kind]) != expected:
                raise ValueError("missing raw conversion guest output: " + kind)
            paths[kind] = paths[kind][0] if expected else None
        for kind in KINDS:
            name = row[kind + "_member"]
            if name == "-":
                row[kind + "_sha256"] = "-"
            else:
                data = paths[kind].read_bytes()
                if name in saved:
                    raise ValueError("duplicate archive member")
                saved[name] = data
                row[kind + "_sha256"] = sha(data)
    prefix = Path(os.environ["PDP10_PREFIX"])
    installed = {
        "runtime/kcc-fp36-source-v1.s": prefix / "lib/kcc/freestanding/kcc-libc-fp36-pdp6-v1.s",
        "runtime/gcc-fp36-source-v1.s": prefix / "lib/gcc-lib/pdp10-dec-none/3.2/freestanding/kcc-libc-fp36-pdp6-v1.s",
        "runtime/kcc-fp36-archive-v1.a": prefix / "lib/kcc/freestanding/libp10fp36-pdp6-v1.a",
        "runtime/gcc-fp36-archive-v1.a": prefix / "lib/gcc-lib/pdp10-dec-none/3.2/freestanding/libp10fp36-pdp6-v1.a",
        "runtime/gcc-libgcc-corrected-v1.a": prefix / "lib/gcc-lib/pdp10-dec-none/3.2/libgcc.a",
        "runtime/gcc-libgcc-original-v1.a": TMP / "p10tk-libgcc-before-signed-sf-20261120-v1.a",
    }
    for name, path in installed.items():
        data = path.read_bytes()
        if sha(data) != EXTRAS[name]:
            raise ValueError("compiler runtime not the tested installed snapshot")
        saved[name] = data
    with MANIFEST.open("w", encoding="ascii", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS, delimiter="\t", lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    buffer = io.BytesIO()
    with gzip.GzipFile(fileobj=buffer, mode="wb", filename="", mtime=0) as gz:
        with tarfile.open(fileobj=gz, mode="w") as tar:
            for name in sorted(saved):
                data = saved[name]
                info = tarfile.TarInfo(name)
                info.size = len(data)
                info.mode = 0o644
                info.mtime = 0
                tar.addfile(info, io.BytesIO(data))
    ARCHIVE.write_bytes(buffer.getvalue())
    audit()
    print("WROTE: 48 real native conversion cases, %d raw artifacts, SHA256 %s" %
          (len(saved), sha(ARCHIVE.read_bytes())))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.write:
        write()
    else:
        audit()
        print("PASS: 30 native PDP-6 36-bit conversion PASS, 6 historical "
              "signed conversion failures and 12 original-source "
              "failures; full P1 conversion remains blocked")


if __name__ == "__main__":
    main()
