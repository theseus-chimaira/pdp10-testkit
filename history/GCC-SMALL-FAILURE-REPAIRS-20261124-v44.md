# GCC small failure groups v44

Staged GCC 994fef8 (repair/wide-narrow-v43b) is based on 031915c.
Hosted cc1 SHA256:
bf41d3b86a0c408f6d08d05408f45045e55d6e782b706965dfee8b621cd130cc.

The exact 31-cell recheck passed 11 wide-to-narrow and four alias
cells. Sixteen word arithmetic cells still failed because the tests
selected 32-bit reference constants on PDP-6 and KS10. Use generic
PDP-10 target detection in the three related arithmetic tests and
retain independent target-width constants. All 198 corresponding
GCC/KCC cells passed (132 GCC, 66 KCC). All 31 historical cells now
pass on the staged candidate and adapted sources.

Weak-alias test success verifies resolution of the alias, not true
weak linkage: the compiler still explicitly warns it is unsupported.
No weak-symbol facility was added. No full sweep or GCC installation.
The remaining exact-type cohort has 176 freshly reproduced failures
after the eleven wide-to-narrow recoveries. Previous broad candidate
acceptance remains incomplete.
