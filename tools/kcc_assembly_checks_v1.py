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


def direct_assignment_store(lines, machine):
    text = "\n".join(lines)
    stores = (
        re.search(r"(?im)^\s*movem\s+[1-7],gd$", text) and
        re.search(r"(?im)^\s*movem\s+[1-7],gd\+1$", text))
    double = re.search(r"(?im)^\s*dmovem\s+[1-7],gd$", text)
    if machine in ("pdp6", "ka10"):
        return [] if stores else ["missing MOVEM pair required on " + machine]
    if machine in ("ki10", "ks10"):
        return [] if double else ["missing DMOVEM required on " + machine]
    return ["unsupported processor for direct-store assertion: " + machine]


CHECKS = {
    "dimode-div-one-scratch": div_one_scratch,
    "dimode-div-reuse-bit-temp": div_reuse_bit_temp,
    "dimode-mod-no-quotient": mod_no_quotient,
    "dimode-div-helper-cost": div_helper_cost,
    "dimode-div-helper-selection": div_helper_selection,
    "direct-assignment-store": direct_assignment_store,
}


def failures(name, asm, machine=None):
    if name not in CHECKS:
        return ["unknown KCC assembly checker " + name]
    if name in ("direct-assignment-store", "cheap-optimizer-pass",
                "sidiv-shared-edge-v1"):
        if machine is None:
            return ["processor not supplied for " + name]
        return CHECKS[name](asm.splitlines(), machine)
    return CHECKS[name](asm.splitlines())


def _functions(lines):
    bodies = {}
    name = None
    for line in lines:
        match = FUNCTION.match(line)
        if match:
            name = match.group(1)
            bodies.setdefault(name, [])
        elif name is not None:
            bodies[name].append(line)
    return bodies


def _has(lines, pattern):
    return re.search(pattern, "\n".join(lines), re.I | re.M) is not None


def _legacy_addsub(lines):
    bodies = _functions(lines)
    return [] if (sum(bool(line.strip()) for line in bodies.get("addpair", [])) <= 30
                  and "subpair" in bodies and "sub_store_mem" in bodies) else [
                      "addpair exceeds 30 nonblank lines or sub functions absent"]


def _legacy_corpus(lines):
    num = 0
    prev_zero = None
    instr_count = 0
    for line in lines:
        op, args = instruction(line)
        if op == "MOVE":
            fields = [a.strip() for a in args.split(",")]
            if len(fields) == 2 and fields[0] == fields[1]:
                return ["redundant MOVE AC,AC"]
        if prev_zero and op in ("SETZ", "SETCA", "MOVEI"):
            if args.split(",", 1)[0].strip() == prev_zero:
                return ["clearing instruction immediately overwritten"]
        prev_zero = args.split(",", 1)[0].strip() if op == "SETZ" else None
        if re.match(r"^(MOVE|MOVEM|SETZ|ADD|SUB|IMUL|AND|IOR|XOR|LSHC|ASHC|CAM|JUMP)", op):
            instr_count += 1
    return [] if instr_count > 40 else ["corpus fewer than 41 selected instructions"]


def _legacy_loop(lines):
    bodies = _functions(lines)
    errors = []
    for name in ("simple", "with_continue"):
        body = bodies.get(name, [])
        if not _has(body, r"addi\s+[0-7]+,1"):
            errors.append(name + ": missing pointer increment")
        bases = sum(bool(re.search(r"movei\s+[0-7]+,-[0-9]+\(17\)", line, re.I)) for line in body)
        if bases > 1:
            errors.append(name + ": rebuilt array base")
    for name in ("body_write", "address_taken", "volatile_array", "byte_array",
                 "stride_two", "labelled", "branch_calls"):
        if _has(bodies.get(name, []), r"addi\s+[0-7]+,1"):
            errors.append(name + ": invalid induction strength reduction")
    return errors


def _legacy_reverse(lines):
    bodies = _functions(lines)
    errors = []
    for name in ("reverse_move", "resolved_reverse"):
        prev = ""
        for line in bodies.get(name, []):
            if (re.search(r"^\s*move\s+2,1\s*$", prev, re.I) and
                    re.search(r"^\s*move\s+1,2\s*$", line, re.I)):
                errors.append(name + ": reversed register copies")
            prev = line
    if not _has(lines, r"jrst\s+sink\s*$"):
        errors.append("tail call to sink missing")
    return errors


def _legacy_preserved_blt(lines):
    bodies = _functions(lines)
    req = {
        "keep4": [r"BLT\s*0,13", r"MOVEI\s*0,10", r"HRLI\s*0,"],
        "keep3": [r"move\s*10,-", r"move\s*11,-", r"move\s*12,-"],
        "keep4_auto": [r"adjsp\s*17,5", r"MOVEI\s*0,-4\(17\)",
                       r"HRLI\s*0,10", r"BLT\s*0,-1\(17\)"],
    }
    bad = {"keep4": [r"move\s*10,-"], "keep3": [r"BLT\s+"],
           "keep4_auto": [r"push\s*17,1[0-3]"]}
    errors = []
    for name, patterns in req.items():
        for pattern in patterns:
            if not _has(bodies.get(name, []), pattern):
                errors.append(name + ": missing " + pattern)
    for name, patterns in bad.items():
        for pattern in patterns:
            if _has(bodies.get(name, []), pattern):
                errors.append(name + ": forbidden " + pattern)
    return errors


CHECKS.update({
    "dimode-addsub-registers": _legacy_addsub,
    "dimode-corpus-survey": _legacy_corpus,
    "loop-induction-address": _legacy_loop,
    "register-overwrite-fold": _legacy_reverse,
    "preserved-blt": _legacy_preserved_blt,
})


def _legacy_memory_result(lines):
    text = "\n".join(lines)
    errors = []
    for op in ("addb", "andb", "iorb", "xorb"):
        if not re.search(r"(?im)^\s*" + op + r"\s+[0-9]+,", text):
            errors.append("missing " + op)
    for op, target in (("andb", "b"), ("iorb", "c"), ("xorb", "d")):
        if not re.search(r"(?im)^\s*" + op + r"[^\n]*" + target, text):
            errors.append(op + " constant fold missing")
    functions = _functions(lines)
    if _has(functions.get("f_complex", [])[:8], r"^\s*addb\s+"):
        errors.append("nonleaf direct ADDB")
    reg = functions.get("f_reg_call", [])
    if not _has(reg, r"^\s*addb\s+[0-9]+,0?10(?:\s|$)"):
        errors.append("AC10 ADDB missing")
    if _has(reg, r"^\s*addb\s+[0-9]+,0\(0?10\)"):
        errors.append("indexed ADDB instead of AC10")
    if re.search(r"(?im)^\s*movem\s+[0-9]+,(?:b|c|d)(?:[^A-Za-z0-9_]|$)", text):
        errors.append("compound assignment still emits MOVEM")
    return errors


def _legacy_scratch_member(lines):
    funcs = _functions(lines)
    errors = []
    for name in ("member_delta", "pointer_member_delta", "second_pair",
                 "stack_byte_postinc"):
        if _has(funcs.get(name, []), r"push\s+17,0*16|move\s+16,"):
            errors.append(name + " uses AC16 scratch")
    if not _has(funcs.get("stack_byte_postinc", []), r"ibp"):
        errors.append("stack byte postincrement missing IBP")
    for pattern in (r"push\s+17,0*16", r"move\s+16,", r"pushj"):
        if not _has(funcs.get("indirect_call", []), pattern):
            errors.append("indirect_call missing " + pattern)
    for pattern in (r"push\s*17,0*16", r"move\s*16,0\(17\)"):
        if not _has(funcs.get("unsigned_divide", []), pattern):
            errors.append("unsigned_divide missing " + pattern)
    return errors


CHECKS.update({
    "memory-result-fold": _legacy_memory_result,
    "scratch-member-elision": _legacy_scratch_member,
})


def _legacy_double_store(lines):
    bodies = _functions(lines)
    forwarded = bodies.get("forwarded", [])
    vol = bodies.get("volatile_reload", [])
    # In KI10 mode the backend uses DMOVEM/DMOVE; otherwise it uses
    # the scalar pair. Infer the architecture from the emitted store form.
    ki10 = _has(vol, r"dmovem\s+[1-7],vd")
    state = 0
    saved = first = ""
    found = False
    for line in forwarded:
        op, arg = instruction(line)
        fields = arg.split(",", 1)
        if len(fields) != 2:
            if state:
                state = 0
            continue
        dst, src = fields
        if ki10:
            if op == "DMOVEM" and src == "-1(17)":
                saved, state = dst, 1
            elif state == 1 and op == "DMOVE" and src == saved:
                found, state = True, 0
            else:
                state = 0
        elif op == "MOVEM" and src == "-1(17)":
            saved, state = dst, 1
        elif state == 1 and op == "MOVEM" and src == "0(17)" and dst.isdigit() and saved.isdigit() and int(dst) == int(saved) + 1:
            state = 2
        elif state == 2 and op == "MOVE" and src == saved:
            first, state = dst, 3
        elif state == 3 and op == "MOVE" and src.isdigit() and saved.isdigit() and first.isdigit() and dst.isdigit() and int(src) == int(saved) + 1 and int(dst) == int(first) + 1:
            found, state = True, 0
        else:
            state = 0
    errors = [] if found else ["forwarded: pair store-reload forwarding absent"]
    patterns = ([r"dmovem\s+[1-7],vd", r"movei\s+[1-7],vd",
                 r"dmove\s+[1-7],0\([1-7]\)"] if ki10 else
                [r"movem\s+[1-7],vd", r"movem\s+[1-7],vd\+1",
                 r"movei\s+[1-7],vd", r"move\s+[1-7],0\([1-7]\)",
                 r"move\s+[1-7],1\([1-7]\)"])
    for p in patterns:
        if not _has(vol, p):
            errors.append("volatile_reload: missing " + p)
    return errors


CHECKS["double-store-forward"] = _legacy_double_store


def _legacy_identical(lines):
    bodies = _functions(lines)
    errors = []
    expected = {
        "add_self": ([r"^\s*lsh\s+1,0?1"], [r"^\s*(?:move|add)\s+"]),
        "sub_self": ([r"^\s*setz\s+1,"], [r"^\s*(?:move|sub|xor)\s+"]),
        "xor_self": ([r"^\s*setz\s+1,"], [r"^\s*(?:move|sub|xor)\s+"]),
        "and_self": ([], [r"^\s*(?:move|and|ior)\s+"]),
        "or_self": ([], [r"^\s*(?:move|and|ior)\s+"]),
    }
    for name, (required, forbidden) in expected.items():
        for pattern in required:
            if not _has(bodies.get(name, []), pattern):
                errors.append(name + " missing " + pattern)
        for pattern in forbidden:
            if _has(bodies.get(name, []), pattern):
                errors.append(name + " retained " + pattern)
    if sum(bool(re.search(r"^\s*pushj\s+17,side", l, re.I))
           for l in bodies.get("xor_calls", [])) != 2:
        errors.append("xor_calls side-effect count != 2")
    if sum(bool(re.search(r"^\s*move\s+[0-7]+,0\([0-7]+\)", l, re.I))
           for l in bodies.get("xor_volatile", [])) < 2:
        errors.append("xor_volatile access count < 2")
    return errors


def _legacy_cheap_pass(lines, machine):
    bodies = _functions(lines)
    errors = []
    for name, req, bad in (
        ("incp", r"^\s*aos\s+1,", r"^\s*move\s+1,"),
        ("decp", r"^\s*sos\s+1,", r"^\s*move\s+1,")):
        if not _has(bodies.get(name, []), req):
            errors.append(name + " missing " + req)
        if _has(bodies.get(name, []), bad):
            errors.append(name + " retained final MOVE")
    if _has(bodies.get("same_load", []), r"^\s*add\s+[0-9]+,glob"):
        errors.append("same_load rereads glob")
    previous = ""
    for line in bodies.get("copy_store", []):
        if (_has([previous], r"^\s*move\s+[0-9]+,[0-9]+\s*$")
                and _has([line], r"^\s*movem\s+")):
            errors.append("copy_store MOVE temporary followed by MOVEM")
        previous = line
    if machine in ("ki10", "ks10"):
        for op in ("DMOVE", "DMOVEM"):
            if not _has(bodies.get("pair_store", []), r"^\s*" + op + r"\s+"):
                errors.append("pair_store missing " + op)
    return errors


CHECKS.update({
    "identical-pure-fold-v1": _legacy_identical,
    "cheap-optimizer-pass": _legacy_cheap_pass,
})


def _assert_patterns(bodies, specs):
    errors = []
    for fn, required, forbidden in specs:
        text = bodies.get(fn, [])
        for pattern in required:
            if not _has(text, pattern):
                errors.append(fn + ": missing " + pattern)
        for pattern in forbidden:
            if _has(text, pattern):
                errors.append(fn + ": forbidden " + pattern)
    return errors


def _legacy_cheap_six(lines):
    bodies = _functions(lines)
    specs = [
        ("addarg", [r"^\s*add\s+1,2"], [r"^\s*move\s+3,2"]),
        ("andarg", [r"^\s*and\s+1,2"], []),
        ("addone", [r"^\s*addi\s+1,1"], [r"^\s*movei\s+[0-9]+,1"]),
        ("bitzero", [r"^\s*trn[en]\s+1,0?777"], [r"^\s*(?:andi|cai)"]),
        ("bithigh", [r"^\s*tln[en]\s+1,0?777000"], [r"^\s*(?:andi|cai)"]),
        ("storezero", [r"^\s*setzb\s+1,"], [r"^\s*move\s+1,"]),
        ("storeones", [r"^\s*setob\s+1,"], [r"^\s*seto\s+1"]),
        ("complement", [r"^\s*setcm\s+1,0\(1\)"],
         [r"^\s*move\s+[0-9]+,0\(1\)"]),
    ]
    errors = _assert_patterns(bodies, specs)
    if not (_has(bodies.get("twice", []), r"^\s*add\s+([0-9]+),\1")
            or _has(bodies.get("twice", []), r"^\s*lsh\s+[0-9]+,1")):
        errors.append("twice not folded to one-register doubling")
    return errors


def _legacy_cheap_final(lines):
    bodies = _functions(lines)
    specs = []
    for name in ("eqc", "nec", "ltc"):
        specs.append((name, [r"^\s*cai[a-z]*\s+[0-7]+,7"],
                      [r"^\s*(?:movei|movni)\s+[0-7]+,7"]))
    specs += [
        ("csub", [r"^\s*movn\s+1,1", r"^\s*addi\s+1,7"], [r"^\s*sub\s+"]),
        ("idx1", [r"^\s*move\s+1,1\([0-7]+\)"], [r"^\s*addi\s+"]),
        ("idx3", [r"^\s*move\s+1,3\([0-7]+\)"], [r"^\s*addi\s+"]),
        ("asgn", [r"^\s*movem\s+2,0\(1\)", r"^\s*move\s+1,2"],
         [r"^\s*move\s+1,3"]),
        ("asadd", [r"^\s*movem\s+[0-7]+,0\(1\)", r"^\s*move\s+1,[0-7]+"], []),
        ("dupidx", [r"^\s*lsh\s+1,1"], []),
        ("cmp_sc", [r"^\s*move\s+2,0?10", r"^\s*lsh\s+2,0?33",
                    r"^\s*ash\s+2,-0?33"], [r"^\s*trne\s+0?10,0?400"]),
    ]
    for name, opcode in (("casadd", "addb"), ("casand", "andb"),
                         ("casor", "iorb"), ("casxor", "xorb")):
        specs.append((name, [r"^\s*" + opcode + r"\s+2,0\(1\)",
                             r"^\s*move\s+1,2"], [r"^\s*move\s+3,2"]))
    errors = _assert_patterns(bodies, specs)
    for name in ("dupidx", "dupand", "dupor"):
        p = (r"^\s*move\s+[0-7]+,0\([0-7]+\)" if name == "dupidx"
             else r"^\s*move\s+1,0\([0-7]+\)")
        count = sum(bool(re.search(p, l, re.I)) for l in bodies.get(name, []))
        if count != 1:
            errors.append(name + ": indexed load count " + str(count))
    return errors


CHECKS.update({
    "cheap-optimizer-1-6": _legacy_cheap_six,
    "cheap-optimizer-final": _legacy_cheap_final,
})


def _trimmed(lines):
    return [line.strip() for line in lines]


def _check_duplicate_tlz(lines):
    prev = ""
    for current in _trimmed(lines):
        if re.match(r"(?i)^tlz\s+", current) and current == prev:
            return ["consecutive identical TLZ"]
        prev = current
    return []


def _check_duplicate_sign_extension(lines):
    stripped = _trimmed(lines)
    for at in range(0, len(stripped) - 5):
        first = stripped[at:at + 3]
        second = stripped[at + 3:at + 6]
        if (first == second
                and re.match(r"(?i)^(TRNE|TLNE)\s+", first[0])
                and re.match(r"(?i)^TDOA\s+", first[1])
                and re.match(r"(?i)^ANDI\s+", first[2])):
            return ["duplicate signed-extension triple"]
    return []


def _check_self_move(lines):
    for op, args in map(instruction, lines):
        if op == "MOVE":
            parts = [p.strip() for p in args.split(",")]
            if len(parts) == 2 and re.fullmatch("[0-7]+", parts[0]) and parts[0] == parts[1]:
                return ["self MOVE survived"]
    return []


def _check_zero_immediate(lines):
    return (["zero immediate arithmetic survived"] if
            _has(lines, r"^\s*(?:addi|subi|iori|xori)\s+[0-7]+,0(?:\s|$)") else [])


CHECKS.update({
    "cleanup-duplicate-tlz": _check_duplicate_tlz,
    "cleanup-sign-extension": _check_duplicate_sign_extension,
    "cleanup-self-move": _check_self_move,
    "cleanup-zero-immediate": _check_zero_immediate,
})


def _packed_internal_stream(lines):
    setms = sum(instruction(line)[0] == "SETM" for line in lines)
    ildbs = sum(instruction(line)[0] == "ILDB" for line in lines)
    errors = []
    if setms > 12:
        errors.append("packed scalar access rebuilt pointers (%d SETM)" % setms)
    if ildbs < 8:
        errors.append("streaming ILDB sequence too short (%d)" % ildbs)
    return errors


CHECKS["gnu-packed-internal-stream"] = _packed_internal_stream


def _direct_abi_pairs(lines):
    bodies = _functions(lines)
    errors = []
    for name in ("add71", "id71", "sub71", "and71", "or71",
                 "xor71", "mul71"):
        body = bodies.get(name, [])
        if _has(body, r"^\s*push\s+17,16|^\s*move\s+16,0\(17\)"):
            errors.append(name + " unnecessary AC16 spill")
    if not _has(bodies.get("add71", []), r"DIADD"):
        errors.append("add71 missing DIADD")
    for name in ("add71", "id71", "mul71"):
        if _has(bodies.get(name, []), r"movem.*-1\(17\)"):
            errors.append(name + " unexpected stack pair snapshot")
    if _has(bodies.get("add71", []), r"movei.*-.*\(17\)"):
        errors.append("add71 builds unnecessary stack address")
    for name in ("twice71", "change71", "call71"):
        if not _has(bodies.get(name, []), r"movem.*-1\(17\)"):
            errors.append(name + " missing necessary stack preservation")
    return errors


CHECKS.update({
    "dimode-direct-abi-pairs": _direct_abi_pairs,
})


def _shared_fixed_epilogue(lines):
    body = _functions(lines).get("multi_return", [])
    returns = sum(bool(re.search(r"(?i)^\s*(?:popj\s+17,|jrst\s+0\(6\))\s*$", line))
                  for line in body)
    errors = []
    if returns != 1:
        errors.append("fixed-frame function requires exactly one epilogue")
    if not _has(body, r"^\s*jrst\s+%L[0-9]+"):
        errors.append("early returns lack shared-epilogue branch")
    return errors


CHECKS["shared-fixed-epilogue-v1"] = _shared_fixed_epilogue


def _sidiv_pair(lines, names):
    bodies = _functions(lines)
    errors = []
    for name in names:
        count = sum(bool(re.match(r"^\s*(?:idiv|uidiv)i?\s+", line, re.I))
                    for line in bodies.get(name, []))
        if count != 1:
            errors.append("%s: expected 1 IDIV, got %d" % (name, count))
    return errors


def _sidiv_divmod(lines):
    return _sidiv_pair(lines, ("q_then_r", "r_then_q", "direct_index",
                               "uq_then_r", "ur_then_q"))


def _sidiv_pair_cse(lines):
    return _sidiv_pair(lines, ("q_then_r_const", "r_then_q_const",
                               "idx_qr_const", "idx_rq_const", "idx_rq_var"))


def _sidiv_shared(lines, machine):
    helpers = sum(line.startswith("%SIDH") for line in lines)
    calls = sum(bool(re.search(r"PUSHJ.*%SIDH", line, re.I)) for line in lines)
    if machine == "pdp6":
        errors = []
        if helpers < 6:
            errors.append("PDP-6: fewer than six shared signed-IDIV helpers")
        if calls < 10:
            errors.append("PDP-6: fewer than ten signed helper call sites")
        if any(line.startswith("%SIDN") for line in lines):
            errors.append("PDP-6: obsolete per-site signed-IDIV body")
        return errors
    return (["PDP-6 signed-IDIV helper on " + machine]
            if helpers else [])


def _terminal_commutative(lines):
    bodies = _functions(lines)
    errors = []
    ops = (("add_ab", "add"), ("add_ba", "add"),
           ("and_ba", "and"), ("or_ba", "ior"), ("xor_ba", "xor"),
           ("mul_ab", "imul"), ("mul_ba", "imul"))
    for name, op in ops:
        body = bodies.get(name, [])
        if not _has(body, r"^\s*" + op + r"\s+1,2(?:\s|$)"):
            errors.append(name + ": missing direct AC1 " + op)
        if _has(body, r"^\s*move\s+[3-7],[12](?:\s|$)"):
            errors.append(name + ": retained commutative temporary")
    for name in ("sub_ba", "usub_ba"):
        for pat in (r"^\s*movn\s+1,1(?:\s|$)",
                    r"^\s*add\s+1,2(?:\s|$)"):
            if not _has(bodies.get(name, []), pat):
                errors.append(name + ": missing direct AC1 operation " + pat)
    return errors


def _subbp_index(lines):
    return (["linear SUBBP position search survived"] if
            _has(lines, r"^\s*CAIN\s+15,") else [])


CHECKS.update({
    "sidiv-divmod-cse-v2": _sidiv_divmod,
    "sidiv-idiv-pair-cse-v3": _sidiv_pair_cse,
    "terminal-commutative-ac1-v1": _terminal_commutative,
    "subbp-index-arithmetic-v1": _subbp_index,
})


_MACHINE_CHECKS = {"direct-assignment-store", "cheap-optimizer-pass",
                   "sidiv-shared-edge-v1"}
CHECKS["sidiv-shared-edge-v1"] = _sidiv_shared
