#!/usr/bin/env python3
"""Run signed 71-bit C casts on independent PDP-6 AAP hardware emulation.

The current AAP emulator no longer exposes cpustatus or timing debug traces.
Instead, initialize the linked program's __test_exit word to a NONZERO
sentinel, verify that sentinel before starting, and poll the *real simulator
thread's* synchronous memory examination until exit(0) writes zero.  The
linked CRT writes failure=1 before calling main; abort() writes 1, whereas
exit(0) writes 0.  A negative-control guest that HALTs immediately must
therefore never satisfy the completion oracle.

This verifies software D-format guest execution on AAP PDP-6; it does not
claim native PDP-6 floating hardware or other PDP-10 processors work.
"""

import os
from pathlib import Path
import pty
import re
import select
import shutil
import subprocess
import sys
import tempfile
import time


ROOT = Path(__file__).resolve().parents[2]
PDP10_PREFIX = Path(os.environ.get("PDP10_PREFIX") or
                    (Path.home() / "cross"))
AAP_ROOT = Path(os.environ.get("PDP6_AAP_ROOT") or
                (ROOT.parent / "pdp6"))
TMPDIR = Path(os.environ.get("TMPDIR") or (Path.home() / "tmp"))
WORD_RE = re.compile(r"^deposit ([0-7]{6}) ([0-7]{12})$", re.M)
READBACK_RE = re.compile(rb"([0-7]{6}):\s*([0-7]{12})")
SENTINEL = 0o777
HALT = 0o254200000000
SOURCES = ("main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c "
           "netmem.c netcons.c cmd.c util.c threading.c rtc.c "
           "../tools/pdp6common.c").split()


def command(argv, cwd=ROOT):
    result = subprocess.run([str(x) for x in argv], cwd=cwd,
                            capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError("%s failed:\n%s" %
                           (" ".join(map(str, argv)),
                            (result.stdout + result.stderr)[-1800:]))


def build_emulator(work):
    src = AAP_ROOT / "emu"
    emulator = work / "pdp6-aap-guest-v1"
    command([os.environ.get("CC", "cc"), "-O2", "-o", emulator]
            + SOURCES + ["-lpthread", "-lm"], cwd=src)
    return emulator


def build_guest(work, mode, case):
    sources = {
        "upstream": "tests/semantic/upstream/wide-int/930622-2.c",
        "boundary": "tests/semantic/kcc-dimode-float-pdp6-v1.c",
        "nativefloat": "tests/semantic/kcc-pdp6-dimode-nativefloat-v1.c",
        "literal": "tests/semantic/kcc-pdp6-float-literal-v1.c",
        "floatfold": "tests/semantic/kcc-pdp6-float-fold-v1.c",
        "negativehalfway": "tests/semantic/kcc-pdp6-negative-halfway-aap-v3.c",
        "roundedfp": "tests/semantic/kcc-pdp6-rounded-fp-boundaries-v2.c",
    }
    source = ROOT / sources[case]
    library = (PDP10_PREFIX / "lib/kcc/freestanding/"
               "kcc-libc-dimode-float-pdp6-v1.s")
    output = work / ("%s-%s.s" % (case, mode))
    cc = [os.environ.get("KCC_BIN") or (PDP10_PREFIX / "bin/kcc"),
          "-S", "-v=nostats", "-x=pdp6"]
    if mode == "noopt":
        cc.append("-n")
    command(cc + ["-o", output, source])
    name = "kcc-aap-dformat-%s-%s-v1" % (case, mode)
    simh_work = work / ("simh-" + mode)
    run = [PDP10_PREFIX / "bin/p10run", "--machine", "pdp6",
             "--mode", "deposit", "--exec-mode", "step",
             "--step-limit", "2000000", "--timeout", "30",
             "--workdir", simh_work, "--name", name,
             "--expect", "__test_exit=0"]
    if case == "boundary":
        run += ["--expect", "df_case_index_v1=021",
                "--expect", "df_fraction_case_index_v1=012"]
    elif case == "nativefloat":
        run += ["--expect", "native_float_case_v1=025"]
    elif case == "literal":
        run += ["--expect", "literal_case_v1=011"]
    elif case == "floatfold":
        run += ["--expect", "kff_case_v1=024",
                "--expect", "kff_cmp_v1=1"]
    elif case == "negativehalfway":
        run += ["--expect", "pdp6_negative_half_index_v3=010"]
    elif case == "roundedfp":
        run += ["--expect", "pdp6_fp_case_index_v2=030"]
    command(run + [
             ROOT / "support/crt0-upstream-v1.s", output, library,
             ROOT / "support/exit-v1.s", ROOT / "support/abort-v1.s"])
    labels = {}
    for line in (simh_work / (name + ".labels")).read_text().splitlines():
        match = re.fullmatch(r"(\S+)\s+([0-7]{6})", line.strip())
        if match:
            labels[match[1]] = int(match[2], 8)
    start, status, exit_pc = (labels[s] for s in
                              ("__start", "__test_exit", "exit"))
    words = {int(a, 8): int(v, 8) for a, v in
             WORD_RE.findall((simh_work / (name + ".simh")).read_text())}
    if (len(words) < 100 or words.get(exit_pc + 1) != HALT or
            words.get(start) == HALT or status in words):
        raise RuntimeError("Unexpected linked-guest startup, exit, or BSS")
    return words, start, status


def run_aap(emulator, work, words, start, status, should_succeed, timeout):
    guest_dir = work / ("positive" if should_succeed else "negative")
    guest_dir.mkdir(parents=True)
    (guest_dir / "init.ini").write_text(
        "mkdev apr apr166\n"
        "mkdev ptr ptr760 1\n"
        "mkdev fmem fmem162 0\n"
        "mkdev mem0 moby mem_0\n"
        "connectio ptr apr\n"
        "connectmem fmem 0 apr -1\n"
        "connectmem mem0 0 apr 0\n")

    master, slave = pty.openpty()
    try:
        with (guest_dir / "console.log").open("wb") as console, \
             (guest_dir / "stderr.log").open("wb") as errors:
            trace_path = None
            args = [str(emulator)]
            if (os.environ.get("PDP6_AAP_TRACE_ROUNDED_V1") == "1" and
                    "roundedfp" in str(work) and should_succeed):
                trace_path = guest_dir / "pulse-register-trace-v1.log"
                args += ["-t", "-d", str(trace_path)]
            process = subprocess.Popen(args, cwd=guest_dir,
                                       stdin=subprocess.PIPE, stdout=slave,
                                       stderr=errors, bufsize=0)
            os.close(slave)
            slave = -1

            def send(lines):
                process.stdin.write(("\n".join(lines) + "\n").encode("ascii"))
                process.stdin.flush()

            def receive(wait):
                data = bytearray()
                while select.select([master], [], [], wait)[0]:
                    try:
                        part = os.read(master, 16384)
                    except OSError:
                        break
                    if not part:
                        break
                    data.extend(part)
                    console.write(part)
                    console.flush()
                    wait = 0.015
                return bytes(data)

            def examine():
                send(["examine %o" % status])

            try:
                init = ["power on"]
                init += ["deposit %o %012o" % (addr, val)
                         for addr, val in sorted(words.items())]
                init += ["deposit %o %012o" % (status, SENTINEL),
                         "examine %o" % status]
                send(init)
                address = b"%06o" % status
                sentinel = address + (b": %012o" % SENTINEL)
                success = address + b": 000000000000"
                text = bytearray()
                deadline = time.monotonic() + 15
                while sentinel not in text and time.monotonic() < deadline:
                    text.extend(receive(0.12))
                    if process.poll() is not None:
                        raise RuntimeError("AAP exited while loading guest")
                if sentinel not in text:
                    raise RuntimeError("Could not verify initial nonzero sentinel")

                # Simulator-thread commands execute synchronously, so a
                # nonzero-before/zero-after transition proves exit(0) ran.
                send(["start %o" % start, "examine %o" % status])
                evidence = bytearray()
                observations = 0
                deadline = time.monotonic() + timeout
                found = False
                while time.monotonic() < deadline:
                    evidence.extend(receive(0.08))
                    if success in evidence:
                        found = True
                        break
                    if process.poll() is not None:
                        raise RuntimeError("AAP exited without guest result")
                    examine()
                    observations += 1
                    if len(evidence) > 100000:
                        del evidence[:-1500]
                if trace_path is not None:
                    output = TMPDIR / ("p10tk-aap-rounded-trace-" +
                                       work.name + "-v1.log")
                    shutil.copyfile(trace_path, output)
                    print("AAP pulse trace: %s" % output, flush=True)
                if found != should_succeed:
                    raise RuntimeError("AAP execution oracle mismatch: "
                                       "expected success=%s, found=%s" %
                                       (should_succeed, found))
                if not found and observations < 2:
                    raise RuntimeError("Negative control did not poll guest")
                send(["quit"])
                process.wait(timeout=5)
                receive(0.05)
                if process.returncode != 0:
                    raise RuntimeError("AAP process exited abnormally")
                print("  AAP %s: %s (%d polls)" %
                      (guest_dir.name, "PASS" if found else "REJECTED",
                       observations), flush=True)
            except BaseException:
                process.kill()
                process.wait()
                raise
    finally:
        os.close(master)
        if slave != -1:
            os.close(slave)


def main():
    TMPDIR.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="p10tk-aap-dformat-v1.",
                                     dir=TMPDIR) as temp:
        work = Path(temp)
        emulator = build_emulator(work)
        # The full 24-case AAP run is a separately registered manual
        # hardware-fidelity investigation: its case 9 differs from the
        # mathematical oracle. Never weaken the normal AAP acceptance.
        cases = (("roundedfp",) if os.environ.get("PDP6_AAP_FULL_ROUNDED_V2")
                 else ("upstream", "boundary", "nativefloat", "literal",
                       "floatfold", "negativehalfway"))
        for case in cases:
            for mode in ("opt", "noopt"):
                words, entry, status = build_guest(work, mode, case)
                print("AAP %s/%s: %d linked image words" %
                      (case, mode, len(words)), flush=True)
                run_aap(emulator, work / case / mode, words, entry,
                        status, True, 25)
                if case == "upstream" and mode == "opt":
                    negative = dict(words)
                    negative[entry] = HALT
                    run_aap(emulator, work / "negative-control", negative,
                            entry, status, False, 1.5)
        print("PASS independent AAP PDP-6 D-format/native-float guests v1")


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, OSError, TimeoutError) as exc:
        sys.exit("FAIL independent AAP guest: %s" % exc)
