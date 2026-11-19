# KL10 original assembly fixture DAS syntax port v1

The original `tests/semantic/upstream/support/920428-1.s` uses a legacy
assembler dialect. Its initial failure was not proof that DAS lacked
KL10 instruction support. A separate syntax translation is provided at
`tests/isa/das-port/920428-1-das-v1.s`; the upstream file is unchanged.

The port replaces `BYTE (9)0` with `.BYTE 9,0`, legacy PSECT/ENDPS
forms with DAS sections, removes `.DIRECTIVE KL10` (not a DAS source
switch), and uses native `OWGBP`/`GIW` rather than the original DEFINE
macros. The octal selector is written `070` because DAS defaults to
decimal. The legacy external `..main` is translated to `__main`, the current
GCC PDP-10 runtime hook (`NAME__MAIN` in `gcc/config/pdp10/pdp10.h`).
The target libgcc runtime supplies this hook; the fixture does not
fabricate a local implementation. This resolves the symbol naming
mismatch, but full runtime linking remains unverified.

Run `python3 tools/test-920428-das-port-v1.py` to validate the frozen
original source hash and assemble the port using installed DAS `-C`.
The resulting DOBJ is an **assembly-only success**. It is not linked,
executed on KL10, or registered as a semantic pass in the C test matrix.
The byte-pointer behavior and external entry linkage require separate
validation before promoting the fixture to a runtime test.

The syntax-port assembler regression is registered in `SPECIAL_TESTS.tsv`
as `das-check-920428-port-v1` (fast DAS suite). The test also asserts
that `main` is a defined `.text` symbol and `__main` is a genuine
undefined runtime import in the DOBJ symbol table. No stub is linked.
