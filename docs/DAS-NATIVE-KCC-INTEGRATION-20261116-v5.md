# Native DAS on DAIMOS: end-to-end acceptance (2026-11-16 v5)

## Result

**PASS** on the original PDP-6 DAIMOS guest with the corrected D6FS
allocator bound. The testkit's `misc/das/build-das-native-phases.sh`
builds the native driver, DAS1 and DAS2, verifies their size gates,
boots a fresh D6FS image, invokes DAS, compares the complete six-word
DXR output with the expected image, and executes that DXR under DAIMOS.
The native target reports `DAS NATIVE PASS`; the top-level shell runner
reports `native DAS invocation/assembly/execution contract passed`.

The native comment-stripper remains **68/68** instructions, and the
separate line reader **133/136**. DAS2's relocation bitmap is still
scratch-backed; no new native DAS RAM was allocated to fix the guest.
The successful build uses DAS `6dfb707` and KCC `22aedc8`.

## Kernel defect and investigation

The original guest had `/TEMP` mode `01777`, writable-root FSINFO flags
zero and could open an existing source file for writing. It could also
successfully perform `chmod` on that file, confirming that basic D6FS
metadata commits were available. Both regular-file CREATE and MKDIR
failed, however.

Temporary, subsequently removed stage-return diagnostics traced MKDIR
to `d6fs_provider_free_fcb`. The image builder reported 295 populated
nodes in a 360-FCB table. The allocator incorrectly used reader offset
`011` (`super_block[0]`, a filesystem block location) as its scan limit,
instead of offset `6` (`fcb_count`). In a separate diagnostic build,
selecting an actually free high-numbered FCB directly allowed MKDIR
to succeed, proving the inability to find one was in the scan policy.

The accepted resident kernel change replaces the upper-bound operand:

    caml    011,6(5)         ; bound by reader->fcb_count

It replaces one operand in one instruction, adds **no instructions or
permanent data words**, and preserves FCB zero as reserved.

## Independent verification and scope

`daimos-testkit` adds `target-d6fs-free-fcb-pdp6-v1`, a real original
PDP-6 execution of the production allocator with a controlled FCB
reader. It verifies first-free selection, both too-small and too-large
superblock-location values, no scan beyond `fcb_count`, and an empty
FCB table. The test passes with the corrected source.
Reintroducing the original superblock-bound instruction in an isolated
copy makes the test fail with result 1, confirming that this regression
rejects the actual defect.

The final full guest run repeats the original scan from FCB index 1,
without any diagnostic bypasses. It successfully performs the CHMOD,
MKDIR/RMDIR, short CREATE/unlink, scratch CREATE/unlink, native DAS1
and DAS2 execution, output comparison and executable DXR invocation.
No D6FS format change, additional cache, FCB-table increase or
special-case DAS workaround is involved.

This regression fixes allocator bounds; it does **not** close the
separate D6FS crash-atomic CREATE/recovery work item documented in
`system/kernel/fs/D6FS-CREATE-RECOVERY-DESIGN-20261012-V1.MD`.
Earlier v1/v2/v3 diagnostics remain historical and must not be used
as a claim about the now-accepted guest.
