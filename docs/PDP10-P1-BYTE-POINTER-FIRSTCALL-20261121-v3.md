# PDP-6 KCC direct-ABI argument liveness repair (2026-11-21, v3)

## New native compiler correction

KCC commit `551f406` fixes a third independent byte-pointer compiler
defect in `ccdecl.c:promote_abi_params()`. Its direct-ABI first-call
drop optimization could keep a parameter in a physically call-
volatile incoming accumulator even when the completed function
body referenced that parameter after a nested call. The subsequent
9-bit pointer equality read the overwritten accumulator rather than
the original pointer. The result was a genuine native KCC noopt
`run_fail` at decimal ID **10**. SIMH prints that as **octal 012**.

An independent after-byte/halfword C89 source establishes the exact
sequence: a 9-bit pointer through an indirect identity call,
followed by an 18-bit pointer through the same three-argument check.
Before repair, KCC noopt aborted at ID 10 **during the first
9-bit check**; its second halfword checker was never called.
Instrumented real PDP-6 generated assembly saved its comparison
operands just before the failing `CAME`:

| Operand | Native octal word |
| --- | --- |
| Returned actual 9-bit pointer | `001100002503` |
| Stale incoming AC1 / temporary stack address | `000000001511` |

The second word is not a canonical S=9 pointer. The owning direct-
ABI parameter analysis now requires **exactly one completed-tree
reference** before applying the dead-at-first-call fast path.
If the parameter is used more than once, it uses the established
preserved-accumulator binding across the call. The optimization
remains active for proven single-use parameters. The correction
adds no permanent RAM, heap, OS service, new ABI or runtime helper.

The two prior KCC owning fixes remain installed and verified:
`46d0181` (`void *` S-field preservation) and `4a61c53`
(canonical comparison register liveness). The corrected installed
KCC executable SHA256 is
`fbe85b127e2004fac0538b338101a5bca9b155bdf7aad3cd06d0917671ba538b`.
The earlier v2 and v1 KCC executable versions and raw native test
outcomes remain independently archived, rather than relabeled.

## Native PDP-6 six-profile results

| Versioned C89 source | KCC noopt | KCC opt | GCC O0/O1/O2/Os |
| --- | --- | --- | --- |
| `pdp10-void-pointer-roundtrip-locator-v1.c` | PASS | PASS | Four PASS |
| `pdp10-halfptr-multiarg-identity-v1.c` | PASS | PASS | Four PASS |
| `pdp10-halfptr-plain-multiarg-v1.c` (9-bit then 18-bit call) | PASS | PASS | Four PASS |
| **`pdp10-byte-pointer-torture-v1.c` (full active replacement)** | **PASS** | **PASS** | Four real `run_fail` |

This is **20 actual PDP-6 guest PASS and four genuine GCC
run_fail** across 24 complete source/profile cells. The GCC
failures remain O0 decimal ID 21 and O1/O2/Os decimal ID 28;
neither is corrected or hidden by the KCC work.

The three existing KCC/GCC KS10 direct, stack and deep-calling-
convention ABI regressions all PASS with the corrected installed
compiler; all earlier 71-bit C89 conversion evidence remains
valid. The prior v2 pointer evidence remains authentic: its
KCC noopt fail was **decimal 10, not decimal 12**; the v2
manifest records the octal value `12`, which is correct.

## Source-pinned guest evidence

`PDP10-P1-BYTE-POINTER-FIRSTCALL-EVIDENCE-20261121-v3.tsv`
records all 24 source/profile statuses, pinned C89 source digests,
the installed KCC/GCC toolchain SHA256 identities, and real
compiler-owned libc provenance. The archive
`refs/p10tk-p1-byte-pointer-firstcall-20261121-v3.tar.gz`
contains **120 raw executed guest outputs** (status, compiler
log, generated assembly, linker map, native SIMH report).
Archive SHA256:
`7c3e0b3e275e3f88420ec5e9e3dbb882ee10249fd09cbd76594f6e2250e8fa6f`.

`tools/test-p1-byte-pointer-firstcall-v3.py` rejects seven
status/source/compiler/raw-artifact mutations and works offline
against the committed manifest and archive. `--write` can
reconstruct the archive from four versioned native guest result
directories; the historical v1/v2 archives are not overwritten.

## Historical P1 stop point

The imported historical `old.tort.c` was deleted from the current
compiler matrix; `pdp10-byte-pointer-torture-v1.c` is its full
freestanding C89 replacement. **Both native KCC profiles now
PASS that replacement**, but four GCC profiles still fail.
Do not classify the entire historical source as closed.

The current P1 source ledger remains **56 covered / 11 blocked**;
the frozen 59-source batch ledger remains **48 covered / 11 blocked**.
The full CPU/compiler/optimization sweep remains blocked until
all eleven remaining P1 source-construction obligations close.
