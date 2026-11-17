#!/usr/bin/env python3
"""Fail-closed GCC 3.2 negative-diagnostic classification checks."""

from compiler_negative_policy_v1 import check_gcc_rejection


def main():
    # GCC 3.2 does not consistently prefix genuine compiler diagnostics
    # with `error:`. Both modern and historical source-located forms count.
    normal = 'tests/negative/a.c:7: syntax error before "foo"\n'
    old = 'tests/negative/a.c:1: storage size of `a\' isn\'t known\n'
    asm = 'tests/negative/a.c:3: unknown register name `bad\' in `asm\'\n'
    cases = (
        ('old GCC syntax', 1, normal, True),
        ('old GCC type error', 1, old, True),
        ('old GCC assembler error', 1, asm, True),
        ('newer GCC syntax', 1, 'a.c:3:4: error: invalid syntax\n', True),
        ('real GCC 3.2 type error', 1,
         'tests/negative/a.c:1: elements of array `bar\' have incomplete type\n', True),
        ('real GCC 3.2 operand error', 1,
         'a.c: In function `rof\':\na.c:4: invalid operands to binary !=\n', True),
        ('real GCC 3.2 identifier error', 1,
         'a.c:8: `baz\' undeclared (first use in this function)\n', True),
        ('old GCC header source error', 1,
         'include/bad.h:12: syntax error before `void\'\n', True),
        ('no source diagnostic', 1, 'compilation terminated\n', False),
        ('blank diagnostics', 1, '', False),
        ('missing input file', 1, 'gcc: a.c: No such file or directory\n', False),
        ('missing header with source location', 1,
         'a.c:1: missing.h: No such file or directory\n', False),
        ('unsupported driver option', 1,
         'gcc: unrecognized command-line option -bad\n', False),
        ('missing cc1 executable', 1,
         'a.c:2: syntax error\ngcc: cannot find cc1\n', False),
        ('missing assembler executable', 1,
         'a.c:2: syntax error\ngcc: cannot execute as\n', False),
        ('permission denied', 1,
         'a.c:2: syntax error\ngcc: Permission denied\n', False),
        ('warning only', 1, 'a.c:7: warning: missing initializer\n', False),
        ('warning upper case', 1, 'a.c:7: WARNING: bad type\n', False),
        ('note only', 1, 'a.c:7: note: declared here\n', False),
        ('remark only', 1, 'a.c:7: remark: expanded from here\n', False),
        ('context only', 1, 'a.c: In function `f\':\n', False),
        ('unexpected successful compile', 0, normal, False),
        ('signal termination', -11, normal, False),
        ('compiler exit 125', 125, normal, False),
        ('compiler exit 126', 126, normal, False),
        ('shell signal exit', 139, normal, False),
        ('timeout exit', 124, normal, False),
        ('missing compiler exit', 127, normal, False),
        ('ICE with ordinary error', 1,
         normal + 'internal compiler error in expand_expr\n', False),
        ('segfault with ordinary error', 1,
         normal + 'Segmentation fault\n', False),
        ('assertion with ordinary error', 1,
         normal + 'assertion xyz failed\n', False),
    )
    for description, status, log, expected in cases:
        actual = check_gcc_rejection(status, log) is None
        if actual != expected:
            raise AssertionError('bad classification: ' + description)
    print('GCC negative rejection policy: PASS (%d synthetic cases)' %
          len(cases))


if __name__ == '__main__':
    main()
