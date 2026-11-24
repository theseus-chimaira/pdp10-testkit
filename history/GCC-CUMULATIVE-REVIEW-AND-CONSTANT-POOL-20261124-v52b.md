# GCC cumulative review and constant-pool repair v52b

Master 4a71edc; review base e7cf4fa contains 17 commits affecting eight
files (+1364/-157 lines). The existing checkout already matched that
review tree before the new edit, despite master remaining checked out.
Preserve its index and unrelated untracked testkit manifests.

## Source review

The staged series covers packed expansion, integer initialization,
logical/native pointer selection, exact-width arithmetic, dynamic
aggregate offsets, constant string decoding, D-format conversions,
and aligned/literal memcpy. The diagnostic v41c is part of the
cumulative series, not an independent proven repair. Full aggregate
snapshots can consume target stack space. Dynamic exact16/32 pointer
dispatch increases instruction and register demand. Volatile packed
references and extended addresses require dedicated guards. Do not
infer global ABI acceptance from the exact-type cohort alone.

## Evidence and repair

The v51d driver selects a separate cc1 through -B; SHA256
00f8536d86ea9f5f28b9bbc3e416f71e580db78d191b099b0152d4d320cad339.
121 selected historic cells: 39 PASS, 82 run_fail. All 27 freestanding
libc and 12 strcmp cells pass. Sixteen fixed initializer and 66 aligned
memset/memcpy cells still fail. The latter have partial-word lowering
through plain word addresses; no repair claimed here.

Fixed initializer emitted a label in text, switched to data, then
flushed the string word. The linked pointer referred to 001007 (code),
not 001070 (string). The v52b compiler finishes buffered constant-pool
objects before returning from output_constant_def_contents, without
flushing nested constructors. Seven added source lines in varasm.c.
Review commit ea38970; cc1 SHA256
14f2e5faadf8dec67c0a309a3b60112c1b292051f0c207f3826e59a4d0623832.
16/16 original runtime cells pass. Related guards: 164 PASS, 36
compile_only, zero failures. Original 20010924-1.c: 44/44 PASS.

The exact v28 historical keys reconcile from 2520 to 2465 (91 sources).
39 historical passes were newly accounted for on v51d, including 12
already passing in v46; 16 additional cells pass with the new repair.
No compile-only result was counted. See versioned v52a/v52b result,
recovery, and remaining manifests. The remaining manifest preserves
historic statuses, not fresh failures on v52b. No full sweep, merge,
installation, native memory or extended-address acceptance claimed.
