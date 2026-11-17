# PDP-10 registered code-generation oracle integration (2026-11-17 v1)

## Scope and execution restrictions

This is a testkit preparation/integration change from `b15ef0b`. The
user explicitly requested **no further full compiler matrix sweeps**.
Only static inventory checks, host synthetic checks and a small number
of direct installed-compiler probes were run. No GCC/KCC compiler,
assembler, emulator, runtime, or original test-body implementation was
modified. Failing compiler assertions were not marked as passed.

## Previously unexecuted assertions

The registered `COMPILER_MATRIX.tsv` fixtures declared **22 individual
assertions** that were silently ignored by the compiler runner:

* **16 forbidden instruction forms** distributed across six
  `codegen-forbid-form` source fixtures. The supported, checked forms
  are `POP_AC_AC`, `JFCL1`, `SET_MEMREF`, `SETZ_MEMREF`, and
  `SETO_MEMREF`. `POP_AC_AC` denotes popping into the **same** stack AC;
  ordinary `POP 17,6` is valid and must not fail. The `SET*` forms
  reject an effective-address memory target rather than a bare AC.
  Unknown form names now cause failures rather than silent acceptance.
* **Four required double helper symbols** from
  `tests/codegen/pdp10/pdp10_double_helpers_required.c`, represented
  by `codegen-require-symbol` (`$KDFAD`, `$KDFSB`, `$KDFMP`,
  `$KDFDV`). A real instruction-operand reference is required; a
  declaration such as `.globl $KDFAD` alone cannot pass.
* **Two required/forbidden target macro assertions** in
  `tests/codegen/pdp10/pdp10_no_pdp6_macro.c`:
  `__PDP10_PDP10__` must be defined and `__PDP10_166__` absent.
  A tiny per-cell generated C source is preprocessed by the **actual
  selected compiler/architecture**, not the host preprocessor.
  Missing/forbidden macros are `policy_fail`; launch failures, timeouts
  and internal compiler errors retain distinct failing statuses.

`tools/codegen_declared_oracles_v1.py` provides the form, referenced-
symbol and macro-source predicates. The existing `run_codegen_cell`
executes the declared checks only for relevant codegen sources. The
original generated assembly and restart/report path conventions remain
unchanged. All checks are fail-closed.

## Previously ignored historical GCC assembly scans

Two byte-preserved original GCC tests in
`tests/codegen/gcc-historical-b04-v1/` had multiline C comments with
`* codegen-require-regex:` lines:

* `asm-2.c`: require the emitted `foo%bar` assembler line.
* `asm-3.c`: require the emitted `foo%%bar` assembler line.

The compiler runner had accepted only single-line `/* ... */`
directive syntax and therefore never checked either original scan.
It now recognizes annotated lines **inside real multiline C comments**
as well as single-line comment directives. The source files, regexes
and original inline assembler remain unchanged. Both checks **passed**
in direct GCC native PDP-6 `-O0` codegen probes after the parser fix.
Other registered CPU/optimization selections remain unverified.

## Profile-registration correction and retained compiler problem

`pdp10_no_pdp6_macro.c` is explicitly a generic `-march=pdp10` macro
test, not a native KI10/KS10 macro test. Eight GCC native KI10/KS10
`-O0`/`-O1`/`-O2`/`-Os` cells had been wrongly assigned to it.
Previously they falsely passed because the macro assertions were
ignored. The eight **inapplicable** cells are now `no_test` in the
authoritative matrix. Twelve GCC `pdp10`-family cells across
KA10/KI10/KS10 and all four optimization levels remain registered.
Three KCC `pdp10`-family cells also remain registered.

In targeted installed-compiler checks:

* GCC `-march=pdp10 -O2` defines the required macro and passed.
* GCC native `-march=ki10 -O2` lacks the generic macro, exposing the
  erroneous cross-family assignment (now removed).
* KCC `-x=pdp10` **does not define `__PDP10_PDP10__`** in the current
  installed compiler. Its original codegen test previously passed
  without evaluating this oracle and now correctly reports
  `policy_fail`. This is a **compiler behavior to investigate
  separately**, not a testkit or compiler fix in this work.
* KCC `pdp10` helper-symbol codegen emitted all four required
  `$KDF*` references and passed the newly enforced symbol assertions.
* Sample native/base KCC instruction-form codegen fixtures passed with
  the newly enforced forbidden-form assertions.

The earlier archived 14,402-cell native GCC codegen **raw execution
census** was recorded before this correction. Its registration count
is now **14,394** (eight fewer inapplicable cells); no old test result
was retroactively rewritten or declared re-executed. An eventual user
full sweep must produce fresh status totals under this corrected
matrix. The prior hash-pinned failure evidence remains historical.

## Fail-closed coverage audit

`tools/test-codegen-declared-oracles-v1.py` is a newly registered
`verify` host check. It examines every active compiler matrix source
for `codegen-*` labels, including lines inside multiline comments,
and requires every occurrence to be parsed and handled. It validates
known directive names, regular-expression syntax, KCC structured
checker names, special-check names, preprocessor modes, source-specific
header include paths, allowed instruction-form names and the corrected
generic-PDP10 macro ownership. It exercises synthetic valid and
invalid instruction forms, referenced-symbol checks, macro probes,
and actual `run_codegen_cell` report/status dispatch under mocked
compilation. No compiler process is needed for this host test.

The audit now reports **459 parsed directive occurrences** and the
22 newly enforced individual operand/symbol/macro assertions.
Previously ignored source labels cause an audit failure rather than
being omitted. Both the ordinary test and `python3 -O` passed.

The registered `verify` subgroup passed **17/17**. A second host check,
`tools/test-registered-fixture-integrity-v1.py`, statically validates
syntax for all **383** owned scripts (163 shell and 220 Python) and
resolves **313 literal quoted includes** across positive registered C
sources. It deliberately does not reject missing headers in negative
tests that may be intended to assert a failure. No compiler or test is
executed by this check. Static source ownership: 2,105 compiler matrix
sources; 249 special registrations; 235 enabled direct script owners;
no unowned sources or script paths;
all 269 deliberately deferred semantic source dispositions still
accounted for. Original historical GCC source identity audit remains
679 reviewed sources with 560 retained and 119 tombstones. These are
**static integration statements**, not successful full-suite execution
claims.

## Remaining preparation and user execution work

* Actual full compiler, guest/ISA and special-suite sweeps are deferred
  to the user. No full sweep was started during this change.
* The 269 explicitly deferred semantic upstream sources and the
  historical GCC diagnostic/varargs/ABI candidates are **not**
  spuriously activated. Those requiring unsupported semantics or
  unresolved compiler behavior must retain their source-specific gate.
* Exact original GCC DejaGNU `dg-warning`, `dg-error`, `dg-bogus` and
  option-sensitive diagnostics are not yet an executable general
  oracle and require a separate integration phase.
* The independent `daimos-testkit` repository had existing uncommitted
  work and was left untouched. Its larger, dynamically invoked script
  inventory still requires an independent ownership/dispatch audit.

The authoritative runner remains `tools/run-tests.py`, and the
special-suite dispatcher remains `tools/run-misc-suites.py`. No
parallel wrapper or duplicate test runner was introduced.
