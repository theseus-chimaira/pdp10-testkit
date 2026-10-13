"""Stateful KCC assembly assertions preserved from legacy AWK regressions.

Each checker returns a list of failed original properties.  These checkers
operate on the complete assembly text, not on a partial instruction listing.
"""
import re
import os
from pathlib import Path

FUNCTION = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*):$")
LOOP = re.compile(r"^%DIDIV[0-9]+L:")
LOOP_END = re.compile(r"^%DIDIV[0-9]+NS:")


def instruction(line):
    parts = line.strip().split(None, 1)
    return (parts[0].upper(), parts[1] if len(parts) > 1 else "") if parts else ("", "")


def div_one_scratch(lines):
    top = dict.fromkeys(("sq", "sr", "uq", "ur"), 0)
    carry = top.copy()
    direct = top.copy()
    fn = ""
    inside = False
    for line in lines:
        m = FUNCTION.match(line)
        if m and m.group(1) in top:
            fn = m.group(1)
            continue
        if LOOP.match(line):
            inside = True
            continue
        if inside and LOOP_END.match(line):
            inside = False
            continue
        if not inside or fn not in top:
            continue
        op, args = instruction(line)
        if op == "LSH" and re.match(r"[^,]+,-0?43", args):
            top[fn] += 1
        if op == "LSH" and re.match(r"[^,]+,-0?42", args):
            carry[fn] += 1
        if op == "TLNN" and re.match(r"[^,]+,200000000000", args):
            direct[fn] += 1
    return [] if (all(v == 1 for v in top.values())
                  and carry == {"sq": 3, "sr": 2, "uq": 3, "ur": 2}
                  and not any(direct.values())) else ["divider carry extraction counts"]


def div_reuse_bit_temp(lines):
    inside = False
    last = bit = compare = ""
    tlcs = 0
    for line in lines:
        if LOOP.match(line):
            inside = True
            continue
        if inside and LOOP_END.match(line):
            inside = False
        if not inside:
            continue
        op, args = instruction(line)
        if op == "MOVE":
            last = args.split(",", 1)[0]
            continue
        if op == "LSH" and re.search(r",-0?43$", args):
            bit = args.split(",", 1)[0]
            continue
        if op == "TLC" and re.search(r",0*400000$", args):
            tlcs += 1
            if tlcs == 2:
                compare = last
    return [] if bit and compare and bit == compare else ["divider comparison AC not reused"]


def mod_no_quotient(lines):
    fn = ""
    inside = False
    iori = dict.fromkeys(("sr", "ur"), 0)
    for line in lines:
        m = FUNCTION.match(line)
        if m and m.group(1) in iori:
            fn = m.group(1)
        if LOOP.match(line):
            inside = True
            continue
        if inside and LOOP_END.match(line):
            inside = False
            fn = ""
            continue
        if inside and fn in iori and instruction(line)[0] == "IORI":
            iori[fn] += 1
    bad = []
    if any(iori.values()):
        bad.append("quotient-state IORI in remainder loop")
    for name in ("sr", "ur"):
        started = found = spilled = False
        for line in lines:
            if line == name + ":":
                started = True
                continue
            if not started:
                continue
            if LOOP.match(line):
                found = True
                break
            if FUNCTION.match(line):
                break
            if instruction(line)[0] in ("PUSH", "POP"):
                spilled = True
        if not found or spilled:
            bad.append(name + " does not use register-resident remainder path")
    return bad


def div_helper_cost(lines):
    code = {}
    fn = ""
    calls = 0
    for line in lines:
        m = FUNCTION.match(line)
        if m:
            fn = m.group(1)
            continue
        if fn in ("d1", "d2", "d4", "d8") and re.match(r"^[ \t]+[A-Za-z]", line):
            code[fn] = code.get(fn, 0) + 1
        if re.search(r"pushj.*__kcc_divdi3", line, re.I):
            calls += 1
    try:
        valid = (code["d1"] > code["d2"] and
                 code["d4"] < code["d1"] * 4 and
                 code["d8"] < code["d1"] * 8 and calls == 14)
    except KeyError:
        valid = False
    return [] if valid else ["divider inline/helper cost and call counts"]


def div_helper_selection(lines):
    """Preserve inline/helper choices and required installed runtime symbols."""
    bodies = {}
    current = ""
    for line in lines:
        m = FUNCTION.match(line)
        if m:
            current = m.group(1)
        elif current in ("one", "two", "mix", "utwo"):
            bodies.setdefault(current, []).append(line)
    body = {name: "\n".join(bodies.get(name, []))
            for name in ("one", "two", "mix", "utwo")}
    errors = []
    if "%DIDIV" not in body["one"] or "__kcc_divdi3" in body["one"]:
        errors.append("single division must be inline")
    if len(re.findall(r"pushj.*__kcc_divdi3", body["two"], re.I)) != 2:
        errors.append("two divisions must use two shared signed helpers")
    if "%DIDIV" not in body["mix"] or re.search(
            r"pushj.*__kcc_.*di3", body["mix"], re.I):
        errors.append("combined quotient/remainder must be inline")
    if len(re.findall(r"pushj.*__kcc_udivdi3", body["utwo"], re.I)) != 2:
        errors.append("two unsigned divisions must use two shared helpers")
    root = Path(os.environ.get("PDP10_PREFIX", "/usr/local")) / "lib/kcc"
    symbols = ("__kcc_divdi3", "__kcc_moddi3",
               "__kcc_udivdi3", "__kcc_umoddi3")
    for cpu in ("pdp6", "ka10", "ks10"):
        runtime = root / (cpu + "rt.s")
        try:
            text = runtime.read_text()
        except OSError:
            errors.append("runtime source unavailable: " + str(runtime))
            continue
        for symbol in symbols:
            if re.search(r"(?m)^" + symbol + r":", text) is None:
                errors.append(cpu + " runtime missing " + symbol)
    return errors


CHECKS = {
    "dimode-div-one-scratch": div_one_scratch,
    "dimode-div-reuse-bit-temp": div_reuse_bit_temp,
    "dimode-mod-no-quotient": mod_no_quotient,
    "dimode-div-helper-cost": div_helper_cost,
    "dimode-div-helper-selection": div_helper_selection,
}


def failures(name, asm):
    if name not in CHECKS:
        return ["unknown KCC assembly checker " + name]
    return CHECKS[name](asm.splitlines())
