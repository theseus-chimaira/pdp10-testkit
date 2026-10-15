# UTF-9 PDP-6 runtime integration (2026-10-15, v1)

`SPECIAL_TESTS.tsv` registers `utf9-pdp6-runtime-v1` under the `compat`
group. It invokes `misc/compat/test-utf9-pdp6-runtime-v1.sh`, which builds
the production `pdp10-tools/utf9-codec-v1.c` as a distinct translation unit
from each of the UTF-9 v1 and v2 tests, links through `p10run`, and executes
on PDP-6. Both KCC and GCC `-O0` pass both tests (four runs total).

The ordinary semantic matrix currently compiles a single test source,
so adding the dependent tests there without library linkage would
misreport missing codec symbols. A dedicated registered multi-unit test
avoids false failures while preserving the actual production codec.

An exploratory generated-assembly check produced 623 lines for GCC `-O0`
and 642 lines for KCC. **Assembly line count is not machine-word code size**
and should not be used as an optimization metric. No defensible peak memory
or instruction count measurements were obtained from this test run;
those metrics remain pending a verified simulator/linker report interface.

Native filesystem text remains SIXBIT/S6REC; the codec is an optional
Unicode runtime/interchange component.
