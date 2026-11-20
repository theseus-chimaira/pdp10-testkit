# P1 native matrix admission from live resolution v9 (2026-11-20, v1)

The unresolved P1 ledger has **29 obligations**: **28 C tests** and
one KL10-only assembly fixture. All 28 C sources already had a normal
compiler matrix owner and at least PDP-6 KCC opt/noopt and GCC O0
selected. This change does not register any duplicate compiler source.
It expands **162 previously disabled native profile columns** among
24 of those tests. A KCC CPU column selects two compiler modes, so
those additions correspond to **192 new runnable cells**.

After admission there are **297 native CPU/compiler/optimization
cells** among the 28 unresolved C obligations. These are *scheduled*
cells, not 297 completed executions or passing tests. Other unrelated
matrix sources retain their exact selections. No full sweep occurred.

## Source-pinned admission policy

Every row of
`docs/PDP10-P1-MATRIX-ADMISSION-20261120-v1.tsv` retains a historical
source identity, current matrix owner, current SHA256, unresolved P1
state and reviewed admission tier:

| Tier | Sources | New profile columns | Scope |
| --- | ---: | ---: | --- |
| `dual-native` | 6 | 108 | PDP-6 GCC O1/O2/Os; KA10/KI10/KS10 KCC and GCC native |
| `kcc-native` | 4 | 12 | KA10/KI10/KS10 KCC native, both optimization modes |
| `pdp6-gcc-opt` | 14 | 42 | PDP-6 GCC O1/O2/Os only |
| `resource-gated` | 3 | 0 | Preserve existing PDP-6 KCC and GCC O0 selections |
| `already-native` | 1 | 0 | Preserve the native byte-pointer regression's previous CPU profiles |
| `isa-separate` | 1 | 0 | Keep KL10 assembler fixture outside the C matrix |

The six dual-native sources are `20010518-2.c`,
`20020412-1.c`, `conversion.c`, `builtin-prefetch-6.c`,
`comp-goto-1.c` and `builtin-noret-1.c`. These exercise
packed aggregate, variadic aggregate, native numeric conversions,
nonfaulting prefetch, GNU computed goto and noreturn optimization
contracts. Unknown profiles are `pending`; failures are not
excluded and no compiler PASS is invented.

The four KCC-native sources are `920726-1.c`, `930513-1.c`,
`960327-1.c` and `980605-1.c`. KCC had reached passing guest
oracles under PDP-6 with the installed runtime. KA10/KI10/KS10 are
now *scheduled for KCC only*: unverified GCC hosted headers are
not assumed to work on other CPUs.

The 14 PDP-6 GCC opt sources include the stdio transformation
tests, which need an optimized compiler to exercise their intended
builtin transformations. The missing genuine hosted prerequisites
remain visible as compile/link failures. Optimized profiles are
admitted as tests, **not** as statements of semantic correctness.
They must not be silently replaced by dummy stdio/ctype/math
functions. No base-family or generic-PDP10 family entries were
automatically activated.

`960521-1.c` requires at least 65,536 allocated target words before
other program memory, and its PDP-6 runs time out. The
resource-heavy/unfinished `20020406-1.c` and `990628-1.c`
are also left at existing PDP-6 profiles pending actual memory and
termination policies. The former `old.tort.c` no longer exists;
its one canonical native replacement
`pdp10-byte-pointer-torture-v1.c` already has its own profiles.
`920428-1.s` requires an independently implemented KL10 ISA
test harness, not a C compiler cell.

## Bounded actual KA10/PDP-6 smoke runs

Three **single-cell** runs exercise newly admitted profiles without
executing the wider matrix:

| Source | Profile | Actual result |
| --- | --- | --- |
| `builtin-prefetch-6.c` | KA10 GCC O2 | PASS, guest HALT and exit 0 |
| `920726-1.c` | KA10 KCC noopt | PASS, guest HALT and exit 0 |
| `stdio-opt-2.c` | PDP-6 GCC O2 | `link_fail`, unresolved `putchar` |

The two passes apply **only to those exact profiles**. The prefetch
original remains partially covered; the KCC formatting original
remains blocked pending broader hosted/return-value acceptance.
The optimized stdio source requires genuine `putchar` and related
runtime semantics: no fabricated symbol or substituted assertion
was used.

These real reports are archived and individually checksummed in
`refs/p10tk-p1-native-admission-smoke-20261120-v1.tar.gz` and
`docs/PDP10-P1-NATIVE-ADMISSION-SMOKE-20261120-v1.tsv`.
The audit proves the two successful guest HALTs/exit values and
the precise unresolved `putchar` linker diagnostic.

## Reproduction and fail-closed verification

```sh
python3 tools/audit-p1-matrix-admission-v1.py
python3 tools/test-p1-matrix-admission-v1.py
python3 tools/test-p1-matrix-admissions-v1.py
python3 tools/audit-test-inventory-v1.py
```

The versioned admission auditor checks every source SHA, all 29
ledger obligations, the exact tier and column policy, both KCC
optimization modes, absence of duplicate current matrix owners,
preservation of the separate KL10 fixture, and all three archived
smoke outcomes. Its host regression has **16 negative controls**
for disabled cells, accidental pass status, unsupported family
activation, source/tier drift, resource-policy regression, duplicate
source, premature P1 closure and tampered guest evidence.

This is a **pre-sweep scheduling milestone**, not P1 test closure.
The current P1 resolution remains **38 covered, 1 partial, 28
blocked**. Neither a compiler implementation nor any historical
source, test assertion, runtime member or simulator was changed.
