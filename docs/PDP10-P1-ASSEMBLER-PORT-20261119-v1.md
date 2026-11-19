# KL10 original assembly fixture DAS syntax port v1

The original `tests/semantic/upstream/support/920428-1.s` uses a legacy
assembler dialect. Its initial failure was not proof that DAS lacked
KL10 instruction support. A separate syntax translation is provided at
`tests/isa/das-port/920428-1-das-v1.s`; the upstream file is unchanged.

The port replaces `BYTE (9)0` with `.BYTE 9,0`, legacy PSECT/ENDPS
forms with DAS sections, removes `.DIRECTIVE KL10` (not a DAS source
switch), and uses native `OWGBP`/`GIW` rather than the original DEFINE
macros. The octal selector is written `070` because DAS defaults to
decimal. The legacy external `..main` cannot be expressed with DAS's
current symbol parser and is **renamed `MAIN_INIT` in the port**.
This rename does not establish a compatible runtime symbol definition.

Run `python3 tools/test-920428-das-port-v1.py` to validate the frozen
original source hash and assemble the port using installed DAS `-C`.
The resulting DOBJ is an **assembly-only success**. It is not linked,
executed on KL10, or registered as a semantic pass in the C test matrix.
The byte-pointer behavior and external entry linkage require separate
validation before promoting the fixture to a runtime test.
