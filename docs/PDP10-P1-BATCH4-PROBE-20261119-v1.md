# P1 Batch 4 deferred test runnable probe v1

Date: 2026-11-19. The ten original sources remain byte-identical.
The frozen source SHA256s were verified before execution.

Nine C sources were run with the existing bare-metal semantic runner, actual installed compiler/runtime and PDP-6 simulator at KCC noopt and GCC O0. The KL10 assembly fixture requires a dedicated ISA harness and was not misclassified as a C compilation failure.

Of 18 real C cells: **2 PASS, 8 runtime failures, 4 link failures, 4 compile failures**. A PASS here is a runner result, not independent proof that the original test has a nonvacuous assertion.

| Original source | KCC PDP-6 noopt | GCC PDP-6 O0 |
| --- | --- | --- |
| `tests/semantic/upstream/extensions/builtin-prefetch-6.c` | link_fail | pass |
| `tests/semantic/upstream/extensions/20010518-2.c` | run_fail | run_fail |
| `tests/todo/generic/991112-1.c` | link_fail | link_fail |
| `tests/semantic/upstream/pdp10/pdp10/conversion.c` | run_fail | link_fail |
| `tests/todo/generic/20020412-1.c` | compile_fail | run_fail |
| `tests/todo/generic/920501-8.c` | run_fail | compile_fail |
| `tests/todo/generic/920726-1.c` | pass | compile_fail |
| `tests/semantic/upstream/support/920428-1.s` | ISA harness required | ISA harness required |
| `tests/todo/generic/20020406-1.c` | run_fail | run_fail |
| `tests/todo/generic/920810-1.c` | run_fail | compile_fail |

All nonpassing cases remain unresolved. In particular, `920726-1.c` has a real string comparison and passes KCC, but GCC cannot compile the original; `builtin-prefetch-6.c` runs on GCC, while its source uses an 8-bit-byte width assumption and needs a separately justified PDP-10 width oracle before semantic closure. No hosted libc stubs, test edits or compiler repairs were made.

Reproduce: `python3 tools/run-p1-batch4-deferred-v1.py --outdir "$TMPDIR/p10tk-batch4-rerun-v1" --compiler all`. The command writes detailed cell logs and a TSV into its output directory.
