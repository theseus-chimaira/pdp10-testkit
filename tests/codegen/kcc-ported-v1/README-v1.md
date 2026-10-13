# KCC-specific code generation regressions

Sources in this directory replace shell-only assembly-pattern checks.
Patterns are expressed as `codegen-require-regex` and
`codegen-forbid-regex` directives consumed by `run-tests.sh`.

- `aoja-fold-v1.c`: requires AOJA loop-folding and prohibits the
  redundant ADDI/JRST pair.
- `bitwise-literal-v1.c`: requires immediate IORI, ANDI, XORI and
  high-half TLO forms, and prohibits intermediate MOVEI literal loads.

The original shells ran KCC optimized on PDP-6. Matching matrix cells
were verified PASS using the installed compiler. They are deliberately
KCC-only because the instruction shape is compiler-specific; the C
semantics themselves are not asserted by these compile-only tests.
