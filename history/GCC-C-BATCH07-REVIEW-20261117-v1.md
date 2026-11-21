# Historical GCC C integration, batch 07 of 50 (2026-11-17 v1)

## Original sources and exact oracle review

Batch 07 reviews exactly the next **50 unresolved** original GCC C
sources, in the pinned 679-source preflight order after batches 01-06.
All 50 originate in `gcc/testsuite/gcc.dg/cpp/`, the historical GCC
preprocessor regression directory. Their original byte-for-byte source
snapshots remain in `refs/gcc-c-unmirrored-v1/gcc.dg/cpp/`, from pinned
GCC revision `b0f5374f6d4462bb8759160ece635e306d90998f`. The 89
previously deleted inapplicable sources remain absent; the cumulative
source-identity ledger still accounts for all 679 original entries.

`manifests/GCC-C-BATCH07-20261117-v1.tsv` contains 50 ordered decisions
with the original SHA256, original `dg-do` and `dg-options`, actual
preprocessor/runtime/diagnostic oracle, PDP-10 assessment, KCC
applicability, assigned ownership, adapted SHA256 and limitations.
A similar filename elsewhere in the central testkit is not evidence
of an equivalent source or assertion.

| Disposition | Original C files |
| --- | ---: |
| Newly registered as pending | **11** |
| Deferred without weakening the original assertion | 39 |
| Newly classified inapplicable | 0 |
| **Reviewed** | **50** |

## Eleven registered sources

The integrated sources are in
`tests/codegen/gcc-historical-b07-v1/` (ten compile-only) and
`tests/semantic/gcc-historical-b07-v1/` (one runtime).

| Original | Compiler eligibility | Source-level oracle preserved |
| --- | --- | --- |
| `19990119-1.c` | GCC/KCC | Backslash-newline continuation must leave the `__LINE__` value at the original physical line 6; negative array bound means compile failure |
| `19990407-1.c` | GCC only | At-sign token stringization of `@foo` must equal the literal `"@foo"` at runtime |
| `19990409-1.c` | GCC/KCC | Object-like macro `XLINE` expands its `__LINE__` at the invocation site, preserving the compile-time array bound |
| `20000127-1.c` | GCC/KCC | Function macro argument containing a **9,403-byte** C source with a long multiline comment must preprocess and compile without crash |
| `20000207-1.c` | GCC/KCC | Three `#if` unary-minus expressions must avoid guarded `#error Error` branches |
| `20000207-2.c` | GCC/KCC | Three `#if` unary-plus expressions must avoid guarded `#error Error` branches |
| `20000209-2.c` | GCC only | GNU named variadic macro `NO_PAREN(rest...)` must expand into array initializers across split lines |
| `20000529-1.c` | GCC/KCC | `#elif` with nested macro token pasting and undefined ABI identifiers must select a valid declaration |
| `20000627-1.c` | GCC/KCC | A `#define` directive split across a backslash-newline must expand `foo` to the declared identifier |
| `20000628-1.c` | GCC/KCC | Self-including header invokes a second header exactly three times to declare `a`, `b`, and `c`; a fourth inclusion triggers `#error` |
| `assert1.c` | GCC only | GNU `#assert` and `#unassert` predicate values, whitespace and selective removal must satisfy guarded compile-time checks |

**Eight** test owners are eligible for both KCC and GCC; **three**
are GCC-only. All 11 use GCC PDP-6 `-O0`, `-O1`, `-O2`, and `-Os`
pending profiles. The eight shared cases additionally use KCC
`pdp6` and `pdp6_base`, for a total of **44 pending GCC** and
**16 pending KCC** compiler cells. No other compiler/CPU cell was
activated; all remain `no_test`. `pending` does not mean the case
has compiled or passed.

### Source fidelity and required companion headers

Nine of the eleven adapted C files are byte-for-byte identical to
the original archived bodies, including their inert DejaGNU driver
comments. In particular, `19990119-1.c` must not have a banner inserted:
its physical `__LINE__` value is the assertion. The two unary `#if`
tests add exactly one `/* codegen-kcc-preprocess: source */` directive
before their otherwise unchanged source, so KCC checks their original
**preprocessing-only** action via its native `-E` runner. GCC's
compile-only path also invokes preprocessing; if a guarded `#error`
becomes active, the compile fails. These source changes, original
checks and resulting hashes are explicit in the review TSV.

One original input, `20000127-1.c`, contains an intentional, preserved
trailing space after `int x = ` on its eighth line. A blanket Git
whitespace check reports that exact historical byte. Strict staged
whitespace checks therefore exclude this one source, and a separate
byte-for-byte comparison verifies it is unchanged from the pinned
snapshot; no whitespace exception applies to other changed files.

`20000628-1.c` requires two headers, copied byte-for-byte beside the
adapted `.c` file and pinned independently in
`manifests/GCC-C-BATCH07-COMPANIONS-20261117-v1.tsv`:
`20000628-1.h` and `20000628-1a.h`. The header cycle must not be
flattened, shortcut, or replaced with synthetic declarations.

Two preprocessor cases have compiler-specific limitations: KCC's
handling of the nonstandard `@` token in `19990407-1.c` is not
established, and KCC's implementation of GNU named varargs and
`#assert` is not known to reproduce GCC's original behavior.
These three are GCC-only rather than falsely broadening KCC coverage.
`20000209-2.c` originally selected `-Wall`; the current native matrix
checks its source-level expansion and valid initializer, **not** the
unimplemented `-Wall` warning policy.

`20000127-1.c` has a same-name central file at
`tests/codegen/upstream-gcc/compile/20000127-1.c`, but that central
file exercises double arithmetic and contains **none of the original
large-comment macro argument**. It is not an equivalent owner, so the
original CPP regression has its own separately versioned registration.

## Thirty-nine deferred originals

The individual TSV rows preserve the actual original assertion and
separate KCC reasoning. Major categories are:

* **Required positive/negative diagnostics:** the trigraph warning
  tests, multiline macro source-line errors, illegal token paste,
  `_Pragma1.c` poisoned-token and directive errors,
  `assert2.c`/`assert_trad2.c`, `backslash.c`/`backslash2.c`,
  `charconst.c`, `cxxcom1.c` and others require exact `dg-warning`,
  `dg-error`, `dg-bogus`, and sometimes explicit line locations.
  A successful compile or preprocess would erase their purpose.
* **Preprocessor-output assertions:** `19990228-1.c`,
  `avoidpaste1.c`, `avoidpaste2.c`, `cmdlne-C2.c`, and
  `cmdlne-P.c` check `dg-final` output text (including whitespace,
  linemarkers, or comment preservation); the current testkit does
  not reproduce these Tcl/grep assertions. The other `cmdlne-*`
  cases require output-modifying flags such as `-C`, `-dD`, or
  `-dM`, not supported by a generic compiler-matrix profile.
* **Dialect- and option-specific CPP:** `assert3.c`, the three
  `assert_trad*.c` files, the C++98/C89/C94/C99 `-std` modes, and
  `-pedantic` warning distinctions require explicit original compiler
  options and sometimes non-C preprocessor semantics. Successful
  compilation under the default dialect would not be equivalent.
* **Preprocess-only crash or extension guards without a C translation
  unit:** `19960224-1.c`, `20000301-1.c`, `20000519-1.c`,
  `20000725-1.c`, and `_Pragma2.c` are retained for a dedicated
  preprocess-only implementation or further compiler-extension
  verification. In particular, a macro definition without an
  invocation is not a meaningful compile-success assertion.
* **Target/width-specific acceptance:** `charconst-2.c` uses
  `-fsigned-char` and an `\xff` escape across the 8-bit-character
  host/target bug. PDP-10 uses 9-bit C `char`, where 255 has different
  signed representability; the flag and no-warning contract need a
  dedicated policy before promotion.

No source in this group was proved permanently inapplicable to the
PDP-10 toolchain: **zero new deletions** were appropriate. The
89 previous inapplicable originals remain deleted and their
versioned tombstone manifest is unchanged. No deferred test or
archived original was deleted or silently converted to a positive test.

## Reproducibility and continuation

The static verifier `tools/inventory-gcc-unmirrored-v1.py` now checks
that batch 07 contains exactly the next 50 original source identities,
that source/original fingerprints and both header companions match,
that the KCC-only preprocessing directives preserve source bodies,
and that matrix groups/columns are restricted exactly to the per-source
eligibility reviews. It retains all previous batch checks and the
89-source deletion tombstones.

After batch 07, **305 historical C sources remain unresolved**:
**9 same-name candidates** and **296 unreviewed originals**. Batch 08
should continue in source-ledger order, independently reviewing
preprocessor-output requirements and KCC applicability.

**Only static source, hash, ledger, matrix, and documentation checks
have been made. No compiler, assembler, linker, emulator, test runner
or runtime test has been executed.**
