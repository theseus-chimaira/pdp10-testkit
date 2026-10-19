# Test inventory and deferred disposition (2026-10-19, v1)

This is a static inventory and evidence-based *work classification*, not a
claim that unexecuted compiler tests pass. No compiler, assembler, emulator,
or DAIMOS code was modified. Historical error messages require reproduction
against current toolchain installations before being called current bugs.

## Authoritative source inventory

| Source | Verified state |
| --- | ---: |
| `COMPILER_MATRIX.tsv` | 1,979 unique registered C sources |
| `SPECIAL_TESTS.tsv` | 194 unique specialized script IDs/paths |
| Upstream source classification manifest | 774 original entries |
| Upstream active | 442, all with matrix ownership |
| Upstream deferred | 276, all retained, none matrix-enabled |
| Upstream removed | 55, all absent and not registered |
| Upstream nonportable stress | 1, retained outside required semantic pass/fail |
| Additional `tests/` companion sources | 13, with explicit owning tests |
| Unknown/unowned `tests/` C/assembly sources | 0 |

An exact duplicate registration of `aap-instrumentation-v1` was deleted.
The existing executable `pdp10-gcc-multidim-char-20261012.sh` was registered
as `pdp10-gcc-multidim-char-v1`; its companion C source remains part of that
script rather than being independently scheduled. Other companion C and
assembly sources are recorded with their owning registered entry in
`tools/audit-test-inventory-v1.py`.

The inventory audit deliberately rejects missing registered paths, duplicate
registry IDs or paths, matrix/special double ownership, new unowned sources,
stale upstream activation and missing companion ownership. Run:

```
python3 tools/audit-test-inventory-v1.py
python3 tools/verify-deferred-disposition-v1.py
```

Both validators are registered under the `verify` special suite.

## All 276 deferred cases given an explicit disposition

`SEMANTIC-DEFERRED-DISPOSITION-20261019-v1.tsv` contains exactly one row for
every deferred upstream manifest entry. Each row includes the original path,
original category and evidence text, a SHA-256 of the retained source, a
primary blocker classification, and a required next action. Reclassification
is mandatory if the original manifest or source bytes change. The `deferred`
activation is intentionally retained until independently justified execution,
portability adaptation, GCC-only activation, or documented removal.

| Primary disposition | Sources |
| --- | ---: |
| Compiler ICE priority (historical KCC fatal) | 1 |
| Compiler semantics/codegen investigation | 44 |
| Linker or runtime helper investigation | 4 |
| Shared libc or builtin/linker integration | 55 |
| Header integration | 17 |
| Varargs ABI and header integration | 26 |
| Hosted runtime/OS dependency | 23 |
| Explicitly unsupported KCC GNU extension; assess GCC independently | 37 |
| KCC feature-policy decision required | 37 |
| Source-width/portability derivation required | 10 |
| Missing/nonmeaningful assertion | 12 |
| Assembler/ISA ownership and prerequisites | 8 |
| Historical evidence requires fresh reproduction | 2 |
| **Total** | **276** |

One priority case is `tests/todo/generic/930622-2.c`: its recorded KCC
diagnostic is `fatal vrwiden reg already wide`. This is a *potential ICE*
requiring immediate reproducibility checking before ordinary compiler
debugging. Other historical failures are not automatically compiler bugs.

There are 48 groups of two byte-identical sources *within* the 276 deferred
files (228 distinct source contents). Two additional deferred sources,
`strct-pack-1.c` and `strct-pack-3.c` under `extensions/`, have byte-identical
copies already registered in the active `pdp10/pdp10/` matrix group. Content
identity does not necessarily imply identical CPU-profile assertions or
execution outcomes; do not delete either without an ownership/profile audit.

## Next stages, before compiler correction

1. Review content-duplicate pairs for one canonical owner and intentional
   profile variants, preserving original regressions and historical results.
2. Rebuild/reinstall supported target headers and shared libc. Retest the
   header, libc, and varargs classes using the real termination harness.
3. Confirm GCC-only applicability for unsupported KCC GNU features. Keep
   undecided KCC extension requests separate from definite compiler defects.
4. Derive PDP-10-specific expected results for width-sensitive sources and
   reject tests whose asserted code is unreachable or vacuous.
5. Validate hosted/ISA tests' ownership; keep peripheral, OS, and DAIMOS
   integration out of the bare-metal compiler matrix.
6. Once prerequisites and classification are settled, reproduce the P0 KCC
   fatal and then work through confirmed C compiler and linker failures.

No full CPU/optimization matrix execution or compiler problem remediation
was performed as part of this inventory snapshot.

## Same-day libc/header retest update

The later `DEFERRED-LIBC-HEADER-RETEST-20261019-v1.md` describes verified
KCC/GCC PDP-6 execution, five further source activations, and the separation
of real missing functions from header/linkage problems. The *current* registries
after that batch have 1,985 matrix sources, 195 special registrations (including
one manually invoked diagnostic), and 448 active / 270 deferred upstream
sources. The earlier figures above remain the recorded pre-retest snapshot.
