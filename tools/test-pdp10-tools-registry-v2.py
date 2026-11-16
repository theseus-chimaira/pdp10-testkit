#!/usr/bin/env python3
"""Check per-tool status isolation and single-build cleanup semantics."""

import contextlib
import importlib.util
import io
import os
from pathlib import Path
import tempfile


ROOT = Path(__file__).resolve().parents[1]
DISPATCHER = ROOT / "tools/run-misc-suites.py"


def require(ok, message):
    if not ok:
        raise AssertionError(message)


def load_dispatcher():
    # The module requires only this environment entry at import time.
    os.environ.setdefault("PDP10_PREFIX", "/unused-pdp10-prefix")
    spec = importlib.util.spec_from_file_location("misc_registry_v2", DISPATCHER)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def verify_case_reporting(dispatcher, directory):
    source = directory / "registry"
    source.mkdir()
    cases = source / "cases"
    cases.mkdir()
    for name in ("first", "middle", "last", "manual"):
        (cases / (name + ".sh")).write_text("#!/bin/sh\nexit 0\n",
                                            encoding="ascii")
    rows = ["id\tgroup\trunner\tpath\tprofile\tenabled\ttimeout"]
    for name, enabled, timeout in (("first", "yes", 11),
                                   ("middle", "yes", 15),
                                   ("last", "yes", 19),
                                   ("manual", "manual", 23)):
        rows.append("case-%s\ttools\tsh\tcases/%s.sh\trepository\t%s\t%d" %
                    (name, name, enabled, timeout))
    (source / "SPECIAL_TESTS.tsv").write_text("\n".join(rows) + "\n",
                                               encoding="ascii")
    invoked = []

    def fake_run(runner, path, env, timeout):
        invoked.append((path.name, timeout))
        if path.name == "middle.sh":
            raise SystemExit("injected case failure")

    dispatcher.ROOT = source
    dispatcher.run = fake_run
    output = io.StringIO()
    with contextlib.redirect_stdout(output):
        failures = dispatcher.run_special("tools", env={"TMPDIR": str(directory)})
    log = output.getvalue()
    require(failures == 1, "one failed case was not counted")
    require(invoked == [("first.sh", 11), ("middle.sh", 15),
                        ("last.sh", 19)], "wrong case order or timeout")
    for expected in ("PASS case-first", "PASS case-last",
                     "FAIL case-middle: injected case failure",
                     "suite tools: 3 executed, 2 passed, 1 failed"):
        require(expected in log, "missing result: " + expected)
    require("PASS case-middle" not in log and "manual" not in log,
            "failed or manual case improperly passed")


def verify_build_lifecycle(dispatcher, directory):
    source = directory / "independent-pdp10-tools"
    source.mkdir()
    for name in ("Makefile", "dobj.c", "p10run.c", "p10fold.c"):
        (source / name).write_text("fixture\n", encoding="ascii")
    old_repo = os.environ.get("PDP10_TOOLS_REPO")
    old_root, old_tmp = dispatcher.ROOT, dispatcher.TMP
    os.environ["PDP10_TOOLS_REPO"] = str(source)
    dispatcher.ROOT = ROOT
    dispatcher.TMP = str(directory)
    roots = []
    prepare_count = []
    case_count = []

    def prepare(*args, **kwargs):
        require(len(args) == 3 and args[0] == "sh" and
                Path(args[1]).name == "prepare-v2.sh" and
                kwargs["timeout"] == 240, "shared prepare invocation invalid")
        shared = Path(args[2])
        require(shared.is_dir() and kwargs["env"]["PDP10_TOOLS_WORK"] == str(shared),
                "shared build path not propagated")
        roots.append(shared)
        prepare_count.append(1)
        (shared / "prepared").write_text("one build\n", encoding="ascii")

    def cases(group, env):
        require(group == "tools" and len(prepare_count) == 1,
                "special cases started before preparation")
        require(Path(env["PDP10_TOOLS_WORK"], "prepared").is_file(),
                "case did not receive the prepared build")
        case_count.append(1)
        return 1  # One failed case must affect the entire suite status.

    dispatcher.run = prepare
    dispatcher.run_special = cases
    try:
        try:
            dispatcher.main("pdp10-tools")
        except SystemExit as exc:
            require("1 special test(s) failed" in str(exc),
                    "case failure did not propagate to suite exit")
        else:
            raise AssertionError("suite accepted a failed case")
        require(len(prepare_count) == 1 and len(case_count) == 1,
                "build or case batch ran more than once")
        require(all(not root.exists() for root in roots),
                "shared build was not removed after case failure")

        def failing_prepare(*args, **kwargs):
            roots.append(Path(args[2]))
            raise SystemExit("injected prepare failure")

        dispatcher.run = failing_prepare
        try:
            dispatcher.main("pdp10-tools")
        except SystemExit as exc:
            require("injected prepare failure" in str(exc),
                    "prepare failure was swallowed")
        else:
            raise AssertionError("suite ignored prepare failure")
        require(len(case_count) == 1 and not roots[-1].exists(),
                "preparation failure ran cases or leaked build directory")
    finally:
        dispatcher.ROOT = old_root
        dispatcher.TMP = old_tmp
        if old_repo is None:
            os.environ.pop("PDP10_TOOLS_REPO", None)
        else:
            os.environ["PDP10_TOOLS_REPO"] = old_repo


def main():
    tmp = os.environ.get("TMPDIR") or str(Path.home() / "tmp")
    Path(tmp).mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="pdp10-tools-registry-contract-v2.",
                                     dir=tmp) as dirname:
        directory = Path(dirname)
        dispatcher = load_dispatcher()
        verify_case_reporting(dispatcher, directory)
        verify_build_lifecycle(dispatcher, directory)
    print("pdp10-tools registry v2: PASS (case isolation, timeouts, cleanup)")


if __name__ == "__main__":
    main()
