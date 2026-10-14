# KCC extension support policy (2026-10-14, v1)

These are project decisions, not deductions from individual upstream GCC
test failures. An unsupported feature may be tested on GCC, but is not a
KCC implementation obligation. Classification must distinguish compiler
extensions from the shared assembler libc and from test-harness linkage.

| Feature | Policy | Notes |
| --- | --- | --- |
| GNU nested functions | **Unsupported; no KCC port planned** | Includes lexical captures |
| Nested-function trampolines | **Unsupported; no KCC port planned** | No trampoline ABI required |
| GNU computed goto (`&&label`, `goto *p`) | **Planned** | Add to KCC TODO; not implemented yet |
| GNU local labels (`__label__`) | **Unsupported** | No KCC port planned |
| Nonstandard bitfield base types | **Under consideration** | Do not rewrite upstream expectations merely to pass |
| GNU complex (`_Complex`, `__complex__`) | **Unsupported** | No complex support planned |
| Zero-length arrays | **Under consideration** | Separate from standard flexible array members |
| Integer-to-union cast | **Unsupported** | GNU extension |
| String/memory `__builtin_*` calls | **Shared assembler libc is preferred** | Ordinary functions exist; direct built-in name lowering may still be absent; avoid duplicated implementations |
| `__builtin_constant_p` | **Undecided** | Evaluate usefulness separately |
| `__builtin_types_compatible_p` | **Undecided** | Compiler-only predicate |
| `__builtin_prefetch` | **Unsupported** | No PDP-6 cache-prefetch objective |
| `__builtin_return_address` | **Undecided** | ABI and frame implications |
| `__builtin_setjmp` / `__builtin_longjmp` | **Undecided** | Consider for later PDP-10 generations |
| `__builtin_alloca` | **Undecided** | Stack allocation and ABI implications |

No compiler work is authorized by this table during upstream semantic
classification. A deferred test need not imply an eventual KCC feature.
