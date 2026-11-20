# P1 semantic resolution v10: invalid-address prefetch closed

This is the latest live resolution ledger for all 67 historical
original P1 obligations. One source changes state compared with v9:

* `builtin-prefetch-6.c`: **partial to covered**, on the strength of
  a freestanding 36-bit-native test with 65 read and 65 write hints
  and four SHA-pinned PDP-6 GCC PASS reports. This is testkit
  semantic coverage, not proof of compiler compatibility on all
  targets or actual prefetch hardware.

The current count is **39 covered, 0 partial, 28 blocked**.
The source's original SHA256 and all other 66 source classifications
remain unchanged. The file
`PDP10-P1-SEMANTIC-RESOLUTION-20261120-v10.tsv` is generated
and independently checked by
`tools/build-p1-semantic-resolution-v10.py`.
See `PDP10-P1-PREFETCH-INVALID-CLOSURE-20261120-v1.md`
for executable evidence and its narrow qualification.
