"""Executable checks for declarative compiler matrix codegen policies.

These assertions apply to assembled compiler output, not to source comments
or declarations.  Unsupported policy forms are errors, never no-op checks.
"""

import re


FORMS = frozenset(('POP_AC_AC', 'JFCL1', 'SET_MEMREF',
                   'SETZ_MEMREF', 'SETO_MEMREF'))
IDENTIFIER = re.compile(r'^[A-Za-z_][A-Za-z_0-9]*$')
SYMBOL = re.compile(r'^[A-Za-z_.$%][A-Za-z_0-9.$%]*$')
OPCODE = re.compile(r'^([A-Za-z][A-Za-z0-9]*)\s+(.+)$')
LABEL = re.compile(r'^[A-Za-z_.$%][A-Za-z0-9_.$%]*:\s*')
TOKEN_CHARS = r'[A-Za-z0-9_.$%]'


def instructions(asm_text):
    """Yield only opcode lines and their operands (no comments or labels)."""
    for raw in asm_text.splitlines():
        line = raw.split(';', 1)[0].split('!', 1)[0].strip()
        while True:
            match = LABEL.match(line)
            if match is None:
                break
            line = line[match.end():].lstrip()
        if not line or line.startswith('.'):
            continue
        match = OPCODE.match(line)
        if match:
            yield match.group(1).upper(), match.group(2).strip()


def ac_number(operand):
    """Return the architectural AC number for a bare octal operand."""
    operand = operand.strip()
    if not re.fullmatch(r'[0-7]+', operand):
        return None
    value = int(operand, 8)
    return value if value <= 0o17 else None


def form_failures(asm_text, forbidden):
    """Check forms without falsely flagging the valid POP 17,6 idiom."""
    failures = []
    for form in forbidden:
        if form not in FORMS:
            failures.append('unknown forbidden instruction form: ' + form)
    for op, args in instructions(asm_text):
        pair = [x.strip() for x in args.split(',', 1)]
        first = ac_number(pair[0])
        second = ac_number(pair[1]) if len(pair) == 2 else None
        if ('POP_AC_AC' in forbidden and op == 'POP' and
                first is not None and first == second):
            failures.append('forbidden POP into its own stack AC: ' + args)
        if 'JFCL1' in forbidden and op == 'JFCL' and first == 1:
            failures.append('forbidden JFCL 1 form: ' + args)
        form = op + '_MEMREF'
        if (form in forbidden and op in ('SET', 'SETZ', 'SETO') and
                len(pair) == 2 and pair[1] and second is None):
            failures.append('forbidden ' + form + ': ' + args)
    return failures


def required_symbol_failures(asm_text, symbols):
    """Require references in instructions, not .globl declarations alone."""
    used = '\n'.join(args for _opcode, args in instructions(asm_text))
    failures = []
    for symbol in symbols:
        if not SYMBOL.fullmatch(symbol):
            failures.append('invalid required symbol: ' + symbol)
        elif not re.search(r'(?<!' + TOKEN_CHARS + ')' +
                           re.escape(symbol) + r'(?!' + TOKEN_CHARS + ')',
                           used):
            failures.append('missing referenced symbol: ' + symbol)
    return failures


def macro_probe_source(required, forbidden):
    """Generate a tiny C preprocessing oracle for the selected target."""
    failures = []
    for macro in list(required) + list(forbidden):
        if not IDENTIFIER.fullmatch(macro):
            failures.append('invalid macro name: ' + macro)
    for macro in set(required) & set(forbidden):
        failures.append('macro both required and forbidden: ' + macro)
    if failures:
        return '', failures
    lines = []
    for macro in required:
        lines.extend(('#ifndef ' + macro, '#error missing required macro ' +
                      macro, '#endif'))
    for macro in forbidden:
        lines.extend(('#ifdef ' + macro, '#error forbidden macro defined ' +
                      macro, '#endif'))
    lines.append('int codegen_macro_probe_v1;')
    return '\n'.join(lines) + '\n', []
