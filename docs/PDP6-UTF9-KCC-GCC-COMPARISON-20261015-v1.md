# UTF-9 PDP-6 opcode profile comparison (2026-10-15, v1)

Repeated the **same** `utf9-codec-pdp6-v2.c` benchmark with the same
instrumented PDP-6 SIMH and `p10run --opcode-profile`, changing only the
compiler of both translation units. Both runs returned `__test_exit=0`.

| Metric | KCC | GCC `-O0` |
| --- | ---: | ---: |
| Executed opcode dispatches | 5,460,462 | 5,460,939 |
| Codec object text (36-bit words) | 588 | 560 |
| Test object text (36-bit words) | 229 | 222 |

KCC dispatched **477 fewer instructions** (0.0087%), but produced a codec
28 words larger than GCC `-O0` (+5%). Neither result establishes a faster
compiler: the workload includes startup, test logic and codec, and the
instruction mix differs between compilers.

## Timing caveat

The reporter `tools/report-pdp6-opcodes-v1.py` currently contains provisional
*instruction-class timing assumptions*, not an audited per-opcode PDP-6
instruction timing table. Its previous 9.83–15.84 second partial sum
must **not** be interpreted as a validated PDP-6 performance figure.

The brochure `F-61_PDP-6_Brochure_196402.pdf` describes timing dependency
on core-memory configuration and access overlap, and its instruction-category
overview is not a sufficiently detailed opcode timing schedule. Before
publishing weighted totals, extract and verify timings for `AOBJN` (253),
`JRST` (254), `ADDI` (271), `ADDM` (272), and the remaining decoded opcodes
from a genuine PDP-6 instruction-timing source, including conditional cases.

The measured per-opcode histogram is reliable within the simulator's
dispatch-count semantics. Dynamic instruction timing remains unresolved.
