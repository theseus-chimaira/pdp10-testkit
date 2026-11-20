# P1 Batch 4: stdarg, VLA and hosted formatting prerequisites (v1)

Date: 2026-11-20. Targeted installed-toolchain probe of the **three
unchanged original** P1 Batch 4 variadic sources (slots 5, 6 and 7),
only on KCC PDP-6 native noopt and GCC PDP-6 native O0. No compiler
source, installed target library, original assertion or matrix policy
was modified. This is not a full sweep.

## Verified stage outcomes

| Source | KCC noopt | GCC O0 |
| --- | --- | --- |
| `20020412-1.c` | `compile_fail` | `run_fail` |
| `920501-8.c` | `timeout` | `compile_fail` |
| `920726-1.c` | `pass` | `compile_fail` |

The snapshot `docs/PDP10-P1-BATCH4-VARIADIC-CONTRACT-20261120-v1.tsv`
pins the full original source names, SHA256s, compiler profiles, actual
stages and narrow failure diagnoses. Earlier historical manifests remain
unaltered. In particular, older KCC `link_fail` observations for the
formatting cases must not override current installed-toolchain evidence.

### Variable-sized `va_arg`: `20020412-1.c`

KCC rejects variable-size anonymous structure constructs (the compiler
reports flexible array members and four errors). This is a source/
language/target capability failure, not proof of a missing stdarg header.
GCC compiles and links the unchanged original using installed
`stdarg.h` and the real freestanding `memcpy` member; its PDP-6 guest
HALTs with nonzero `__test_exit`. The original checks ten sequential
digits. The GCC variadic-aggregate ABI/copy behavior remains a distinct
compiler issue; no synthetic fallback or narrowed assertion is allowed.

### Many variadic arguments with `printf`/`sprintf`: `920501-8.c`

KCC currently links the program including its real formatting calls,
but SIMH's wall-clock timeout prevents any readable guest exit. The
`p10run` report has `rc=124` and `result=FAIL`, and no HALT. The
semantic runner previously used `run_fail` because `p10run` itself
returned 1. Its corrected report-aware classification is **`timeout`**.
This is not a completed failing guest assertion and does not demonstrate
variadic correctness or incorrectness.

GCC instead stops at preprocessing with `stdio.h: No such file or
directory`. This is an installed **target-header** prerequisite; it
must not be relabeled as a confirmed linker error or guest ABI failure.

### Integer varargs with a structure-returning function: `920726-1.c`

KCC compiles, links, executes and reaches `__test_exit=0`. The linker
map contains actual resolved `sprintf`, `strlen` and `strcmp`
symbols. Thus this observed KCC profile has genuine usable formatting
linkage for the tested small integer format, despite the separate
freestanding `libp10c-v2.a` intentionally not supplying hosted stdio.
Do not claim that hosted formatting is universally absent. The test
compares two resulting strings (`5 20 `) but **does not inspect the
structure returned by `second`**; its PASS is not a full
structure-return ABI proof.

GCC again stops at the missing target `stdio.h` header. Neither an
arbitrary host header nor a fabricated `sprintf` is a valid remedy.

## Verification and reproduction

The installed GCC `stdarg.h` and KCC `stdarg.h` are present, as are
KCC's `stdio.h` declarations. The current GCC target include search
does not provide `stdio.h`. These are distinct header contracts.

Run the six cells without activating any additional matrix profile:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/probe-deferred-libc-v1.py \
  --source tests/todo/generic/20020412-1.c \
  --source tests/todo/generic/920501-8.c \
  --source tests/todo/generic/920726-1.c \
  --compiler all \
  --outdir "$TMPDIR/p10tk-p1-batch4-varargs-confirmed-20261120-v1"
python3 tools/audit-p1-batch4-variadic-contract-v1.py \
  --results "$TMPDIR/p10tk-p1-batch4-varargs-confirmed-20261120-v1/results-v1.tsv"
```

The optional evidence audit verifies exact source/compiler/profile
identities, original source hashes, installed target-header availability,
compiler diagnostics, SIMH `rc=124` timeout, HALT and guest assertion
values, and KCC's resolved formatting symbols. The host-only test
`tools/test-p1-batch4-variadic-contract-v1.py` rejects seven mutated
policies, including false guest failure in place of timeout, suppression
of an observed PASS, missing source provenance, and premature P1 closure.

All three original obligations stay **blocked** in P1 semantic
resolution v8. They cannot be closed by a single KCC success or an
earlier GCC compile-only no-ICE check. Compiler repairs remain outside
the current testkit scope.
