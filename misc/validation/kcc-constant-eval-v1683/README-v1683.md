# Native KPARSE constant-expression correctness preflight v1683

This is a **compiler C89 regression**, not a DAIMOS kernel test. It
compiles ordinary `IDENTWDS`-like enum constants, octal arithmetic,
conditional typedef extents, small array dimensions, target bit shifts,
and a signed 36-bit boundary value using both KCC `-O` and `-n`.
The parser must not invent a constant-expression overflow. All
compile successes require actual emitted PDP-6 assembly and the
original PDP-6 simulator must execute the resulting C `main()` to
`__test_exit=0`. The runtime oracle checks exact 311-word combined
array extents and 397 scalar arithmetic, not only compiler diagnostics.

Run `KCC_BIN=/path/to/kcc sh run-v1683.sh`. With KCC_BIN unset,
the installed cross compiler under `PDP10_PREFIX/bin/kcc` is used.

This test does **not yet** execute native KPARSE, whose source-built
KPT4/KIR1 phase image and original failure fixture are still needed.
The currently installed host KCC and repository-built host KCC both
accept the isolated valid test. That outcome does not close DAIMOS
TODO P0 (native KPARSE CHKOVF/JFCL overflow). A separate signed
out-of-range enum diagnostic is under investigation and is not silently
used as a negative acceptance gate because unsuffixed C89 target integer
literal conversion and enums require a source-linked type audit first.
