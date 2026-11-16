#!/usr/bin/env python3
"""Run reviewed GCC PDP-10 codegen checks without DejaGNU.

The original sources are retained under refs/gcc-pdp10-target-v2.
Each case has an explicit compile profile and an explicit assembly oracle;
no DejaGNU comments are interpreted or executed by this runner.
"""

import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[2]
SOURCES = ROOT / "refs" / "gcc-pdp10-target-v2"

# Positive/negative expressions preserve the original GCC regression's
# instruction/representation contract, not just successful compilation.
CASES = (
    ("blt-component-word-offset-1.c", "-Os",
     (r"\bhrli\s+[0-7]+,3\(1\)", r"\bmovei\s+[0-7]+,3\(1\)"),
     (r"\bhrli\s+[0-7]+,014\(1\)",)),
    ("bss-word-reserve-1.c", "-O1 -march=pdp6",
     (r"region_map:\s*\.space\s+580\b",
      r"mres_member:\s*\.space\s+16\b"),
     (r"\bBLOCK\b",)),
    ("bss-zero-aggregate-1.c", "-O1",
     (r"zero_pair:\s*\.space\s+8\b",),
     (r"zero_pair:\s*\.space\s+2\b",)),
    ("char6-cast-1.c", "-O2",
     (r"\.word\s+0414243212223\b",), ()),
    ("char6-sixbit-1.c", "-O2",
     (r"\.word\s+0414243212223\b",), ()),
    ("char6-type-1.c", "-O2",
     (r"\.word\s+0414243212223\b", r"\bildb\s+1,1\b"), ()),
    ("cross-word-bitfield-store-1.c", "-O0",
     (r"\bdpb[^\n]*\bPOINT\s+20\b",), ()),
    ("das-octal-adjbp-1.c", "-O2 -march=pdp6",
     (r"\bmovei\s+0,020\b",), (r"\bmovei\s+0,16\b",)),
    ("das-octal-immediate-1.c", "-O2 -march=ka10",
     (r"\bmovei\s+1,042\b", r"\bmovei\s+1,043\b",
      r"\bmovei\s+1,053\b"),
     (r"\bmovei\s+1,(?:42|43|53)\b",)),
    ("default-base-stack-1.c", "-Os",
     (r"\badd\s+017\b",), (r"\bxmovei\s+017\b",)),
    ("udivmod-general-positive-divisor-1.c", "-O2",
     (r"\bjumpge\s+[0-7]+,\.\+16\b",),
     (r"\bjumpge\s+[0-7]+,\.\+14\b",)),
    ("wide-convert-71.c", "-O1 -march=pdp6 -mlong-long-71bit",
     (), ()),
)


def main():
    prefix = os.environ.get("PDP10_PREFIX", "")
    if not prefix:
        sys.exit("PDP10_PREFIX must identify the installed toolchain")
    compiler = Path(prefix) / "bin" / "pdp10-dec-none-gcc"
    if not compiler.is_file():
        sys.exit("missing target compiler: %s" % compiler)
    tempbase = Path(os.environ.get("TMPDIR") or (Path.home() / "tmp"))
    tempbase.mkdir(parents=True, exist_ok=True)
    failures = []
    with tempfile.TemporaryDirectory(prefix="gcc-target-codegen-v2-",
                                     dir=str(tempbase)) as work:
        for name, options, required, forbidden in CASES:
            source = SOURCES / name
            output = Path(work) / (name + ".s")
            if not source.is_file():
                failures.append((name, "missing source"))
                continue
            cmd = [str(compiler)] + options.split() + ["-S", str(source),
                                                      "-o", str(output)]
            try:
                result = subprocess.run(cmd, capture_output=True, text=True,
                                        timeout=30, check=False)
            except subprocess.TimeoutExpired:
                failures.append((name, "compiler timeout"))
                continue
            if result.returncode or not output.is_file() or not output.stat().st_size:
                failures.append((name, "compiler returned %d: %s" %
                                 (result.returncode, result.stderr[:300])))
                continue
            asm = output.read_text(encoding="latin-1")
            for expression in required:
                if not re.search(expression, asm, re.I | re.M):
                    failures.append((name, "missing: " + expression))
            for expression in forbidden:
                if re.search(expression, asm, re.I | re.M):
                    failures.append((name, "forbidden: " + expression))
            if not any(item[0] == name for item in failures):
                print("PASS " + name, flush=True)
    for name, detail in failures:
        print("FAIL %s: %s" % (name, detail), file=sys.stderr, flush=True)
    print("GCC target codegen: %d cases, %d failures" %
          (len(CASES), len(failures)), flush=True)
    return int(bool(failures))


if __name__ == "__main__":
    sys.exit(main())
