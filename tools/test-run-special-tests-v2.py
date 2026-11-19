#!/usr/bin/env python3
"""Bounded dispatch checks; never execute real compiler or guest tests."""
import importlib.util
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "special_runner_v1", ROOT / "tools/run-special-tests-v1.py")
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)

rows = runner.entries()
manual = [row for row in rows if row["enabled"] == "manual"]
selectable = [row for row in manual if runner.eligible(row)]
native = [row for row in manual if runner.native(row)]
assert len(manual) == 19, len(manual)
assert len(native) == 0, len(native)
assert len(selectable) == 19, len(selectable)
assert not set(x["id"] for x in native) & set(x["id"] for x in selectable)

calls = []

class Result:
    def __init__(self, code):
        self.returncode = code


def fake_run(args, cwd, check):
    assert cwd == ROOT and check is False
    assert args[:2] == [str(ROOT / "run-misc-tests.sh"), "run-id"]
    assert args[3] == "--manual"
    calls.append(args[2])
    return Result(1 if args[2] == selectable[0]["id"] else 0)

with patch.object(runner.subprocess, "run", side_effect=fake_run):
    assert runner.main(["run", selectable[1]["id"]]) == 0
    assert calls == [selectable[1]["id"]]
    calls.clear()
    assert runner.main(["run-all"]) == 1
    assert calls == [row["id"] for row in selectable]
    calls.clear()
    for invalid in ("native-toolchain-moved-to-daimos", "nonexistent"):
        try:
            runner.main(["run", invalid])
        except SystemExit:
            pass
        else:
            raise AssertionError("invalid test was accepted: " + invalid)
    assert not calls
    assert runner.main(["list"]) == 0
    assert not calls
print("special runner dispatch v2: PASS (19 selectable, 0 native roots)")
