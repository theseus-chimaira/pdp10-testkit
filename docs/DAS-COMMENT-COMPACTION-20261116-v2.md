# Native DAS comment-scanner compaction (2026-11-16 v2)

## Original and new measured machine code

The original DAS `a956d0c` code generated **94** PDP-6 instructions for
`das_strip_c_comments` with installed KCC `dfad3b9` (`-Pgnu99 -O -x=pdp6
-m=gas`). The compact scanner in DAS `c0d6002` generates **72** instructions,
a saving of **22 instructions / 23.4%** within the function. The separately
checked `das_read_line` is unchanged at **133** instructions. These are
function-level assembler counts, not linked image size or runtime timings.

The testkit's original limits remain **68** instructions for
`das_strip_c_comments` and **136** for `das_read_line`. Thus the native
comment-scanner gate is still **FAIL (72 > 68)**. No waiver, bypass, or
claim of full native DAIMOS guest acceptance accompanies the reduction.

## Algorithm and tests

The scanner now loads each source byte once, maintains one input pointer,
and has one output-byte store in the loop. Signed quote state uses positive
quote delimiters, their negative counterparts to consume one escaped byte,
and zero outside quotes. Only the existing block-comment bit persists
between input lines. No buffer-underflow pointer or separate native-only
algorithm was introduced.

The previously uninitialized `reader.cstate` field in five input-reader
test fixtures is now explicitly set to zero. Relying on an uninitialized
reader state is undefined behavior; the first compact-source full run
correctly exposed that defect, which was fixed before acceptance.

The expanded `das-native-comments-selftest.c` checks escaped single and
double quotes, consecutive comments, and multiline comment reentry and
closure. Both original DAS source and the compact scanner pass that
identical host fixture. The complete current independent DAS suite passes:
eight `fast` entries and two additional `full` entries. Its 120,000-word,
12,000-symbol, and 2,500-literal stream stress remains within the measured
10,335-word peak working set.

## Still required

Find and verify a further **four-instruction** reduction in the native
scanner while preserving behavior, or correct a demonstrated KCC codegen
inefficiency with its own independent tests. The backend has a special
`IDPB` optimization for pre-increment byte stores, but constructing a
pointer before the buffer merely to trigger it is not a valid solution.
Rebuild and measure the complete resident phase images and perform actual
native DAIMOS guest assembly/execute acceptance after the size gate passes.

The preceding `DAS-REGISTRY-INTEGRATION-20261116-v1.md` is an immutable
historical record of the initial 94-instruction failure, not an updated
measurement of the compact source.
