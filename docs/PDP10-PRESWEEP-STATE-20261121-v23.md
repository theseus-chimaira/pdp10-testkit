# PDP-10 testkit current pre-sweep gate (v23)

Date: 2026-11-21. Supersedes v22 as the live gate. All earlier
versioned source-pinned raw guest archives remain immutable.

| Live metric | Measured |
| --- | ---: |
| Compiler-matrix sources | 2,320 |
| Special test registrations | 406 |
| Owned scripts | 579 |
| Unowned source files or unconnected scripts | 0 |
| P1 original identities covered / blocked | **56 / 11** |
| Frozen 59-source batch positions covered / blocked | **48 / 11** |

The active P1 ledgers remain
`PDP10-P1-SEMANTIC-RESOLUTION-20261121-v29.tsv` and
`PDP10-P1-SOURCE-BATCHES-20261121-v28.tsv`. The completed
historical GNU `conversion.c` source remains fully verified with
six actual KCC/GCC PDP-6 original native guest PASS. The current
KCC and GCC toolchains use real compiler-owned freestanding libc,
not a DAIMOS kernel or test-local substitute.

## Completed PDP-6 KCC pointer ABI repair sequence

Three distinct owning KCC bugs were corrected and pushed:

- `46d0181`: `void *`-to-`void *` must preserve the original
  byte-pointer S field, including native 18-bit width
- `4a61c53`: S=1 canonical equality must not lose the first
  operand when the second operand requires scratch registers
- `551f406`: direct-ABI first-call optimization may not retain
  an incoming call-volatile register parameter beyond a call
  when the completed function body contains multiple uses

All three independent 9/18/36-bit C89 pointer regressions pass
KCC noopt/opt and GCC O0/O1/O2/Os. Crucially, the larger existing
`pdp10-byte-pointer-torture-v1.c` **now passes both KCC profiles**.
All four GCC profiles still genuinely fail on that larger source:
GCC O0 decimal ID 21, GCC O1/O2/Os decimal ID 28.

The current evidence package
`PDP10-P1-BYTE-POINTER-FIRSTCALL-20261121-v3.md` pins 24
actual native PDP-6 source/profile outcomes: **20 PASS, four
run_fail, 120 raw artifacts and seven mutation controls**.
The installed corrected KCC SHA256 is
`fbe85b127e2004fac0538b338101a5bca9b155bdf7aad3cd06d0917671ba538b`.

**Important diagnostic correction:** SIMH prints PDP-10 memory
words in **octal**. In the historical v1/v2 failing KCC noopt
pointer guest, `000000000012` means **decimal ID 10**, not 12.
The authentic runtime failure happened in the first S=9 byte
pointer check, before the halfword checker was called. The
previous raw archives are correct and were not changed; only
the mistaken written decimal interpretation was corrected.

The historical `old.tort.c` source was removed in favor of the
full freestanding C89 replacement. KCC replacement success does
not close the whole historical P1 original while GCC remains
failing; leave that original classified **blocked**.

## KL10 original remains blocked

The unchanged MACRO-10 `920428-1.s` still needs a proper
expression-valued `DEFINE` expansion with nested `OWGBP`/`GIW`,
real `%ONE` external linkage and correct native KL10 termination.
The previously verified DAS BYTE/DOBJ relocation, phase-pair
and simulator timeout reporting are prerequisites, not an
original-source PASS. The DAS repository has local `aa74f42`
that could not be pushed without GitHub credentials. There is
no claim that the KL10 original executes correctly.

## Stop point

The original P1 ledger stays at **56 covered / 11 blocked** and
frozen source batches at **48 / 11**. All other outstanding
hosted-runtime, assembler and GCC compiler source obligations
remain open as enumerated in the live v29 P1 ledger. The full
compiler/CPU/optimization sweep must not begin until all eleven
are constructed and properly authenticated. Never turn a real
SIMH timeout, runtime abort or missing ABI helper into a PASS.
