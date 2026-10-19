#!/usr/bin/env python3
"""Measure PDP-6 executed instruction steps for search libc vs C reference.

The first step count that reaches the CRT HALT with __test_exit=0 is found
by monotone binary search.  Both variants use identical caller source,
compiler/profile, 16 searches and observable checksums.  This is a SIMH
instruction count, NOT simulated elapsed time or AAP logical ticks.
"""

import argparse
import csv
import os
from pathlib import Path
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]
CASES = ("strstr", "strpbrk", "strspn")


def call(command, cwd=ROOT):
    result = subprocess.run(command, cwd=cwd, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True)
    if result.returncode:
        raise RuntimeError("%s\n%s" % (" ".join(map(str, command)),
                                       result.stdout[-1600:]))
    return result.stdout


def compile_case(prefix, folder, name, variant, compiler, opt):
    work = folder / ("%s-%s" % (name, variant))
    work.mkdir(parents=True, exist_ok=True)
    output = work / "main.s"
    source = ROOT / "tests/semantic/freestanding-search-benchmark-v1.c"
    refsource = ROOT / "tests/semantic/freestanding-search-reference-v1.c"
    define = "-DBENCH_%s" % name.upper()
    if compiler == "kcc":
        cc = [str(prefix / "bin/kcc"), "-S", "-v=nostats", "-x=pdp6"]
        if opt == "noopt":
            cc.append("-n")
    else:
        cc = [str(prefix / "bin/pdp10-dec-none-gcc"), "-S", "-fno-builtin",
              "-march=pdp6", "-" + opt]
    call(cc + [define, "-o", str(output), str(source)])
    sources = [str(ROOT / "support/crt0-upstream-v1.s"), str(output)]
    if variant == "asm":
        sources.append(str(prefix / ("lib/kcc/freestanding/"
                                     "kcc-libc-%s-v1.s" % name)))
    else:
        reference = work / "reference.s"
        call(cc + ["-o", str(reference), str(refsource)])
        sources.append(str(reference))
    sources.extend((str(ROOT / "support/exit-v1.s"),
                    str(ROOT / "support/abort-v1.s")))
    return work, sources


def enough_steps(p10run, work, sources, count):
    run = [str(p10run), "--machine", "pdp6", "--mode", "deposit",
           "--exec-mode", "step", "--step-limit", str(count),
           "--timeout", "30", "--workdir", str(work / "simh"),
           "--name", "p10tk-search-bench-v1",
           "--expect", "__test_exit=0",
           "--expect", "benchmark_done_v1=1",
           "--expect", "benchmark_checksum_v1=20"] + sources
    result = subprocess.run(run, cwd=ROOT, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True)
    if result.returncode == 0:
        return True
    # Only a value-not-yet-set mismatch is an ordinary short run.
    # Any assembler error, invalid instruction, crash, or other failure
    # must abort the measurement instead of being counted as too short.
    if ("FAIL: __test_exit: got 000000000001 expected 000000000000"
            in result.stdout and "error:" not in result.stdout.lower()):
        return False
    raise RuntimeError("measurement failed with %d steps:\n%s" %
                       (count, result.stdout[-1500:]))


def measure(p10run, work, sources, maximum):
    high = maximum
    if not enough_steps(p10run, work, sources, high):
        raise RuntimeError("did not complete by max-steps=%d" % maximum)
    low = 0
    while high - low > 1:
        mid = (high + low) // 2
        if enough_steps(p10run, work, sources, mid):
            high = mid
        else:
            low = mid
    return high


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", choices=("kcc", "gcc"), default="kcc")
    parser.add_argument("--opt", default="noopt",
                        help="KCC: opt/noopt, GCC: O0/O1/O2/Os")
    parser.add_argument("--case", choices=CASES + ("all",), default="all")
    parser.add_argument("--max-steps", type=int, default=500000)
    parser.add_argument("--outdir", default=str(Path(
        os.environ.get("TMPDIR") or (Path.home() / "tmp")) /
        "p10tk-search-benchmark-v1"))
    args = parser.parse_args()
    if args.opt not in (("opt", "noopt") if args.compiler == "kcc"
                        else ("O0", "O1", "O2", "Os")):
        parser.error("invalid optimization for compiler")
    prefix = Path(os.environ.get("PDP10_PREFIX") or
                  (Path.home() / "cross")).resolve()
    folder = Path(args.outdir).resolve()
    folder.mkdir(parents=True, exist_ok=True)
    cases = CASES if args.case == "all" else (args.case,)
    p10run = prefix / "bin/p10run"
    output = folder / "results-v1.tsv"
    results = []
    for name in cases:
        for variant in ("asm", "c"):
            work, sources = compile_case(prefix, folder, name, variant,
                                         args.compiler, args.opt)
            print("Measuring %s/%s/%s %s" %
                  (args.compiler, args.opt, name, variant), flush=True)
            steps = measure(p10run, work, sources, args.max_steps)
            print("  completed at %d SIMH instruction steps" % steps,
                  flush=True)
            results.append({"compiler": args.compiler, "opt": args.opt,
                            "function": name, "variant": variant,
                            "steps_to_halt": steps})
            with output.open("w", newline="") as stream:
                writer = csv.DictWriter(stream, fieldnames=results[0],
                                        delimiter="\t", lineterminator="\n")
                writer.writeheader()
                writer.writerows(results)
    print("Saved %s" % output)


if __name__ == "__main__":
    try:
        main()
    except RuntimeError as error:
        sys.exit(str(error))
