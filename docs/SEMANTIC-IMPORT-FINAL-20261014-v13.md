# Final upstream semantic candidate import (2026-10-14, v13)

All 18 remaining candidate sources compiled with PDP-6 KCC and, where compilation succeeded, executed with the testkit bare-metal termination contract. No test body or compiler code was modified.

| Original source | Observation | Classification |
| --- | --- | --- |
| `tests/semantic/upstream/varargs/va-arg-16.c` | "va-arg-16.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-16.c", line 8: No type-specifier for parameter decl, assuming int | deferred |
| `tests/semantic/upstream/varargs/va-arg-17.c` | "va-arg-17.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-17.c", line 8: No type-specifier for parameter decl, assuming int | deferred |
| `tests/semantic/upstream/varargs/va-arg-18.c` | "va-arg-18.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-18.c", line 6: Undefined identifier: "va_list" | deferred |
| `tests/semantic/upstream/varargs/va-arg-19.c` | "va-arg-19.c", line 10: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-19.c", line 15: No type-specifier for parameter decl, assuming int | deferred |
| `tests/semantic/upstream/varargs/va-arg-2.c` | "va-arg-2.c", line 8: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-2.c", line 8: Expected token (semicolon) not found | deferred |
| `tests/semantic/upstream/varargs/va-arg-20.c` | "va-arg-20.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-20.c", line 3: Bad syntax in function parameter list | deferred |
| `tests/semantic/upstream/varargs/va-arg-22.c` | "va-arg-22.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-22.c", line 24: array dimension const must be > zero | deferred |
| `tests/semantic/upstream/varargs/va-arg-3.c` | "va-arg-3.c", line 16: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-3.c", line 16: Expected token (semicolon) not found | deferred |
| `tests/semantic/upstream/varargs/va-arg-4.c` | "va-arg-4.c", line 6: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-4.c", line 14: Undefined identifier: "va_list" | deferred |
| `tests/semantic/upstream/varargs/va-arg-5.c` | "va-arg-5.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-5.c", line 5: Undefined identifier: "va_list" | deferred |
| `tests/semantic/upstream/varargs/va-arg-6.c` | "va-arg-6.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-6.c", line 5: Undefined identifier: "va_list" | deferred |
| `tests/semantic/upstream/varargs/va-arg-7.c` | "va-arg-7.c", line 5: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-7.c", line 10: No type-specifier for parameter decl, assuming int | deferred |
| `tests/semantic/upstream/varargs/va-arg-8.c` | "va-arg-8.c", line 4: Can't open include file, last tried "/usr/local/lib/kcc/include/varargs.h"; "va-arg-8.c", line 6: Can't open include file, last tried "/usr/local/lib/kcc/include/limits.h" | deferred |
| `tests/semantic/upstream/varargs/va-arg-9.c` | "va-arg-9.c", line 6: Can't open include file, last tried "/usr/local/lib/kcc/include/stdarg.h"; "va-arg-9.c", line 6: Expected token (semicolon) not found | deferred |
| `tests/semantic/upstream/generic/wchar_t-1.c` | "wchar_t-1.c", line 1: Expected token (semicolon) not found; "wchar_t-1.c", line 2: Declaration without storage class or type-spec | deferred |
| `tests/semantic/upstream/generic/widechar-1.c` | PASS; executable preprocessor assertion | active |
| `tests/semantic/upstream/generic/widechar-2.c` | "widechar-2.c", line 3: Can't open include file, last tried "/usr/local/lib/kcc/include/stddef.h"; "widechar-2.c", line 3: Expected token (semicolon) not found | deferred |
| `tests/semantic/upstream/generic/zerolen-1.c` | "zerolen-1.c", line 8: array dimension const must be > zero; ? KCC - 1 error detected | review-extension |

## Result

One meaningful PASS activated; 17 compile failures retained unchanged under `tests/todo/generic/`. Initial candidate queue exhausted. Follow-up reviews and other matrix profiles remain open.

{'active': 379, 'removed': 55, 'review-extension': 129, 'review-width': 56, 'deferred': 155}
