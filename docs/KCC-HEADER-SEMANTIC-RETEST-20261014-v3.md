# KCC installed-header semantic retest (2026-10-14, v3)

## Environment

- Compiler: KCC rebuilt from repository, installed into versioned temporary staging prefix.
- Headers: matching KCC `self/include` installed under `lib/kcc/include` in that prefix.
- Execution: existing PDP-6 `p10run` with `crt0-upstream-v1.s`, `exit-v1.s` and `abort-v1.s`.
- The operational toolchain prefix has **not** been changed. No compiler or imported test sources modified.

## Outcomes

- 97 deferred cases had missing-header reasons and were recompiled.
- 70 compile with the staged headers; 27 still fail compilation.
- Of the 70 compiled cases, 45 pass execution and 25 fail linking/runtime.
- 44 meaningful execution passes activated; `inst-check.c` remains deferred as a vacuous result.
- Source files moved back to their original test categories unchanged. Other profiles still unverified.

## Full retest table

| Original deferred source | Compilation | Runtime | Classification |
| --- | --- | --- | --- |
| `tests/todo/generic/20000519-1.c` | compiled | pass | active |
| `tests/todo/generic/20000910-1.c` | compiled | pass | active |
| `tests/todo/generic/20000910-2.c` | compiled | run_fail | deferred |
| `tests/todo/generic/20010329-1.c` | compiled | pass | active |
| `tests/todo/generic/20010604-1.c` | compile_fail | not run | deferred |
| `tests/todo/generic/20020226-1.c` | compiled | pass | active |
| `tests/todo/generic/920501-6.c` | compiled | run_fail | deferred |
| `tests/todo/generic/920501-8.c` | compiled | run_fail | deferred |
| `tests/todo/generic/920625-1.c` | compiled | pass | active |
| `tests/todo/generic/920726-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/920730-1.c` | compiled | pass | active |
| `tests/todo/generic/920810-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/920908-1.c` | compiled | pass | active |
| `tests/todo/generic/930513-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/931004-10.c` | compiled | pass | active |
| `tests/todo/generic/931004-12.c` | compiled | pass | active |
| `tests/todo/generic/931004-14.c` | compiled | pass | active |
| `tests/todo/generic/931004-2.c` | compiled | pass | active |
| `tests/todo/generic/931004-4.c` | compiled | pass | active |
| `tests/todo/generic/931004-6.c` | compiled | pass | active |
| `tests/todo/generic/931004-8.c` | compiled | pass | active |
| `tests/todo/generic/941014-2.c` | compiled | run_fail | deferred |
| `tests/todo/generic/960311-1.c` | compiled | pass | active |
| `tests/todo/generic/960311-2.c` | compiled | pass | active |
| `tests/todo/generic/960327-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/960521-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/980205.c` | compiled | pass | active |
| `tests/todo/generic/980605-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/980608-1.c` | compiled | pass | active |
| `tests/todo/generic/980707-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/980709-1.c` | compile_fail | not run | deferred |
| `tests/todo/generic/980716-1.c` | compiled | pass | active |
| `tests/todo/generic/990513-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/990628-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/990826-0.c` | compile_fail | not run | deferred |
| `tests/todo/generic/991216-2.c` | compiled | pass | active |
| `tests/todo/generic/991216-3.c` | compile_fail | not run | deferred |
| `tests/todo/generic/builtin-abs-1.c` | compile_fail | not run | deferred |
| `tests/todo/generic/gofast.c` | compiled | run_fail | deferred |
| `tests/todo/generic/inst-check.c` | compiled | pass | deferred |
| `tests/todo/generic/int-compare.c` | compiled | pass | active |
| `tests/todo/generic/loop-2b.c` | compiled | pass | active |
| `tests/todo/generic/loop-3.c` | compiled | pass | active |
| `tests/todo/generic/loop-3b.c` | compiled | pass | active |
| `tests/todo/generic/loop-3c.c` | compiled | run_fail | deferred |
| `tests/todo/generic/memcpy-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/memcpy-2.c` | compiled | run_fail | deferred |
| `tests/todo/generic/memset-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/pdp10/920625-1.c` | compiled | pass | active |
| `tests/todo/generic/pdp10/930513-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/pdp10/931004-6.c` | compiled | pass | active |
| `tests/todo/generic/pdp10/gofast.c` | compiled | run_fail | deferred |
| `tests/todo/generic/pdp10/loop-2b.c` | compiled | pass | active |
| `tests/todo/generic/pdp10/strct-stdarg-1.c` | compiled | pass | active |
| `tests/todo/generic/pdp10/strct-varg-1.c` | compile_fail | not run | deferred |
| `tests/todo/generic/pdp10/strct-varg-1b.c` | compiled | run_fail | deferred |
| `tests/todo/generic/pdp10/tmp.c` | compiled | pass | active |
| `tests/todo/generic/pdp10/va-arg-1.c` | compiled | pass | active |
| `tests/todo/generic/pdp10/va-arg-10.c` | compile_fail | not run | deferred |
| `tests/todo/generic/pdp10/va-arg-19.c` | compile_fail | not run | deferred |
| `tests/todo/generic/pdp10/va-arg-2.c` | compile_fail | not run | deferred |
| `tests/todo/generic/pdp10/va-arg-22.c` | compile_fail | not run | deferred |
| `tests/todo/generic/pdp10/va-arg-3.c` | compile_fail | not run | deferred |
| `tests/todo/generic/pdp10/va-arg-4.c` | compiled | pass | active |
| `tests/todo/generic/pdp10/va-arg-5.c` | compiled | pass | active |
| `tests/todo/generic/pdp10/va-arg-6.c` | compiled | pass | active |
| `tests/todo/generic/pdp10/va-arg-7.c` | compile_fail | not run | deferred |
| `tests/todo/generic/pdp10/va-arg-8.c` | compile_fail | not run | deferred |
| `tests/todo/generic/pdp10/va-arg-9.c` | compile_fail | not run | deferred |
| `tests/todo/generic/wide-int/strcmp-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/varargs/strct-stdarg-1.c` | compiled | pass | active |
| `tests/todo/generic/varargs/strct-varg-1.c` | compile_fail | not run | deferred |
| `tests/todo/generic/wide-int/strlen-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/wide-int/strncmp-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/generic/struct-ret-1.c` | compiled | run_fail | deferred |
| `tests/todo/generic/varargs/va-arg-1.c` | compiled | pass | active |
| `tests/todo/generic/varargs/va-arg-10.c` | compile_fail | not run | deferred |
| `tests/todo/generic/varargs/va-arg-11.c` | compiled | pass | active |
| `tests/todo/generic/varargs/va-arg-12.c` | compiled | pass | active |
| `tests/todo/generic/varargs/va-arg-13.c` | compiled | pass | active |
| `tests/todo/generic/varargs/va-arg-14.c` | compiled | pass | active |
| `tests/todo/generic/varargs/va-arg-15.c` | compile_fail | not run | deferred |
| `tests/todo/generic/varargs/va-arg-16.c` | compile_fail | not run | deferred |
| `tests/todo/generic/varargs/va-arg-17.c` | compile_fail | not run | deferred |
| `tests/todo/generic/varargs/va-arg-18.c` | compiled | pass | active |
| `tests/todo/generic/varargs/va-arg-19.c` | compile_fail | not run | deferred |
| `tests/todo/generic/varargs/va-arg-2.c` | compile_fail | not run | deferred |
| `tests/todo/generic/varargs/va-arg-20.c` | compiled | pass | active |
| `tests/todo/generic/varargs/va-arg-22.c` | compile_fail | not run | deferred |
| `tests/todo/generic/varargs/va-arg-3.c` | compile_fail | not run | deferred |
| `tests/todo/generic/varargs/va-arg-4.c` | compiled | pass | active |
| `tests/todo/generic/varargs/va-arg-5.c` | compiled | pass | active |
| `tests/todo/generic/varargs/va-arg-6.c` | compiled | pass | active |
| `tests/todo/generic/varargs/va-arg-7.c` | compile_fail | not run | deferred |
| `tests/todo/generic/varargs/va-arg-8.c` | compile_fail | not run | deferred |
| `tests/todo/generic/varargs/va-arg-9.c` | compile_fail | not run | deferred |
| `tests/todo/generic/generic/widechar-2.c` | compile_fail | not run | deferred |

## Follow-up

- Correct missing or incomplete `stdbool.h`, `math.h`, historical `varargs.h` where justified by supported dialects.
- Link real libc functions (`memcpy`, `memset`, `strcmp`, `printf`, `sprintf`, `malloc`, etc.) into the bare-metal harness and rerun.
- Investigate `loop-3c.c` and `920501-6.c` execution failures as separate semantic issues.
- Review `inst-check.c` for deletion: successful execution has no meaningful checked result.
- Preserve other failed sources and their original classification until the root cause is established.

Updated manifest: {'active': 423, 'removed': 55, 'review-extension': 129, 'review-width': 56, 'deferred': 111}
