#!/usr/bin/env python3
"""Pin native PDP-6 KCC conversion.c original PASS and GCC 71-bit blocker.

With --write, collect already executed versioned native testkit cells.
Without --write, authenticate the committed archive without rerunning a
compiler or requiring the temporary directories to remain accessible.
Historical pre-repair failures are checked against the previous frozen
conversion evidence, not misrepresented as current failures.
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
MANIFEST = ROOT / "manifests/PDP10-P1-CONVERSION-KCC-ORIGINAL-EVIDENCE-20261121-v1.tsv"
ARCHIVE = ROOT / "refs/p10tk-p1-conversion-kcc-original-20261121-v1.tar.gz"
PROFILES = ("kcc-pdp6-noopt", "kcc-pdp6-opt", "gcc-pdp6-o0",
            "gcc-pdp6-o1", "gcc-pdp6-o2", "gcc-pdp6-os")
P1 = "tests/semantic/upstream/pdp10/pdp10/conversion.c"
LINE = "tests/semantic/regression/pdp10-conversion-original-line-v1.c"
ORACLES = (
    "pdp10-fp-signed-conversion-v1",
    "pdp10-fp-conversion-locator-v1",
    "pdp10-fp-unsigned36-locator-v1",
    "pdp10-fp-unsigned36-sf-v1",
    "pdp10-fp-signed36-boundary-v1",
    "pdp10-fp-constant-unsigned-fold-v1",
    "pdp10-fp-signeddf-boundary-v1",
    "pdp10-fp-signedidf-exact-v1",
)
SHAS = {
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
    "tests/semantic/regression/pdp10-fp-constant-unsigned-fold-v1.c":
        "5e807980f5e5c419b47bef56eac8f6723ada05c07b45abe6b7e45d407264eed2",
    "tests/semantic/regression/pdp10-fp-signeddf-boundary-v1.c":
        "a50fa0933b30ce36ea0023f6b333c9a9c91c07ad4e16eb41a2a62012e7beb4f7",
    "tests/semantic/regression/pdp10-fp-signedidf-exact-v1.c":
        "f902cab4b03d300a132c8a277755ab3aacba657e1d98ed67a31b13361537c4bd",
    P1: "2736912e40e1dabd84f7f193ddaaf5ddf9bf00e76edb0cca0611b3f49e5c1beb",
    LINE: "87234db87df7c5ca644cd951250571a6d3aeaf0d1d2eed899299247e73a6d950",
}
KCC = "49d749e3670e0b3e9abf13e4cb6eb0bc6b9c3dbc39fe43379ed504f9e34fb952"
GCC = "67ebf49eb2d7eb896b7f95e0aab9bab3f94c148ce914297f4ff1cf1c61cedfc7"
CORE = "ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41"
DF_SOURCE = "1ad2e2550bef270389322654cba02cf548972ca7aec4c060e4e590ae04117459"
DF_ARCHIVE = "fad2b3371567a2dde082bfbe2227220cd183ec9322eef6eaba763efd5f252b73"
KINDS = ("log", "status", "asm", "map", "report")
SUFFIX = {"log": ".log.txt", "status": ".status", "asm": ".s",
          "map": ".map", "report": ".report.txt"}
FIELDS = ("role", "source", "source_sha256", "profile", "cpu", "status",
          "compiler_sha256", "core_libc_sha256", "signed_df_archive_sha256") + (
          tuple(c for kind in KINDS
                for c in (kind + "_member", kind + "_sha256")))
EXTRAS = {
    "compiler/kcc-v1": KCC,
    "compiler/kcc-signed-df-v1.s": DF_SOURCE,
    "compiler/gcc-signed-df-v1.s": DF_SOURCE,
    "compiler/kcc-signed-df-v1.a": DF_ARCHIVE,
    "compiler/gcc-signed-df-v1.a": DF_ARCHIVE,
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def roles():
    for name in ORACLES:
        yield (name, "tests/semantic/regression/" + name + ".c",
               "p10tk-p1-signeddf-accept-" + name + "-20261121-v1")
    yield ("original", P1,
           "p10tk-p1-conversion-after-signedidf-original-20261121-v1")
    yield ("original-line", LINE,
           "p10tk-p1-conversion-after-signedidf-line-20261121-v1")


def expected_rows():
    rows = []
    for role, source, _ in roles():
        for profile in PROFILES:
            compiler = profile.split("-", 1)[0]
            status = ("link_fail" if role in ("original", "original-line")
                      and compiler == "gcc" else "pass")
            row = {"role": role, "source": source,
                   "source_sha256": SHAS[source], "profile": profile,
                   "cpu": "pdp6", "status": status,
                   "compiler_sha256": KCC if compiler == "kcc" else GCC,
                   "core_libc_sha256": CORE,
                   "signed_df_archive_sha256": DF_ARCHIVE}
            for kind in KINDS:
                present = status == "pass" or kind in ("log", "status", "asm")
                row[kind + "_member"] = (role + "/pdp6/" + profile +
                                         SUFFIX[kind] if present else "-")
            rows.append(row)
    return rows


def old_evidence():
    """Verify real earlier KCC failures remain independently frozen."""
    name = ROOT / "tools/build-p1-conversion-36bit-evidence-v1.py"
    spec = importlib.util.spec_from_file_location("p10tk_prev_p1_fp36", name)
    previous = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(previous)
    previous.audit()


def verify_sources():
    for source, digest in SHAS.items():
        if sha((ROOT / source).read_bytes()) != digest:
            raise ValueError("source changed: " + source)
    original = (ROOT / P1).read_text(encoding="ascii")
    for assertion in ("if (!fnear (u2f(~0U), (float) ~0U))",
                      "if (s2d(0) != (double) 0)",
                      "if (d2s((double)(int)~((~0U) >> 1))",
                      "if (f2ull(0.0) != 0LL)"):
        if assertion not in original:
            raise ValueError("original 36-bit / 71-bit assertion missing")
    line = (ROOT / LINE).read_text(encoding="ascii")
    if ('#include "../upstream/pdp10/pdp10/conversion.c"' not in line or
            "#define abort() (fail_id = __LINE__, conversion_abort_v1())"
            not in line):
        raise ValueError("diagnostic no longer includes unchanged original")
    matrix = (ROOT / "COMPILER_MATRIX.tsv").read_text(encoding="ascii")
    for name in ORACLES:
        path = "tests/semantic/regression/" + name + ".c"
        if matrix.count("\n" + path + "\tsemantic-regression\t") != 1:
            raise ValueError("normal compiler matrix does not own " + path)


def verify_rows(rows):
    expected = expected_rows()
    if len(rows) != 60 or tuple(rows[0]) != FIELDS:
        raise ValueError("expected exactly 60 native signed-DF evidence cells")
    for row, other in zip(rows, expected):
        if any(row[field] != value for field, value in other.items()):
            raise ValueError("wrong compiler/CPU/source/status evidence cell")
        for kind in KINDS:
            digest = row[kind + "_sha256"]
            if row[kind + "_member"] == "-":
                if digest != "-":
                    raise ValueError("link-failure guest report fabricated")
            elif not re.fullmatch(r"[0-9a-f]{64}", digest):
                raise ValueError("invalid raw guest evidence hash")


def expect_zero(report, symbol):
    match = re.search(r"__P10RUN_EXPECT__ " + re.escape(symbol) +
                      r" [0-7]+ 000000000000\s*\n[0-7]+:\s*([0-7]{12})",
                      report)
    if match is None or int(match.group(1), 8) != 0:
        raise ValueError("nonzero real PDP-6 guest assertion: " + symbol)


def verify_archive(rows, raw):
    names = set(EXTRAS)
    for row in rows:
        for kind in KINDS:
            if row[kind + "_member"] != "-":
                names.add(row[kind + "_member"])
    if len(names) != 289:
        raise ValueError("incomplete signed DF native raw evidence inventory")
    try:
        with tarfile.open(fileobj=io.BytesIO(raw), mode="r:gz") as tf:
            members = tf.getmembers()
            if (len(members) != 289 or {m.name for m in members} != names or
                    any(not m.isfile() for m in members)):
                raise ValueError("wrong signed DF raw archive membership")

            def read(name):
                stream = tf.extractfile(name)
                if stream is None:
                    raise ValueError("missing raw signed DF evidence")
                return stream.read()

            for name, digest in EXTRAS.items():
                if sha(read(name)) != digest:
                    raise ValueError("installed compiler/runtime fingerprint changed")
            source = read("compiler/kcc-signed-df-v1.s").decode("ascii")
            for symbol in ("__kcc_floatsidf", "__kcc_fixdfsi",
                           "__kcc_floatunsidf", "__kcc_fixunsdfsi"):
                if symbol not in source:
                    raise ValueError("real signed DF source helper missing")
            for row in rows:
                text = {}
                for kind in KINDS:
                    member = row[kind + "_member"]
                    if member != "-":
                        data = read(member)
                        if sha(data) != row[kind + "_sha256"]:
                            raise ValueError("raw signed DF guest result was modified")
                        text[kind] = data.decode("utf-8", "replace")
                if ("status=" + row["status"] + "\n" not in text["status"] or
                        "profile=" + row["profile"] + "\n" not in text["status"] or
                        "runtime_library_policy=compiler-stdlib-v1\n" not in
                        text["status"] or
                        "runtime_library_sha256=" + CORE + "\n" not in
                        text["status"] or "main:" not in text["asm"]):
                    raise ValueError("guest compiler C runtime or status changed")
                if row["status"] == "link_fail":
                    if "dlink: undefined symbol: __fixunssfdi" not in text["log"]:
                        raise ValueError("missing real GNU 71-bit link block hidden")
                    continue
                report = text["report"]
                if ("machine=pdp6\n" not in report or "rc=0\n" not in report or
                        "result=PASS\n" not in report or
                        "HALT instruction" not in report):
                    raise ValueError("native PDP-6 execution unverified")
                expect_zero(report, "__test_exit")
                if row["role"] != "original":
                    expect_zero(report, "fail_id")
                if ("main" not in text["map"] or "exit" not in text["map"] or
                        "abort" not in text["map"]):
                    raise ValueError("native guest linker map incomplete")
                if row["profile"].startswith("kcc-") and row["role"] in (
                        "original", "original-line", "pdp10-fp-signedidf-exact-v1",
                        "pdp10-fp-signeddf-boundary-v1"):
                    if "kcc-libc-fp36-signed-df-pdp6-v1.s" not in text["log"]:
                        raise ValueError("signed D-format helper not selected")
    except (OSError, EOFError, tarfile.TarError) as exc:
        raise ValueError("signed DF raw archive cannot be read") from exc


def audit():
    verify_sources()
    old_evidence()
    with MANIFEST.open(encoding="ascii", newline="") as f:
        rows = list(csv.DictReader(f, delimiter="\t"))
    verify_rows(rows)
    verify_archive(rows, ARCHIVE.read_bytes())
    return rows


def write():
    verify_sources()
    rows = expected_rows()
    saved = {}
    for row in rows:
        folder = next(folder for role, source, folder in roles()
                      if role == row["role"] and source == row["source"])
        cells = list((TMP / folder / "cells").glob(
            "*__" + row["profile"] + "__pdp6__*"))
        if len(cells) != 1:
            raise ValueError("missing versioned native guest: " + row["role"])
        cell = cells[0]
        paths = {"log": cell / "cell.log", "status": cell / "status",
                 "asm": list((cell / "asm").glob("*.s")),
                 "map": list((cell / "run").glob("*.map")),
                 "report": list((cell / "run").glob("*.report.txt"))}
        for kind in ("asm", "map", "report"):
            count = 1 if row[kind + "_member"] != "-" else 0
            if len(paths[kind]) != count:
                raise ValueError("incomplete native guest " + kind)
            paths[kind] = paths[kind][0] if count else None
        for kind in KINDS:
            member = row[kind + "_member"]
            if member == "-":
                row[kind + "_sha256"] = "-"
                continue
            data = paths[kind].read_bytes()
            if member in saved:
                raise ValueError("duplicate archived guest output")
            saved[member] = data
            row[kind + "_sha256"] = sha(data)

    prefix = Path(os.environ["PDP10_PREFIX"])
    extras = {
        "compiler/kcc-v1": prefix / "bin/kcc",
        "compiler/kcc-signed-df-v1.s": prefix /
            "lib/kcc/freestanding/kcc-libc-fp36-signed-df-pdp6-v1.s",
        "compiler/gcc-signed-df-v1.s": prefix /
            "lib/gcc-lib/pdp10-dec-none/3.2/freestanding/kcc-libc-fp36-signed-df-pdp6-v1.s",
        "compiler/kcc-signed-df-v1.a": prefix /
            "lib/kcc/freestanding/libp10fp36-signed-df-pdp6-v1.a",
        "compiler/gcc-signed-df-v1.a": prefix /
            "lib/gcc-lib/pdp10-dec-none/3.2/freestanding/libp10fp36-signed-df-pdp6-v1.a",
    }
    for name, path in extras.items():
        data = path.read_bytes()
        if sha(data) != EXTRAS[name]:
            raise ValueError("installed signed D-format artifact unexpected")
        saved[name] = data
    with MANIFEST.open("w", encoding="ascii", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS, delimiter="\t",
                                lineterminator="\n")
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
    print("WROTE: 52 native PDP-6 PASS and 8 real 71-bit GCC link "
          "failures, %d raw artifacts, archive SHA256 %s" %
          (len(saved), sha(ARCHIVE.read_bytes())))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.write:
        write()
    else:
        audit()
        print("PASS: eight full KCC/GCC signed/unsigned FP36 suites "
              "48 native guest PASS, KCC original 2 PASS plus 2 line "
              "diagnostic PASS, GCC 71-bit original 8 genuine link_fail")


if __name__ == "__main__":
    main()
