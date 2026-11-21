# KCC negative-rejection result and ICE guard (2026-11-16 v1)

## Result

**PASS: all 814 KCC negative compilation cells** across the 37 active
negative sources and 22 applicable native/base/PDP-10 profiles, using
the current installed KCC and the complete new fail-closed rejection
policy. This is a compiler diagnostic sweep, not a guest-execution test.

| Independently executed sweep | Cells | Pass | Fail |
| --- | ---: | ---: | ---: |
| Base family, PDP-6/KA10/KI10/KS10, optimized/unoptimized | 296 | 296 | 0 |
| Remaining native/PDP-10 family profiles | 518 | 518 | 0 |
| **Total** | **814** | **814** | **0** |

All result rows and logs were written to separate versioned temporary
output directories, not the default `workdir` checkpoint directory.
The two sweeps were executed rather than inferred from `--list-only`.
The base run used two parallel jobs, the remaining-profile run three.
No GCC compiler cell was run as part of these KCC-only sweeps.

## Defect

Several registered special-suite scripts considered **any** failed KCC
invocation a passing expected rejection. This can silently promote a
compiler ICE, signal, input-path error or other abnormal exit to PASS.
The KCC parser regression already checked an error summary but did not
enforce a nonzero process exit. The matrix negative-cell path rejected
known ICE patterns, but accepted any failure with nonempty diagnostics;
it did not require an identifiable KCC source-rejection diagnostic.

The correction uses one shared `tools/compiler_negative_policy_v1.py`
to retain the matrix's ICE detection and check standalone KCC rejections:

- Exit must be nonzero and below reserved abnormal status 124.
- No internal-error, segmentation fault, bug-report, assertion-failure
  or other known compiler-crash diagnostic may appear, even alongside
  ordinary source errors.
- Output must contain KCC's nonzero `? KCC - N error(s) detected`
  diagnostic, or its specific maximum-error limit after source-location
  diagnostics. This latter case is **not** an ICE: KCC deliberately
  terminates with `? KCC - Fatal error: Too many errors` after reaching
  `MAX_ERRORS` ordinary diagnostics.

The actual source `920923-1.c` confirmed this distinction: the first
strict run classified it `policy_fail` because the compiler stopped at
its maximum error count. Reviewing the log and KCC `ccerr.c` proved
the error-limit exit intentional, not a crash. The revised policy
accepts only this narrow documented limit with preceding source
diagnostics; an unrelated fatal error remains a failure.

`tools/check-kcc-rejection-v1.py` exposes the same policy to shell
regressions. `misc/kcc-regression/language-modes.sh`,
`misc/compat/test-language-compat.sh`, and
`misc/validation/test-kcc-p0-diagnostics-v1.sh` now capture real exit
codes and invoke this checker, including both stdout and stderr where
the compiler separates them. The regular `tools/run-tests.py` KCC
negative-cell path uses the same policy on compile failures; GCC
diagnostic policy remains unchanged and needs a separate review.

## Independent checks and limits

`python3 tools/test-kcc-negative-policy-v1.py` passes 17 direct
library/CLI examples: ordinary error summaries, the KCC error limit,
accepted invalid code, absent diagnostics, warning-only output,
signals, timeouts, unrelated fatal errors and ICE text coexisting with
normal errors. This is also registered in the `verify` suite.

Real KCC `language-modes.sh` passes all its rejection/acceptance cases.
Real `test-kcc-p0-diagnostics-v1.sh` passes four negative cases plus a
valid-source case. KCC's language-attribute rejection independently
passes the new checker. The **full** `test-language-compat.sh` remains
unverified because its legacy `KCC_RT=.../ks10rt.s` path does not exist
in the installed prefix. The prefix contains target-specific runtime
fragments instead. This pre-existing compatibility-test infrastructure
problem is not a compiler diagnostic defect; no dummy runtime file was
created. A separate, symbol-checked runtime-link migration is required.

This acceptance does **not** establish successful GCC diagnostic
coverage, all semantic/codegen cells, KCC runtime compatibility or
absence of future ICEs under untested source/profile combinations.
