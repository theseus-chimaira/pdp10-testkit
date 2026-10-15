# UTF-9 PDP-6 object-size measurements (2026-10-15, v1)

The production `pdp10-tools/utf9-codec-v1.c` and the freestanding boundary
test `tests/semantic/utf9-codec-pdp6-v2.c` were compiled to PDP-6 assembly
with installed GCC `-std=c99 -O0` and KCC `-x=pdp6`, then assembled by the
normal `p10run` multi-object test harness. All four codec-test combinations
in the registered runner passed on PDP-6.

`pdp10-dec-none-objdump -h` reports these **actual PDP-10 object section
word counts**, rather than source/assembly line counts:

| Object | GCC -O0 text | KCC text | Data | BSS |
| --- | ---: | ---: | ---: | ---: |
| UTF-9 codec | 560 | 588 | 0 | 0 |
| UTF-9 boundary test v2 | 222 | 229 | 0 | 0 |
| Combined objects | 782 | 817 | 0 | 0 |

The codec differs by 28 text words between these two compiler profiles;
these figures **exclude** CRT, termination support, linker/assembler-added
material and any runtime support. They are not total linked footprints,
peak physical memory requirements, or execution instruction counts.

The current `p10run` report logs SIMH output and pass/fail results, but
does not expose an independently verified executed-instruction counter or
peak-RAM statistic. The configured step limit is a ceiling, not a count.
No instruction-count or peak-RAM claim is made pending supported
instrumentation. No code optimization was performed based on incomplete
performance evidence.
