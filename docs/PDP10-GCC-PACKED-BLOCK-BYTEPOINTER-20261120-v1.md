# GCC PDP-10 packed block-copy byte-pointer stage (2026-11-20, v1)

Scope: an isolated GCC 3.2 PDP-10 backend correction, verified on PDP-6
with GCC O0, O1, O2 and Os. This is not a claim that the full original upstream source
20010518-2.c passes, or that the staged compiler has been installed.
The broad compiler matrix remains deferred.

The original packed aggregate assignment uses an inline 16-byte LDB/DPB
copy. Before this change the GCC backend passed ordinary PDP-10 word
addresses as source and destination. LDB and DPB require P,S-encoded
9-bit byte pointers, so the source and destination were incorrect.

The GCC backend now forms a genuine local 9-bit byte pointer for a
BLKmode byte copy. Already-encoded byte pointers keep their P,S selector.
For ordinary word addresses the backend installs the initial POINT 9
selector. Known constant-pool labels and direct stack-frame addresses
avoid the runtime selector check, reducing emitted instructions.

The independent C89-compatible (except for the GNU packed attribute)
regression checks an ordinary stack record and a nested packed record,
the latter guarding against loss of an existing non-default P,S
selector. Its source is:

    tests/semantic/validation-gcc/gcc-packed-block-bytepointer-v1.c

It is owned by the registered manual test:

    misc/validation/test-gcc-packed-block-bytepointer-v1.sh

Comparison with the same installed assembler, linker, CRT and p10run:

| GCC compiler | PDP-6 native results |
| --- | --- |
| Currently installed GCC | O0 FAIL: __test_exit=1 |
| Staged patched GCC cc1 | O0/O1/O2/Os PASS: __test_exit=0 |

The staged compiler can be selected manually without changing the
installed toolchain or semantic runner:

    P10TK_GCC_CC1_DIR="$TMPDIR/p10-gcc-packed-aggregate-build-v1/gcc" \
      sh misc/validation/test-gcc-packed-block-bytepointer-v1.sh

The original upstream 20010518-2.c still fails after the byte-copy fix.
Its field-specific diagnostic now reaches field c (exit 13) instead of
failing field a (exit 11). A stage-observation diagnostic finds a=1
and b=2 but c=0 and d=0, already before the explicit memcpy calls.
The GCC translation-unit dump records c at bit offset 54 and d at
bit offset 72, but RTL expansion loads the corresponding fragments
from incompatible offsets. This is an independent compiler scalar
extraction defect. KCC's packed initialization also remains unresolved.

The staged compiler was rebuilt in a versioned scratch directory;
host-only generated config was adjusted for the Android compiler.
No upstream test source was changed or weakened. The new regression
remains manual until patched compiler installation and broader targeted
checks; no blanket GCC success is inferred.
