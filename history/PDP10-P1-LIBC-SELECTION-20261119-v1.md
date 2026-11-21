# P1 semantic runner freestanding libc selection (2026-11-19, v1)

The normal semantic runner previously embedded symbol-to-assembly-member
selection and the memmove -> memcpy dependency directly inside its
per-cell execution path. The mapping is now isolated in
`tools/freestanding_selection_v1.py`, with eleven deterministic
host-only controls in `tools/test-freestanding-selection-v1.py`.

The selector recognizes direct PUSHJ calls, JRST tail calls and .extern
references, omits definitions already supplied by the test, and adds
transitive memcpy when selecting memmove. It selects one shared source
for string-family calls and separate members for search operations to
avoid unnecessary RAM consumption. The PDP-6 software D-format helper
is not silently selected for other CPUs. Unavailable hosted symbols,
such as malloc, are not substituted with fabricated implementations.

Registered special test: `freestanding-selection-v1` (host-only).

Narrow operational validation (not a broad sweep):

- KCC PDP-6 noopt `tests/semantic/kcc-libc-freestanding-v1.c`: PASS.
- GCC PDP-6 O0 `tests/todo/generic/generic/string-opt-13.c`: PASS.
- Source inventory and script ownership audits: PASS.

The normal semantic runner still uses installed source fragments with
p10run, not the production DARC archive. The separate installed archive
extraction regression remains registered and PASS, as documented in
`history/PDP10-P1-LIBC-VERIFICATION-20261119-v1.md`.

Next: audit actual installed member exports and references against this
mapping, then establish explicit hosted/varargs/runtime-helper policies.
