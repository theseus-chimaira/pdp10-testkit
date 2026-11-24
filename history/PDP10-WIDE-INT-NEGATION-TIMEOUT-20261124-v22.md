# PDP-10 wide-integer negation timeout recovery v22

Date: 2026-11-24

## Scope and baseline

The existing upstream regression
`tests/semantic/upstream/wide-int/950612-1.c` contained 36 GCC
`timeout` checkpoints and 30 KCC PASS checkpoints. Its four helper
functions test absolute values of signed/unsigned 36-bit and
extended `long long` operands over zero and small positive/negative
inputs. Every GCC target configuration had timed out in the earlier
partial sweep.

## Reproducing and reducing the failure

An isolated KI10 O2 retry with doubled guest instruction budget
**200,000,000** still expired at PC 0. It was not a simple
under-provisioned timeout. Dividing the source into independent
f1/f2/f3/f4 calls established that 36-bit f1/f2 passed, while the
extended integer f3/f4 entered the erroneous PC 0 path.

The GCC machine description emitted a zero-low-word test using
`JUMPE low,[AOJA high,.+2]`. The bracketed instruction is placed in
the assembler's literal pool, so the relative branch is no longer
relative to the original negation sequence. A zero low word could
branch into uninitialized memory.

An initial scratch replacement with an inline `AOJA` eliminated the
loop but demonstrated that the zero-low-word increment must have
correct skip polarity. The final direct local idiom is:

```
setca high,
skipn low,low
addi high,1
movn low,low
```

This complements and conditionally increments the high word when the
low word is zero, preserving proper two-word negation. The backend's
71-bit variant retains its low-word sign-bit normalization and the
non-71-bit variants use the corresponding arithmetic sequence. No
extra temporary accumulator or library routine is required. All
machine-description length attributes reflect the expanded
instructions. Source: `gcc-pdp10/gcc/config/pdp10/pdp10.md`.

## Acceptance

The staged patched compiler passed the full original source at O2
on PDP-6, KA10, KI10 and KS10. After rebuilding and installing GCC
in `$HOME/cross`, the official testkit runner selected five sources:

- `950612-1.c` (all compiler/CPU/optimization profiles)
- `20000822-1.c` (the v21 nested-function trampoline test)
- `920428-1.c` (the v21 defined upstream pointer oracle)
- `pdp10-short16-reverse-adjust-v20.c`
- `pdp10-indexed-byte-pointer-v19.c`

The fresh, isolated `workdir/pdp10-timeout-triage-v22-final`
checkpoint passed **284/284 cells**, including **204 GCC** and
**80 KCC** cells, under strict exit policy. There were no skipped
old successes and no remaining timeouts among the selected cells.
The original **36 wide-integer GCC timeouts** are therefore verified
repaired, not merely reclassified.

## Overall timeout progress

The earlier baseline had 135 timeout records across seven test
sources. v20 fixed 16 byte-pointer timeouts; v21 corrected one
undefined upstream oracle and fixed 33 GCC nested-function
trampoline timeouts. The additional 36 GCC wide-integer repairs in
v22 bring the total to **86/135 repaired or invalidated**.

The **49 remaining baseline timeouts** are from the GCC packed
aggregate by-value test (27) and two KCC optimizer tests (11 each).
These remain open. The original global sweep checkpoints were not
overwritten by these focused verified reruns.
