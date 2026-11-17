# GCC/KCC diagnostic oracle integration (2026-11-17, v1)

## Scope

This is compiler **testkit preparation**, not compiler implementation.
The user will perform full compiler sweeps separately. No full matrix,
guest/ISA or special-suite sweep was run during this change. We used a
five-cell diagnostic pilot, four individual KCC semantic checks and
two isolated KCC language-feature probes. Original GCC source
snapshots, C bodies and compiler implementations were not changed.

## Source-located diagnostic runner

The authoritative `tools/run-tests.py` runner now accepts
`--kind diagnostic`. The same `COMPILER_MATRIX.tsv` registrations,
per-cell restart checkpoints, selected-cell summaries, failure TSV and
parallel scheduler are used. No second compiler-matrix runner exists.

`DIAGNOSTIC_ORACLES_V1.tsv` specifies each source/compiler-specific
original action (`accept` or `reject`), compiler option string,
asserted source line, diagnostic severity (`warning`, `error`, or
forbidden `bogus`), required regexp, required count and pinned
original source SHA256. A real compiler must exhibit the declared
behavior. Merely exiting with an error is insufficient for a negative
diagnostic test. The engine checks real source-located compiler
messages, not command echo, driver output, or unrelated header lines.
It distinguishes GCC 3.2 `file.c:N:` and KCC `"file.c", line N:`
locations and the two compilers' diagnostic category spellings.

Compiler crashes, ICEs, launcher errors, missing outputs and timeouts
remain separate **failures**; a missing expected diagnostic is
`policy_fail`. A forbidden diagnostic also produces `policy_fail`.
Original source bodies are kept byte-identical under
`tests/diagnostic/gcc-historical-v1/`. No `#line` decorations or
inserted comments change the historic line-number oracle. KCC uses
an independently stated, same-line diagnostic regexp when GCC's
literal warning/error wording is not a meaningful KCC requirement.
The original `cpp/19990413-1.c` line 12 contains a trailing space
after its DejaGNU annotation. It is intentionally preserved in the
byte-identical test copy; staged whitespace checking must exclude
**only that original C file**, while its SHA256/copy identity is
checked independently. No edited testkit implementation file has a
whitespace exception.

This v1 engine handles compile-time warning/error/absence and
source-location checks. It does **not** claim support for all DejaGNU
directives, alternate expected-failure (`xfail`) conditionals,
target-glob selection, multitranslation-unit linkage, `dg-final`
assembly/output processing, or every GCC `-std`/`-W` option. Such
cases must remain deferred until their actual assertions can run.

## Exact original diagnostic sources

| Original GCC source | Compiler/profile | Original oracle | Pilot |
| --- | --- | --- | --- |
| `gcc.dg/return-type-1.c` | GCC PDP-6 `-O1`; original `-O -Wreturn-type` | Line 9 warning `control reaches end of non-void function` | PASS |
| `gcc.dg/unused-1.c` | GCC PDP-6 `-O1`; original `-O -Wall -W` | Line 8 warning `unused parameter` | PASS |
| `gcc.dg/cpp/19990413-1.c` | KCC PDP-6 native opt/noopt | Source-line 12 error after a multiline macro argument; KCC equivalent `Primary expr expected` | PASS/PASS |
| `gcc.dg/cpp/19990413-1.c` | GCC PDP-6 `-O0` | Original line 12 `dg-error` regexp `parse error` | **policy_fail** |

The GCC PDP-6 3.2 compiler currently emits `syntax error before
"else"` on line 12, **not** the original annotated `parse error`.
This is an original diagnostic-text mismatch, not a wrong source
location. The test remains failing and the GCC regexp is not changed
to accept the new spelling. The compiler and original source are
untouched. All five selected compiler cells completed with **four
passes and one policy failure**; there were no setup failures or ICEs.

Reproduce this *small* optional diagnostic pilot (not a full sweep):

```sh
export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"
./run-tests.sh --kind diagnostic --compiler all --family native \
  --cpu pdp6 --opt o0,o1,opt,noopt -j 2 \
  --out-dir "$TMPDIR/pdp10-testkit-diagnostic-pdp6-pilot-20261117-v2"
```

The exit status is deliberately nonzero while the original GCC
`parse error` diagnostic is missing. Do not label this known failure
as passed or erase it to obtain a green aggregate.

## GCC-only source reclassified for KCC: `cpp/mi6.c`

`tests/semantic/gcc-historical-b09-v1/mi6.c` already contained the
byte-identical GCC original and five byte-identical companion
headers. The original `dg-do compile` contract was previously
strengthened by a runtime `main` check that all five unusual
multiple-inclusion guards are expanded after macro redefinitions.
The previous GCC batch-09 review left KCC eligibility unknown.

Direct, isolated KCC compile/link/execute pilots on actual PDP-6
confirmed that original test and runtime assertion pass under:

* KCC PDP-6 native `opt`: PASS
* KCC PDP-6 native `noopt`: PASS
* KCC PDP-6 base `opt`: PASS
* KCC PDP-6 base `noopt`: PASS

The existing source now has KCC `pdp6` and `pdp6_base` **pending**
matrix registrations (the `opt/noopt` execution dimension is per
compiler profile). All four actual pilot results were successful,
but a fresh full sweep remains separate. The old 50-row immutable
`docs/GCC-C-BATCH09-20261117-v1.tsv` is retained. Its derived
versioned `v2.tsv` records exactly one decision adjustment, updating
only KCC eligibility, KCC profiles and KCC evidence for `mi6.c`.
The historical inventory verifier explicitly forbids unrelated v2
changes or alteration of source hashes and companion ownership.

Two other GCC-only source probes correctly remain unregistered for
KCC: `cpp/digraphs.c` fails KCC parsing of C99 digraph spellings,
including the original `glue` guard; `cpp/ident.c` produces
`Unsupported preprocessor command: "ident"`. These are actual
KCC feature limitations, not proof that all remaining GCC-only tests
are unsuitable. No source transformation was used to manufacture
equivalent coverage.

## Registered host checks and open work

`tools/test-diagnostic-oracles-v1.py` checks registry ownership,
source fingerprints, exact original GCC `dg-warning`/`dg-error`
regexps, original compiler options, physical line-number positions,
KCC equivalent wording, correct source attribution, severity,
required/forbidden matching, ICE/setup/timeout failures, and actual
`run_diagnostic_cell` checkpoint status routing through synthetic
mutation cases. It is a registered host `verify` test, with the
diagnostic oracle helper owned by the existing matrix runner.

Remaining preparation, separately tracked:

* Import original diagnostic suites in focused, source-reviewed batches,
  prioritizing C89 type/constraint errors and false-positive warnings.
  Do not treat supported options on GCC as assumed equivalents on KCC.
* The fifty historical GCC format diagnostic cases in batch 11 remain
  deferred. Their 940 warning, 33 error and 11 forbidden assertions
  need their original format header, dialect and option contracts;
  many are not meaningful KCC feature obligations.
* The 269 upstream semantic deferred sources, original-GCC review
  dispositions, GCC-only exact-width pointer/ABI tests and the
  independent `daimos-testkit` repository remain separate work.
  No changes were made to `daimos-testkit` or compiler sources.

The historical GCC batches are evidence of prior decisions, not a
claim that every source has now been executed. The present `v2` and
explicit new diagnostic source/option registry record exactly the
incremental, independently checked changes.
