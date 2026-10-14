# Width classification: eight tests, 2026-10-14 (v4)

This batch applies the TODO policy: retain the original regression, permit
only minimal PDP-10 changes, and defer non-ICE compiler/runtime failures.
All executions below used the installed `$HOME/cross` toolchain and PDP-6.
Only KCC and GCC `-O0` results listed as PASS were executed; other matrix
cells remain unverified.

| Test | Result | Disposition |
| --- | --- | --- |
| `20000227-1.c` | Raw source `0xff` differs from escaped `0377`; original KCC run aborts | Deferred; source encoding needs policy |
| `20000403-1.c` | `sizeof(long)*CHAR_BIT` correction; KCC and GCC pass | Active; moved to semantic upstream generic |
| `20001009-1.c` | Existing PDP-10 branch for 9-bit char; earlier KCC run aborts | Deferred; do not debug now |
| `20010325-1.c` | Wide string concatenation rejected by KCC parser (ordinary rejection) | Deferred; feature investigation later |
| `20011008-3.c` | Prior runtime abort with large local arrays | Deferred; non-obvious runtime issue |
| `20020216-1.c` | PDP-10 XOR expectation preserved; KCC and GCC pass | Active |
| `20020219-1.c` | Meaningful 63-bit shift on 72-bit integer; KCC returns failure | Deferred; possible non-ICE compiler defect |
| `20020402-3.c` | One-line assertion checks returned blockvector; GCC passes, KCC returns failure | Deferred; no compiler investigation |

Neither deferred compiler failure was masked or counted as a semantic pass.
The assertion in `20020402-3.c` makes the previously discarded return value
observable without changing the tested search routine. It remains inactive.
The KCC wide-string rejection has not been identified as an ICE.

The earlier `SEMANTIC-WIDTH-CLASSIFICATION-20261014-v3.md` records historical
setup failures before the installation of the complete `$HOME/cross`
toolchain. The current KCC headers, assembler, GCC and simulators are now
installed; the two active sources passed genuine PDP-6 execution.
