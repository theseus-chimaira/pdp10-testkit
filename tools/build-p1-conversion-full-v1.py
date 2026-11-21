#!/usr/bin/env python3
"""Authenticate native PDP-6 unchanged conversion.c PASS and 71-bit ABI.

--write gathers exact previously executed raw guest outputs and the real
installed GCC libgcc and cc1 artifacts into a deterministic archive.
Normal verification never recompiles, reruns, or rewrites evidence.
Both the historical 36-bit and KCC-only checkpoints stay immutable.
"""

import argparse
import csv
import gzip
import hashlib
import importlib.util
import io
import os
from pathlib import Path
import re
import tarfile

ROOT = Path(__file__).resolve().parents[1]
TMP = Path(os.environ.get("TMPDIR") or Path.home() / "tmp")
MANIFEST = ROOT / "manifests/PDP10-P1-CONVERSION-FULL-EVIDENCE-20261121-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-conversion-full-20261121-v1.tar.gz"
PROFILES = ("kcc-pdp6-noopt", "kcc-pdp6-opt", "gcc-pdp6-o0",
            "gcc-pdp6-o1", "gcc-pdp6-o2", "gcc-pdp6-os")
ORIGINAL = "tests/semantic/upstream/pdp10/pdp10/conversion.c"
CASES = (
    ("original-full", ORIGINAL,
     "p10tk-p1-conversion-fully-corrected-20261121-v1", PROFILES),
    ("original-line", "tests/semantic/regression/pdp10-conversion-original-line-v1.c",
     "p10tk-p1-conversion-fully-corrected-line-20261121-v1", PROFILES),
    ("gcc-raw-71bit", "tests/semantic/regression/pdp10-libgcc-di-float-abi-v1.c",
     "p10tk-p1-gcc-di-float-abi-sticky-20261121-v1", PROFILES[2:]),
    ("gcc-71bit-int-to-fp", "tests/semantic/regression/pdp10-conversion-gnu71-stages-v1.c",
     "p10tk-p1-gcc-gnu71-floatstage-20261121-v1", PROFILES[2:]),
    ("gcc-71bit-fp-to-int", "tests/semantic/regression/pdp10-conversion-gnu71-fixstage-v1.c",
     "p10tk-p1-gcc-gnu71-fixstage-directdf-20261121-v1", PROFILES[2:]),
)
SOURCES = {
    ORIGINAL: "2736912e40e1dabd84f7f193ddaaf5ddf9bf00e76edb0cca0611b3f49e5c1beb",
    "tests/semantic/regression/pdp10-conversion-original-line-v1.c":
        "87234db87df7c5ca644cd951250571a6d3aeaf0d1d2eed899299247e73a6d950",
    "tests/semantic/regression/pdp10-libgcc-di-float-abi-v1.c":
        "778169bf86c0bd2c94b776bc5c0cf729c3a1e935f289571b215b64b2a29a6a06",
    "tests/semantic/regression/pdp10-conversion-gnu71-stages-v1.c":
        "7b6f6484e7a3e108f95ab637971fe8bf46e9c92ed13c9d2034f53abd79c3e4a7",
    "tests/semantic/regression/pdp10-conversion-gnu71-fixstage-v1.c":
        "6bcc4c3da8da7d973fe56c9c8adfd1ca6c62f9d0ff07e3fab2b8a58ceea5a9d4",
}
CORE = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
LIBGCC = "f9b1720d59df7b0e8868e27a0aa036a222472a820d7080a3e008f61b0b4bed6c"
OLD_LIBGCC = "afd520fbbff5db32466d887e49136f09ee2c4517b63eded83325cd721505f960"
GCC_CC1 = "67ebf49eb2d7eb896b7f95e0aab9bab3f94c148ce914297f4ff1cf1c61cedfc7"
KCC_CC = "49d749e3670e0b3e9abf13e4cb6eb0bc6b9c3dbc39fe43379ed504f9e34fb952"
OBJECTS = {
    "fixunssfdi": ("p10-gcc-fixunssfdi-20261121-v1.dobj",
                    "a543f71193f2569ba2eb04d8ab19de001e6c1529b64bb1cf12b02d0bb7c24a25"),
    "fixsfdi": ("p10-gcc-fixsfdi-canonical-zero-20261121-v1.dobj",
                 "7e2a68b9658e9e5ab8d3b40f597d223d8848e0947bee40920d130e3de071efda"),
    "fixunsdfdi": ("p10-gcc-fixunsdfdi-20261121-v1.dobj",
                    "9f40b4035bc0eb88dc0df6c35fc43ab961627b13a74e950cbfc24cfc370f4b40"),
    "fixdfdi": ("p10-gcc-fixdfdi-20261121-v1.dobj",
                 "6a7583e1704a3313a7f0132fff136c2174fb7d015beacd5dcc2a0e3ea26a553f"),
    "floatdidf": ("p10-gcc-floatdidf-20261121-v1.dobj",
                   "5f2dbafbeca9994ceba7db1b6023f9cf4de790984f01ac2c41f75d651f2c19a2"),
    "floatdisf": ("p10-gcc-floatdisf-20261121-v1.dobj",
                   "de991543c9fd9d563549393b028918d29dbfd5e2c7ceecd48413113a224664de"),
}
EXTRAS = {
    "gcc/installed-cc1-v1": GCC_CC1,
    "gcc/installed-libgcc-71bit-v1.a": LIBGCC,
    "gcc/original-libgcc-36bit-v1.a": OLD_LIBGCC,
    **{"gcc/object-" + name + "-v1.dobj": fingerprint
       for name, (_path, fingerprint) in OBJECTS.items()},
}
KINDS = ("log", "status", "asm", "map", "report")
SUFFIX = {"log": ".log.txt", "status": ".status", "asm": ".s",
          "map": ".map", "report": ".report.txt"}
FIELDS = ("role", "source", "source_sha256", "profile", "cpu", "status",
          "compiler_sha256", "core_libc_sha256", "libgcc_archive_sha256") + (
          tuple(field for kind in KINDS
                for field in (kind + "_member", kind + "_sha256")))


def sha(data):
    return hashlib.sha256(data).hexdigest()


def earlier_evidence():
    spec = importlib.util.spec_from_file_location(
        "p10tk_kcc_original_conversions_frozen",
        ROOT / "tools/build-p1-conversion-kcc-original-v1.py")
    earlier = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(earlier)
    rows = earlier.audit()
    gcc_original_link_failures = [row for row in rows
                                  if row["role"] == "original" and
                                  row["profile"].startswith("gcc-") and
                                  row["status"] == "link_fail"]
    if len(gcc_original_link_failures) != 4:
        raise ValueError("historical GCC 71-bit library failures lost")


def source_audit():
    for name, digest in SOURCES.items():
        if sha((ROOT / name).read_bytes()) != digest:
            raise ValueError("unchanged original or source-pinned oracle modified: " + name)
    original = (ROOT / ORIGINAL).read_text(encoding="ascii")
    for expected in ("test_longlong_integer_to_float();",
                     "tst_longlong_integer();", "if (f2ull(0.0) != 0LL)",
                     "if (ull2f(~0ULL) != (float) ~0ULL)"):
        if expected not in original:
            raise ValueError("71-bit original test assertion missing")
    raw_abi = (ROOT / CASES[2][1]).read_text(encoding="ascii")
    for expected in ("extern float __floatdisf(unsigned int, unsigned int);",
                     "extern double __floatdidf(unsigned int, unsigned int);",
                     "590295810358705651712.0F",
                     "590295819154798673920.0F"):
        if expected not in raw_abi:
            raise ValueError("71-bit C89 direct helper/rounding oracle changed")
    for role, source, _folder, _profiles in CASES[2:]:
        matrix = (ROOT / "COMPILER_MATRIX.tsv").read_text(encoding="ascii")
        if matrix.count("\n" + source + "\tsemantic-regression\t") != 1:
            raise ValueError("GCC-only source not in normal compiler matrix: " + role)


def expected_rows():
    rows = []
    for role, source, _dir, profiles in CASES:
        for profile in profiles:
            compiler = profile.split("-", 1)[0]
            row = {"role": role, "source": source,
                   "source_sha256": SOURCES[source], "profile": profile,
                   "cpu": "pdp6", "status": "pass",
                   "compiler_sha256": KCC_CC if compiler == "kcc" else GCC_CC1,
                   "core_libc_sha256": CORE,
                   "libgcc_archive_sha256": LIBGCC}
            for kind in KINDS:
                row[kind + "_member"] = role + "/pdp6/" + profile + SUFFIX[kind]
            rows.append(row)
    return rows


def verify_rows(rows):
    expected = expected_rows()
    if len(rows) != 24 or tuple(rows[0]) != FIELDS:
        raise ValueError("24 full native PDP-6 original and ABI outcomes required")
    for actual, other in zip(rows, expected):
        if any(actual[key] != value for key, value in other.items()):
            raise ValueError("incorrect native source/CPU/status or compiler ABI identity")
        for kind in KINDS:
            if not re.fullmatch(r"[0-9a-f]{64}", actual[kind + "_sha256"]):
                raise ValueError("raw native simulator output fingerprint invalid")


def expect_zero(report, symbol):
    match = re.search(r"__P10RUN_EXPECT__ " + re.escape(symbol) +
                      r" [0-7]+ 000000000000\s*\n[0-7]+:\s*([0-7]{12})",
                      report)
    if not match or int(match.group(1), 8) != 0:
        raise ValueError("native guest assertion not zero: " + symbol)


def verify_archive(rows, raw):
    names = set(EXTRAS)
    for row in rows:
        for kind in KINDS:
            names.add(row[kind + "_member"])
    if len(names) != 129:
        raise ValueError("71-bit guest archive needs exactly 129 raw artifacts")
    try:
        with tarfile.open(fileobj=io.BytesIO(raw), mode="r:gz") as tf:
            members = tf.getmembers()
            if (len(members) != 129 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("raw PDP-6 guest/target archive membership mismatch")

            def content(name):
                handle = tf.extractfile(name)
                if handle is None:
                    raise ValueError("missing exact target or guest artifact")
                return handle.read()

            for name, digest in EXTRAS.items():
                if sha(content(name)) != digest:
                    raise ValueError("real GCC compiler/libgcc DOBJ identity changed")
            for row in rows:
                blobs = {}
                for kind in KINDS:
                    data = content(row[kind + "_member"])
                    if sha(data) != row[kind + "_sha256"]:
                        raise ValueError("native source/profile artifact modified")
                    blobs[kind] = data.decode("utf-8", "replace")
                if ("status=pass\n" not in blobs["status"] or
                        "profile=" + row["profile"] + "\n" not in blobs["status"] or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in
                        blobs["status"] or
                        "runtime_library_sha256=" + CORE + "\n" not in
                        blobs["status"] or "main:" not in blobs["asm"]):
                    raise ValueError("native guest compiler/runtime policy changed")
                report = blobs["report"]
                if ("machine=pdp6\n" not in report or "rc=0\n" not in report or
                        "result=PASS\n" not in report or
                        "HALT instruction" not in report):
                    raise ValueError("no successful native PDP-6 SIMH execution")
                expect_zero(report, "__test_exit")
                if row["role"] != "original-full":
                    expect_zero(report, "fail_id")
                if ("main" not in blobs["map"] or "exit" not in blobs["map"] or
                        "abort" not in blobs["map"]):
                    raise ValueError("native simulator link map incomplete")
                if (row["profile"].startswith("gcc-") and
                        row["role"] in ("original-full", "original-line")):
                    for symbol in ("__fixunssfdi", "__fixsfdi", "__fixunsdfdi",
                                   "__fixdfdi", "__floatdisf", "__floatdidf"):
                        if symbol not in blobs["map"]:
                            raise ValueError("real 71-bit GCC DOBJ helper not linked: " + symbol)
    except (EOFError, OSError, tarfile.TarError) as exc:
        raise ValueError("versioned signed/unsigned 71-bit native evidence unreadable") from exc


def installed_audit():
    prefix = Path(os.environ["PDP10_PREFIX"])
    paths = (
        (prefix / "lib/gcc-lib/pdp10-dec-none/3.2/cc1", GCC_CC1),
        (prefix / "lib/gcc-lib/pdp10-dec-none/3.2/libgcc.a", LIBGCC),
        (prefix / "bin/kcc", KCC_CC),
    )
    for path, digest in paths:
        if not path.is_file() or sha(path.read_bytes()) != digest:
            raise ValueError("installed compiler provenance changed: " + str(path))


def audit():
    source_audit()
    earlier_evidence()
    with MANIFEST.open(encoding="ascii", newline="") as f:
        rows = list(csv.DictReader(f, delimiter="\t"))
    verify_rows(rows)
    verify_archive(rows, ARCHIVE.read_bytes())
    # This is immutable historical evidence.  Verify the archived
    # exact compiler binaries and libgcc members, not a future
    # installation that may contain further valid compiler repairs.
    return rows


def write():
    source_audit()
    earlier_evidence()
    installed_audit()
    rows = expected_rows()
    saved = {}
    for row in rows:
        folder = next(path for role, source, path, _ in CASES
                      if role == row["role"] and source == row["source"])
        cells = list((TMP / folder / "cells").glob(
            "*__" + row["profile"] + "__pdp6__*"))
        if len(cells) != 1:
            raise ValueError("missing exact raw guest directory: " + row["profile"])
        cell = cells[0]
        paths = {"log": cell / "cell.log", "status": cell / "status",
                 "asm": list((cell / "asm").glob("*.s")),
                 "map": list((cell / "run").glob("*.map")),
                 "report": list((cell / "run").glob("*.report.txt"))}
        for kind in ("asm", "map", "report"):
            if len(paths[kind]) != 1:
                raise ValueError("missing actual compiler guest " + kind)
            paths[kind] = paths[kind][0]
        for kind in KINDS:
            key = row[kind + "_member"]
            data = paths[kind].read_bytes()
            if key in saved:
                raise ValueError("duplicate native guest archive member")
            saved[key] = data
            row[kind + "_sha256"] = sha(data)
    prefix = Path(os.environ["PDP10_PREFIX"])
    extra_paths = {
        "gcc/installed-cc1-v1": prefix / "lib/gcc-lib/pdp10-dec-none/3.2/cc1",
        "gcc/installed-libgcc-71bit-v1.a": prefix / "lib/gcc-lib/pdp10-dec-none/3.2/libgcc.a",
        "gcc/original-libgcc-36bit-v1.a": TMP / "p10-gcc-libgcc-before-71bit-20261121-v1.a",
    }
    for name, (source, _digest) in OBJECTS.items():
        extra_paths["gcc/object-" + name + "-v1.dobj"] = TMP / source
    for name, path in extra_paths.items():
        data = path.read_bytes()
        if sha(data) != EXTRAS[name]:
            raise ValueError("unexpected real GCC compiler/libgcc object bytes")
        saved[name] = data
    with MANIFEST.open("w", encoding="ascii", newline="") as f:
        writer = csv.DictWriter(f, FIELDS, delimiter="\t", lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    buffer = io.BytesIO()
    with gzip.GzipFile(fileobj=buffer, mode="wb", filename="", mtime=0) as gz:
        with tarfile.open(fileobj=gz, mode="w") as tf:
            for name in sorted(saved):
                data = saved[name]
                info = tarfile.TarInfo(name)
                info.size = len(data)
                info.mode = 0o644
                info.mtime = 0
                tf.addfile(info, io.BytesIO(data))
    ARCHIVE.write_bytes(buffer.getvalue())
    audit()
    print("WROTE: 24 native PDP-6 original/71-bit ABI PASS, "
          "129 source-pinned raw artifacts, SHA256 " + sha(ARCHIVE.read_bytes()))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.write:
        write()
    else:
        audit()
        print("PASS: unchanged original 6 native PDP-6 PASS, independent "
              "original-line 6 PASS, C89 71-bit ABI 4 PASS, "
              "GNU71 original sections 8 PASS; 129 raw artifacts")


if __name__ == "__main__":
    main()
