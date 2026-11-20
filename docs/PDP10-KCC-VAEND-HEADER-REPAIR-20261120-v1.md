# Installed KCC va_end argument-side-effect repair (v1)

Date: 2026-11-20. Scope: native PDP-6 KCC target header and focused
compiler testkit evidence. The large compiler/CPU/optimization sweep
remains explicitly deferred. No DAIMOS OS libc or hosted substitutes
were used.

## Root cause and owning fix

The historical upstream `va-arg-21.c` tests a real side effect in
the `va_end(**ap_ptr++)` argument. The independent C89 companion
`tests/semantic/regression/pdp10-vaend-pointer-sideeffect-v1.c`
previously exposed this failure under installed KCC noopt/opt on
native PDP-6: both reached SIMH HALT with `run_fail`, `fail_id=4`.
All four GCC O0/O1/O2/Os profiles passed.

The *old* installed KCC `stdarg.h`, SHA256
`99d3e321cd11dc44db2545be9c5b12f0336dcb12e002b0b504904a7e3723de42`,
had `#define va_end(ap) ((void)0)`. No argument evaluation means
the `ap_ptr++` side effect is dropped. The actual KCC PDP-10 ABI
needs no `va_list` cleanup, but the macro argument still must be
evaluated exactly once.

**Owning repository:** `kcc`, commit
`5fa3510` (`kcc: evaluate va_end arguments once in PDP-10 stdarg
header v1`). The corrected `self/include/stdarg.h` defines:

```c
#define va_end(ap) ((void)(ap))
```

This fixes the semantics without adding runtime cleanup, allocation,
formatting, new compiler-side buffers or a testkit workaround.
`#include_next <stdarg.h>` still delegates correctly to GCC's
own variadic builtins.

The exact corrected source header was installed with the KCC
`install-headers` target into
`$PDP10_PREFIX/lib/kcc/include/stdarg.h`. The installed header and
the KCC source are byte-identical; both SHA256
`f966aa2588b7d59dbf2bf704ffd87fb67097673455ee77fe86d8a75232f23e7f`.
No KCC executable, assembler, linker or library replacement was
necessary for this header-only correction.

## Actual native regression results after installation

The normal testkit runner used the *installed* header with
`KCC_INCLUDE_DIR` unset. Its compiler C library remains
`libp10c-v2.a`, SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.

| Native PDP-6 profile | Before repair: va_end test | After repair: va_end test |
| --- | --- | --- |
| KCC noopt | `run_fail` ID 4 | **PASS** |
| KCC opt | `run_fail` ID 4 | **PASS** |
| GCC O0 | PASS | PASS |
| GCC O1 | PASS | PASS |
| GCC O2 | PASS | PASS |
| GCC Os | PASS | PASS |

Both KCC noopt and opt were also run against the separate,
pre-existing `pdp10-variadic-return-types-v1.c` regression; both
**PASS**. All eight post-repair PDP-6 reports show an actual SIMH
HALT, `__test_exit=0` and `fail_id=0`. These are not compile-only
checks, and no failing historical result has been replaced.

## Pinned evidence and boundaries

`docs/PDP10-KCC-VAEND-REPAIR-EVIDENCE-20261120-v1.tsv`
identifies eight real post-fix compiler/source/profile outcomes,
each with individual SHA256s for actual compiler logs, status,
assembly, link map and simulator report. The versioned
`refs/p10tk-kcc-vaend-repair-20261120-v1.tar.gz` contains 41 raw
members (40 per-guest artifacts and one exact corrected installed
KCC `stdarg.h` snapshot). Archive SHA256:
`740dd285ddf97780dd55aaff1268c0f01424d4b90561d1822d048c2cf5249008`.

`tools/test-kcc-vaend-repair-v1.py` authenticates source and matrix
identity, correct installed KCC header fingerprint, unchanged
compiler-library selection, actual PDP-6 guest PASS/exit/assertion
values, linker-map symbols and every raw artifact hash. Ten
fail-closed mutation controls detect fabricated or altered results.
The *historical* baseline validator
`tools/test-p1-vaarg21-vaend-v1.py` still verifies both original
missing-hosted-service failures and both pre-repair KCC `run_fail`
results with the **old** header snapshot. It is not rewritten to
pretend the earlier failures did not occur.

This repair does **not** make the unchanged upstream original run:
the compiler-only runtime still lacks the required hosted `malloc`
and `vprintf` services. No other CPU variant or complete variadic
ABI/hosted-formatting behavior is claimed validated. P1 construction
remains at **54 covered / 13 blocked** (the fixed 59-source batch
positions remain **46 covered / 13 blocked**). The v26 live ledger
updates only the KCC repair follow-up; the original batch 6, slot 9
and original source content are unchanged.

Focused reproduction with the corrected installed header:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
env -u KCC_INCLUDE_DIR ./run-tests.sh \
  --out-dir "$TMPDIR/p10tk-vaend-installed-fixed-20261120-v1" \
  --source tests/semantic/regression/pdp10-vaend-pointer-sideeffect-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
env -u KCC_INCLUDE_DIR ./run-tests.sh \
  --out-dir "$TMPDIR/p10tk-vaarg-abi-installed-fixed-20261120-v1" \
  --source tests/semantic/regression/pdp10-variadic-return-types-v1.c \
  --compiler kcc --family native --cpu pdp6 --opt noopt,opt -j 2
python3 tools/test-kcc-vaend-repair-v1.py
python3 tools/build-p1-semantic-resolution-v26.py
python3 tools/audit-p1-source-batches-v25.py
```
