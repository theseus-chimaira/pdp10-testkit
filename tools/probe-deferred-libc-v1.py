#!/usr/bin/env python3
"""Run selected libc/header-dependent bare-metal tests without matrix activation.

Probe status is evidence, not a classification change.  The existing semantic
runner supplies the normal CRT, real installed libc fragments, and PDP-6
emulator, and enforces __test_exit=0.  No dummy libc routines are introduced.
"""

import argparse
import csv
import importlib.util
import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
SPEC = importlib.util.spec_from_file_location("p10tk_matrix_runner_v1",
                                              ROOT / "tools/run-tests.py")
RUNNER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RUNNER)


def probe(sources, compiler, outdir):
    selected = (("kcc", "gcc") if compiler == "all" else (compiler,))
    profiles = {}
    for item in RUNNER.all_profiles():
        if (item["compiler"] in selected and item["machine"] == "pdp6" and
                item["family"] == "native" and
                item["optname"] == ("noopt" if item["compiler"] == "kcc"
                                    else "o0")):
            profiles[item["compiler"]] = item
            profiles[item["compiler"]]["kind"] = "semantic"
    RUNNER.setup_prefix_env(set(selected))
    bins = {name: RUNNER.find_one(name) for name in
            ("kcc", "gcc", "p10run") if name in selected or name == "p10run"}
    outdir.mkdir(parents=True, exist_ok=True)
    results = []
    for src in sources:
        src_path = (ROOT / src).resolve()
        if (not src_path.is_relative_to(ROOT / "tests") or
                not src_path.is_file()):
            raise ValueError("source must be an existing tests/ file: " + src)
        for name in selected:
            cell = profiles[name]
            print("PROBE %s %s" % (name, src), flush=True)
            status = RUNNER.run_semantic_cell(
                len(results) + 1, len(sources) * len(selected), src,
                cell, outdir, bins, None, announce=False)
            checkpoint = RUNNER.read_cell_status(outdir, src, cell)
            assert checkpoint is not None and checkpoint["status"] == status
            result = {"source": src, "compiler": name, "cpu": "pdp6",
                      "optimization": "-n" if name == "kcc" else "-O0",
                      "status": status, "report": checkpoint["report"]}
            results.append(result)
            print("  RESULT %s %s" % (status, checkpoint["report"]),
                  flush=True)
            # Preserve partial results even if a later test is interrupted.
            with (outdir / "results-v1.tsv").open("w", newline="") as out:
                writer = csv.DictWriter(out, fieldnames=results[0].keys(),
                                        delimiter="\t", lineterminator="\n")
                writer.writeheader()
                writer.writerows(results)
    # An observed test failure is evidence to classify, not a harness error.
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--source", action="append", required=True,
                    help="source path under tests/ (repeat for more sources)")
    ap.add_argument("--compiler", choices=("kcc", "gcc", "all"),
                    default="all")
    ap.add_argument("--outdir", default=str(Path(os.environ.get(
                    "TMPDIR") or (Path.home() / "tmp")) /
                    "p10tk-deferred-libc-probe-v1"))
    args = ap.parse_args()
    return probe(args.source, args.compiler, Path(args.outdir))


if __name__ == "__main__":
    sys.exit(main())
