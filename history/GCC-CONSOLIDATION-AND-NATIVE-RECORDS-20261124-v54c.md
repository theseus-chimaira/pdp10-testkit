# GCC consolidation and native record array repair v54b/v54c

GCC master fast-forwarded from 4a71edc to e64cb87, preserving all 20
repair commits. Every local and remote repair branch tip matched and
was an ancestor of master. After the remote master push, the 20
redundant repair branches were deleted locally and remotely; exact
commit IDs are in PDP10-GCC-CONSOLIDATED-BRANCHES-20261124-v54a.tsv.
No history was rewritten. Staged compiler v53b was used for the fresh
264-cell replay, which reproduced all six historical source failures.

## Native record scalar references

Master 6716c5b separates dynamic physical word displacements from
constant field bit positions in native record array references.
Previously a word-stride index could pass through byte-pointer
adjustment using a selected field's byte size. The new path uses
front-end layout positions and physical scalar slices; packed,
non-word-stride, volatile and extended-address paths are not changed.
Both historical byteptr2 sources pass 44/44 each. New signed/unsigned
static and automatic array regression passes 44/44. All 394 distinct
previous exact-width target/guard cells pass. Staged cc1 SHA256:
80c73294ab96a3f2ab5bd5819370adc0af5bec4504ca03869c7045ffe9f4177c.

Object word counts summed over 44 configurations each:
global zero extraction 9302 -> 4047, structure array scale 17394 -> 7313.
All 88 repaired objects shrink. Baseline objects failed correctness;
these comparisons are size evidence only, not speed benchmarks.

## Test oracle correction

Testkit 0f73d90 fixes the plain-char expectations in the argument and
return matrices. GCC DEFAULT_SIGNED_CHAR is zero and its preprocessor
defines __CHAR_UNSIGNED__ by default (absent under -fsigned-char).
The former KCC-only branch already had the correct unsigned values.
The corrected expectations pass 88/88 on unchanged v53b. These are
oracle corrections, not compiler repairs; the old and corrected source
hashes and results are recorded separately. The new native-record
regression independently exercises explicitly signed char and short.

## Outstanding

2399 -> 2223 historical cells, 89 -> 85 sources: 88 compiler recoveries
and 88 oracle recoveries. No other historical keys are removed. Fresh
v54b replay of cross-word pre/postincrement and switch byte-pointer
sources still fails 88/88. Examine the old pointer-difference path
(pair multiplication/table correction) and the folded integer sum
path, including its optimization-level-specific raw pointer subtraction.
No full sweep, extended-address acceptance, calibrated speed or native
RAM measurement, or production installation claimed.
