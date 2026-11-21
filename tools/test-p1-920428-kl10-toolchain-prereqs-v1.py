#!/usr/bin/env python3
"""Validate native KL10 assembler/linker/runner P1 prerequisites.

The original imported MACRO-10 source is byte-for-byte unchanged and
is still blocked by genuine DEFINE macro semantics.  This test proves
that the three independently repaired lower-level defects are fixed:
parenthesized 9-bit BYTE encoding, unused DOBJ EXTERN resolution, and
rejection of SIMH step-budget exhaustion as a spurious guest PASS.

No temporary test file or external definition substitutes for the
unchanged original.  A native KL10 PASS is deliberately NOT claimed.
"""

import hashlib
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
OUT = Path(os.environ.get("TMPDIR") or Path.home() / "tmp") / (
    "p10tk-p1-920428-kl10-prereqs-20261121-v1")
ORIGINAL = ROOT / "tests/semantic/upstream/support/920428-1.s"
ORIGINAL_SHA = "747162b74215e1176b7031671da7d24012ffbaa508bbc3a6caf1f3fcc8f86ead"
PORT = ROOT / "tests/isa/das-port/920428-1-das-v1.s"
PORT_SHA = "8c4fa21fe0cd2b5fc4e31cba59d50811711991b5eeaf2844a087a8726b88de01"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(cmd):
    proc = subprocess.run([str(x) for x in cmd], cwd=ROOT, text=True,
                          stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                          check=False, timeout=35)
    return proc.returncode, proc.stdout


def check(value, message):
    if not value:
        raise AssertionError(message)


def assemble(name, source):
    result = OUT / (name + ".dobj")
    rc, log = run(("das", "-C", "-O", result, source))
    check(rc == 0, "genuine DAS assembly failed: " + name + "\n" + log)
    check(result.is_file(), "no genuine assembled DOBJ: " + name)
    return result


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    check(sha(ORIGINAL) == ORIGINAL_SHA, "original 920428-1.s was modified")
    # The syntax port is not the original: never count its assembly
    # or runtime result as construction coverage of the original.
    check(PORT.is_file(), "prior syntax port missing")
    macro = assemble("macro10-byte", ROOT /
                     "tests/isa/das-port/pdp10-macro10-byte-directive-v1.s")
    legacy = assemble("das-byte", ROOT /
                      "tests/isa/das-port/pdp10-das-byte-equivalent-v1.s")
    check(macro.read_bytes() == legacy.read_bytes(),
          "MACRO-10 (9)0,(9)1 differs from established 9,0,1 packing")

    source = (ROOT / "tests/isa/das-port/pdp10-macro10-byte-directive-v1.s").read_text(
        encoding="ascii")
    invalid = OUT / "pdp10-invalid-directive-ka10-v1.s"
    invalid.write_text(source.replace(".DIRECTIVE KL10", ".DIRECTIVE KA10"),
                       encoding="ascii")
    check(invalid.read_text(encoding="ascii") != source,
          "invalid KL10 source mutation did not apply")
    rc, log = run(("das", "-C", "-O", OUT / "invalid.dobj", invalid))
    check(rc != 0 and "unsupported or conflicting .DIRECTIVE" in log,
          "unknown CPU directive was incorrectly accepted")
    rc, log = run(("das", "-C", "-K", "-O", OUT / "strict.dobj",
                   ROOT / "tests/isa/das-port/pdp10-macro10-byte-directive-v1.s"))
    check(rc != 0 and "unsupported or conflicting .DIRECTIVE" in log,
          "KL10 directive in strict baseline kernel mode was accepted")

    unused = assemble("unused-extern", ROOT /
                      "tests/isa/das-port/pdp10-unused-extern-link-v1.s")
    used = assemble("used-extern", ROOT /
                    "tests/isa/das-port/pdp10-used-extern-negative-v1.s")
    rc, log = run(("dlink", "-o", OUT / "unused.dxr", unused))
    check(rc == 0 and (OUT / "unused.dxr").is_file(),
          "unused original extern declaration forced a fake dependency\n" + log)
    rc, log = run(("dlink", "-o", OUT / "used.dxr", used))
    check(rc != 0 and "dlink: undefined symbol: %ONE" in log,
          "real external relocation lost its missing-definition error")

    # The unchanged original still contains MACRO-10 DEFINE expressions,
    # not yet implemented by DAS.  Requiring an explicit failure here
    # guards against a future silent no-op masquerading as coverage.
    rc, log = run(("das", "-C", "-O", OUT / "original.dobj", ORIGINAL))
    check(rc != 0 and "unknown op DEFINE" in log,
          "unchanged original DEFINE barrier unexpectedly changed")

    name = "p10tk-kl10-nonterminating-port-v1"
    work = OUT / "kl10-step-expired"
    work.mkdir(exist_ok=True)
    rc, log = run(("p10run", "--machine", "kl10", "--mode", "deposit",
                   "--exec-mode", "step", "--step-limit", "250000",
                   "--timeout", "8", "--workdir", work,
                   "--name", name, "--expect", "__test_exit=0",
                   "support/crt0-upstream-v1.s", PORT,
                   "support/exit-v1.s", "support/abort-v1.s"))
    report = work / (name + ".report.txt")
    check(rc != 0 and report.is_file() and
          "result=FAIL\n" in report.read_text(encoding="utf-8") and
          "Step expired" in report.read_text(encoding="utf-8"),
          "KL10 step-budget exhaustion misclassified as guest PASS\n" + log)
    print("PASS: MACRO-10 BYTE/DAS DOBJ parity, strict KL10 directive "
          "validation, unused-vs-required DOBJ imports, SIMH KL10 "
          "step-exhaustion rejection; unchanged DEFINE original "
          "remains correctly blocked")


if __name__ == "__main__":
    main()
