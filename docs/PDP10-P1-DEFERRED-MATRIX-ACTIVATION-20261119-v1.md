# P1 deferred C matrix activation v1

The 29 unresolved P1 upstream sources comprise 28 C sources and one
KL10 assembly fixture (`tests/semantic/upstream/support/920428-1.s`).
All 28 C sources now have active `semantic` entries in `COMPILER_MATRIX.tsv`
for the original native PDP-6 KCC noopt and GCC O0 profiles: **56 cells**.
A compiler failure remains a visible failing cell in the normal sweep;
it is not a reason to remove the test. No compiler fixes or source edits
are part of this activation.

Only the two already-probed native PDP-6 profiles are activated. Untested
architectures/optimization levels remain `no_test` until target selection
and harness compatibility are established. This is not a claim that all
28 sources pass or that their P1 semantic obligations are closed.

The assembler fixture requires a KL10 ISA harness and cannot be
registered as a C semantic test without misrepresenting its execution.
The existing original-source resolution TSV is retained as the historical
P1 semantic closure record; matrix activation and semantic closure differ.

To verify a cell is scheduled:

```
python3 tools/run-tests.py --compiler gcc --family native --cpu pdp6 \
  --opt o0 --kind semantic --source tests/todo/generic/990628-1.c --list-only
```

Reapply/check source admission deterministically with
`python3 tools/admit-p1-deferred-matrix-v1.py`.
