#!/usr/bin/env python3
"""Fail-closed host tests for the ICE-only compiler harness exit policy.

This policy only changes exit accounting.  An ordinary source error,
target linker failure or guest assertion is still recorded as FAIL,
never transformed into a PASS or removed from failures.tsv.
"""

import importlib.util
import os
from pathlib import Path
import sys
import tempfile
from types import SimpleNamespace

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
SPEC = importlib.util.spec_from_file_location(
    "p10tk_runner_ice_exit_v1", ROOT / "tools/run-tests.py")
RUNNER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RUNNER)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def check_status_accounting():
    observations = {"pass": 2, "compile_only": 1, "compile_fail": 3,
                    "link_fail": 4, "run_fail": 5, "timeout": 6,
                    "unexpected_compile_success": 2}
    require(RUNNER.failure_count_from_counts(observations) == 20,
            "raw failures lost while selecting ICE-only mode")
    require(RUNNER.exit_failure_count(observations, "strict") == 20,
            "default strict behavior changed")
    require(RUNNER.exit_failure_count(observations, "ice-only") == 0,
            "real non-ICE source defects unexpectedly stop the harness")
    for status in ("compiler_ice", "setup_fail", "policy_fail", "running",
                   "not_run", "unexpected_result"):
        changed = dict(observations)
        changed[status] = 1
        require(RUNNER.exit_failure_count(changed, "ice-only") == 1,
                "unsafe incomplete/ICE/setup status accepted: " + status)
    require(RUNNER.exit_failure_count(observations, "ice-only",
                                      ["missing-original.c"]) == 1,
            "unregistered source silently ignored")
    require(RUNNER.exit_failure_count(observations, "ice-only", (),
                                      {"semantic": 2}) == 2,
            "wrong matrix kind silently ignored")
    for policy in ("", "ignore-everything"):
        try:
            RUNNER.exit_failure_count(observations, policy)
        except ValueError:
            pass
        else:
            raise AssertionError("unknown exit policy accepted")
    # Compiler command lines are recorded in cell.log. A path containing
    # "ice-only" must not transform an ordinary missing-header error into
    # a compiler ICE, even when the command precedes its diagnostic.
    false_ice = ("$ /prefix/bin/pdp10-gcc -S -o "
                 "/scratch/p10tk-harness-ice-only-v1/test.s\n"
                 "/source/ice-only.c:12:18: math.h: No such file or directory\n")
    require(RUNNER.compile_failure_status("fail", false_ice) ==
            "compile_fail", "compiler ICE regex matched output/source path")
    for true_ice in ("source.c:11: Internal compiler error in pass",
                     "gcc: ICE: unrecognizable insn",
                     "ICE: target expansion impossible",
                     "[Internal error] gizlist: bad size"):
        require(RUNNER.compile_failure_status("fail", true_ice) ==
                "compiler_ice", "actual compiler crash diagnostic missed")


def check_summary():
    base = os.environ.get("TMPDIR") or str(Path.home() / "tmp")
    Path(base).mkdir(parents=True, exist_ok=True)
    args = SimpleNamespace(compiler="all", family="native", cpu="pdp6",
                           opt="all", kind="all", exit_policy="ice-only",
                           source=None, source_file=None)
    account = {"old_green": 0, "old_fail": 0, "old_other": 0,
               "old_skipped": 0, "new_missing": 1, "to_run": 1}
    with tempfile.TemporaryDirectory(prefix="p10tk-harness-ice-v1-",
                                     dir=base) as directory:
        path = Path(directory) / "summary.txt"
        RUNNER.write_summary(path, Path(directory), args, 1, 0, 0, 0,
                             1, {"gcc": 1}, account, 0, 1, 0, 0, 1,
                             {"link_fail": 1}, [], {})
        data = path.read_text(encoding="ascii")
        for required in ("exit_policy=ice-only\n", "fail=1\n",
                         "exit_fail=0\n", "link_fail=1\n"):
            require(required in data, "lost honest result: " + required)
        RUNNER.write_summary(path, Path(directory), args, 1, 0, 0, 0,
                             1, {"gcc": 1}, account, 0, 1, 0, 0, 1,
                             {"compiler_ice": 1}, [], {})
        data = path.read_text(encoding="ascii")
        require("fail=1\n" in data and "exit_fail=1\n" in data,
                "ICE not retained as an actual failing compiler result")


def check_coverage():
    profiles = [p for p in RUNNER.all_profiles()
                if p["family"] == "native" and p["machine"] == "pdp6"]
    require(len(profiles) == 6, "native PDP-6 compiler matrix changed")
    rows = RUNNER.split_rows()
    semantic, other, missing, ignored = RUNNER.build_cells(rows, profiles)
    require(not missing and not ignored,
            "matrix contains missing sources or silently ignored cells")
    by_source = {r["test"]: r for r in rows}
    vla = ("tests/codegen/kcc-ported/vla-base_vla.c",
           "tests/codegen/kcc-ported/vla-kcc_modern_vla_scope.c")
    for src in vla:
        require(by_source[src]["group"] == "semantic-kcc-ported-vla" and
                sum(path == src for path, _ in semantic) == 6,
                "runtime-asserting VLA test silently excluded")
    isa = [r["test"] for r in rows if r["group"] == "isa"]
    require(len(isa) == 105 and len(set(isa)) == 105,
            "C-to-ISA compiler test inventory incomplete")
    isa_source = RUNNER.read_source_list(
        ROOT / "docs/PDP10-ISA-C-SOURCES-20261121-v1.txt", set(by_source))
    require(tuple(isa) == isa_source,
            "source-pinned ISA C tests are not selectable")
    kcc6 = [p for p in profiles if p["compiler"] == "kcc" and
            p["optname"] == "noopt"]
    _s, compiled, _missing, errors = RUNNER.build_cells(
        [by_source[s] for s in isa], kcc6)
    require(len(compiled) == 99 and not errors,
            "99 enabled PDP-6 C-to-ISA compiler checks silently omitted")
    assert sum(r["group"].endswith("p1-original-observation")
               for r in rows) == 38
    for src in (vla[0], vla[1]):
        mutated = [dict(r) if r["test"] == src else r for r in rows]
        victim = next(r for r in mutated if r["test"] == src)
        victim["group"] = "codegen-kcc-ported"
        _semantic, _other, _missing, errors = RUNNER.build_cells(
            mutated, profiles)
        require(errors.get("semantic") == 6,
                "wrong source-kind scheduling no longer detectable")
    require(RUNNER.parse_args(["--exit-policy", "ice-only"]).exit_policy
            == "ice-only", "ICE-only CLI option not exposed")
    require(RUNNER.parse_args([]).exit_policy == "strict",
            "default strict exit behavior changed")
    manifest = ROOT / "docs/PDP10-P1-HARNESS-OBSERVATIONS-20261121-v1.txt"
    names = RUNNER.read_source_list(manifest, set(by_source))
    require(len(names) == 38 and len(set(names)) == 38,
            "original-source selection is not 38 unique matrix tests")
    all_c = RUNNER.read_source_list(
        ROOT / "docs/PDP10-P1-HARNESS-ALL-C-20261121-v1.txt",
        set(by_source))
    require(len(all_c) == 66 and set(names).issubset(all_c),
            "historical P1 source sweep loses original owners")
    require(RUNNER.parse_args(["--source-file", str(manifest)]).source_file
            == str(manifest), "source selection CLI not wired")
    base = os.environ.get("TMPDIR") or str(Path.home() / "tmp")
    Path(base).mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="p10tk-source-list-v1-",
                                     dir=base) as directory:
        temp = Path(directory) / "sources-v1.txt"
        for data in ("", "# comment only\n", "tests/unknown.c\n",
                     names[0] + "\n" + names[0] + "\n",
                     "../tests/sample.c\n", "/etc/passwd\n"):
            temp.write_text(data, encoding="ascii")
            try:
                RUNNER.read_source_list(temp, set(by_source))
            except ValueError:
                pass
            else:
                raise AssertionError("invalid or missing source selection accepted")


def main():
    check_status_accounting()
    check_summary()
    check_coverage()
    print("PASS: ICE-only exit preserves raw non-ICE failures, blocks ICE/"
          "setup/incomplete tests and admits both VLA assertion suites")


if __name__ == "__main__":
    main()
