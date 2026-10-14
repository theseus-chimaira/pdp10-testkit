# KCC P0 parser diagnostics, 2026-10-14 (v1)

KCC fixes for the four existing imported GCC noncompile tests are implemented
in `ccdecl.c`. No upstream tests were rewritten. All four now issue ordinary
diagnostics with the locally rebuilt host KCC targeting PDP-6.

| Source | Original problem | Corrected behavior |
| --- | --- | --- |
| `init-2.c` | `pushsztype: bad top type 13` ICE after illegal `d[][]` | Preserve the derived array type chain during error recovery; reject incomplete inner dimension |
| `init-3.c` | `vlabindtype_v11: missing metadata` ICE after undefined `BAR` | Reject erroneous bound expressions before creating VLA metadata |
| `920824-1.c` | Nested redefinition of active `struct s` accepted | Diagnose the nested tag redefinition; keep incomplete tag references legal |
| `voidparam-1.c` | Qualified and `register void` parameters accepted | Diagnose these; retain legal unqualified `(void)` |

`misc/validation/test-kcc-p0-diagnostics-v1.sh` verifies each rejection
contains a normal KCC error summary and no `[Internal error]`, and compiles
legal self-referential structs, nested different tags, and `(void)` parameters.
Run using `KCC_REPO=/path/to/kcc sh misc/validation/test-kcc-p0-diagnostics-v1.sh`.

The check passed against the freshly rebuilt KCC on PDP-6. The full
CPU/optimization/compiler sweep remains open in `TODO.md`.
