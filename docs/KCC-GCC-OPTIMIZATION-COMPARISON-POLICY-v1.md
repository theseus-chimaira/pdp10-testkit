# KCC/GCC optimization-comparison policy

Runtime equivalence and optimization equivalence are separate properties.

A test may validly demonstrate that KCC and GCC produce the same observable
result while still being unsuitable for a direct code-size or performance
comparison.  This occurs when the common test source reaches the compilers
through compatibility constructs whose lowering is intentionally different.

Examples include:

- `OPAQUE_REG`: KCC uses a source-level no-op while GCC may use an inline-asm
  register barrier.
- `likely` / `unlikely`: KCC ignores the hint while GCC maps it to
  `__builtin_expect`.
- `__builtin_abs`, `__builtin_ffs`, and the PDP-10 JFFO builtin: KCC may use a
  source expression or helper call while GCC may lower a target builtin.
- `__builtin_memcpy` / `__builtin_memset`: KCC may call the compatibility
  library routine while GCC may inline or recognize the operation.
- `__builtin_alloca`: KCC uses its compatibility helper while GCC has native
  stack-allocation lowering.
- `__builtin_va_*`: the two front ends implement their native varargs
  mechanisms differently.

`OPTIMIZATION_RESULT_ONLY.tsv` lists shared KCC/GCC matrix sources containing
these constructs.  They remain valid for semantic, runtime, ABI, ISA, and
code-generation correctness testing, but their generated size or execution
cost must not be compared directly between KCC and GCC.

A source becomes eligible for a direct optimization comparison only when the
operation being measured is expressed through an equivalent source/interface
for both compilers.  Creating such a normalized comparison source must not
replace or weaken the original correctness regression.

`tools/verify-optimization-common-source.py` enforces both sides of the rule:
compiler-conditioned semantic-only sources must be classified, and shared
sources using known differential compatibility constructs must be present in
`OPTIMIZATION_RESULT_ONLY.tsv`.
