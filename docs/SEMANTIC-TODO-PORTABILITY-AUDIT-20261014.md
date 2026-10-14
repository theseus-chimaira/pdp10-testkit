# Semantic upstream todo portability review (2026-10-14)

Reviewed the 773 C sources in `tests/todo/semantic-upstream-gcc/torture-execute/` for explicit inline assembler, host-OS headers and kernel interfaces. These are unregistered upstream execution tests; no compiler-matrix entries were added.

Removed **16** tests with explicit host assembler/OS dependencies:

- `20001009-2.c`
- `20001229-1.c`
- `20010724-1.c`
- `20020107-1.c`
- `960312-1.c`
- `960830-1.c`
- `990130-1.c`
- `990413-2.c`
- `boot.c`
- `ieee/20000320-1.c`
- `ieee/fp-cmp-1.c`
- `ieee/fp-cmp-2.c`
- `ieee/fp-cmp-3.c`
- `loop-2e.c`
- `loop-2f.c`
- `loop-2g.c`

The remaining 757 tests are still awaiting a semantic suitability review and matrix integration. Architecture conditionals without an unconditional architecture-specific dependency were not automatically discarded, and portability has **not** been certified by execution.
