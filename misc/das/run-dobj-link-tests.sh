#!/bin/sh
set -eu

DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to DAS source tree}
DAS=$DAS_ROOT/das
DARC=$PDP10_PREFIX/bin/darc
DLINK=$PDP10_PREFIX/bin/dlink
DXRCHECK=$DAS_ROOT/dxrcheck
OBJDUMP=$PDP10_PREFIX/bin/pdp10-objdump
TMPBASE=${TMPDIR:-.}
WORK=$(mktemp -d "$TMPBASE/das-dobj-test.XXXXXX")
trap 'rm -rf "$WORK"' EXIT HUP INT TERM

make -C "$DAS_ROOT" all >/dev/null

# DARC is the target archive format.  Host ar/ranlib compatibility aliases are
# intentionally absent; DARC carries its own symbol index.
test -x "$PDP10_PREFIX/bin/pdp10-dec-none-darc"

cat > "$WORK/main.s" <<'EOS'
.text
.globl start
.entry start
start:
        move 1,local
        pushj 17,helper
        move 2,datum
        move 3,buffer
local:
        .word 0123456
.data
.globl datum
datum:
        .word 0654321
.bss
buffer:
        .space 8
EOS

cat > "$WORK/helper.s" <<'EOS'
.text
.globl helper
helper:
%L1:
        movei 1,7
        popj 17,
EOS

cat > "$WORK/unused.s" <<'EOS'
.text
.globl unused
unused:
        movei 1,0777
        popj 17,
EOS


cat > "$WORK/literal.s" <<'EOS'
.text
.globl literal_start
.entry literal_start
literal_start:
        add 17,[020,,020]
        popj 17,
EOS

cat > "$WORK/set-literal-main.s" <<'EOS'
.text
.globl set_literal_start
.entry set_literal_start
.extern set_literal_target
.set P,set_literal_target
set_literal_start:
        move 1,[P]
        halt
EOS

cat > "$WORK/set-literal-def.s" <<'EOS'
.text
.globl set_literal_target
set_literal_target:
        .word 0123456
EOS

cat > "$WORK/opt-reloc.s" <<'EOS'
.text
.globl opt_start
.entry opt_start
opt_start:
        movem 1,target
        move 2,target
        jrst next
next:
        move 3,target
        hrrz 3,3
        jumpn 4,opt_fall
        jrst opt_after
opt_fall:
        movei 5,1
opt_after:
        halt
.data
target:
        .word 0
EOS

cat > "$WORK/branch-barrier.s" <<'EOS'
.text
.globl branch_barrier_start
.entry branch_barrier_start
branch_barrier_start:
        jrst L1
.if 1
.endif
L1:
        movei 1,1
        jumpn 2,L2
        jrst L3
.if 1
.endif
L2:
        movei 3,2
L3:
        halt
EOS

cat > "$WORK/opt-symbols.s" <<'EOS'
.text
.globl opt_symbols_start
.entry opt_symbols_start
.extern opt_left,opt_right
opt_symbols_start:
        movem 1,opt_left
        move 2,opt_right
        halt
EOS

cat > "$WORK/opt-symbols-def.s" <<'EOS'
.data
.globl opt_left,opt_right
opt_left:
        .word 0
opt_right:
        .word 0
EOS

cat > "$WORK/badlocal.s" <<'EOS'
.text
.globl badlocal
badlocal:
        jrst .77
EOS

cat > "$WORK/common-def.s" <<'EOS'
.comm common_global,4
.lcomm local_common,4
EOS

cat > "$WORK/common-ref.s" <<'EOS'
.text
.globl common_start
.entry common_start
common_start:
        move 1,common_global
        popj 17,
EOS

cat > "$WORK/lh-reloc.s" <<'EOS'
.text
.globl lh_start
.entry lh_start
lh_start:
        EXP     lh_data,,7
        halt
.data
lh_data:
        .word   0123456
EOS

# helper is intentionally referenced without .extern/.globl in main.s. GCC
# emits ordinary unresolved references this way; DOBJ mode must create an
# implicit global import while keeping unresolved local labels fatal.
"$DAS" -C -O "$WORK/main.dobj" "$WORK/main.s"
"$DAS" -C -O "$WORK/helper.dobj" "$WORK/helper.s"
"$DAS" -C -O "$WORK/unused.dobj" "$WORK/unused.s"
"$DAS" -C -O "$WORK/literal.dobj" "$WORK/literal.s"
"$DLINK" -o "$WORK/literal.dxr" "$WORK/literal.dobj"
"$DXRCHECK" -q "$WORK/literal.dxr"
"$DAS" -C -O "$WORK/set-literal-main.dobj" "$WORK/set-literal-main.s"
"$DAS" -C -O "$WORK/set-literal-def.dobj" "$WORK/set-literal-def.s"
"$DLINK" -o "$WORK/set-literal.dxr" "$WORK/set-literal-main.dobj" "$WORK/set-literal-def.dobj"
"$DXRCHECK" -q "$WORK/set-literal.dxr"
line=$($DXRCHECK -d "$WORK/set-literal.dxr" | awk '$1 == "IMAGE" && $2 == "000002" { print $3 }')
case "$line" in
    000000000003) ;;
    *)
        echo "DOBJ test: .set literal lost external relocation: $line" >&2
        exit 1
        ;;
esac
"$DARC" -o "$WORK/libtest.darc" "$WORK/helper.dobj" "$WORK/unused.dobj"
"$DLINK" -o "$WORK/out.dxr" "$WORK/main.dobj" "$WORK/libtest.darc"
"$DXRCHECK" -q "$WORK/out.dxr"

# DOBJ can represent an LH18 relocation even though DXR V1 cannot.  Keep the
# unrelated RH constant intact while recording the left-half relocation.
"$DAS" -C -F -O "$WORK/lh-reloc.dobj" "$WORK/lh-reloc.s"
"$OBJDUMP" "$WORK/lh-reloc.dobj" >"$WORK/lh-reloc.dump"
grep -F '.text+000000 type=3 target=.data addend=000000,,000000' \
    "$WORK/lh-reloc.dump" >/dev/null
grep -F '000000:  000000,,000007' "$WORK/lh-reloc.dump" >/dev/null

"$DAS" -C -O "$WORK/common-def.dobj" "$WORK/common-def.s"
"$DAS" -C -O "$WORK/common-ref.dobj" "$WORK/common-ref.s"
"$DLINK" -o "$WORK/common.dxr" "$WORK/common-ref.dobj" "$WORK/common-def.dobj"
"$DXRCHECK" -q "$WORK/common.dxr"
cat > "$WORK/local-common-ref.s" <<'EOS'
.text
.globl local_common_start
.entry local_common_start
local_common_start:
        move 1,local_common
        popj 17,
EOS
"$DAS" -C -O "$WORK/local-common-ref.dobj" "$WORK/local-common-ref.s"
if "$DLINK" -o "$WORK/local-common.dxr" "$WORK/local-common-ref.dobj" \
    "$WORK/common-def.dobj" >"$WORK/local-common.log" 2>&1; then
    echo "DOBJ test: .lcomm symbol was exported" >&2
    exit 1
fi
if ! grep 'undefined symbol: local_common' "$WORK/local-common.log" >/dev/null 2>&1; then
    cat "$WORK/local-common.log" >&2
    echo "DOBJ test: wrong .lcomm visibility diagnostic" >&2
    exit 1
fi

if "$DAS" -C -O "$WORK/badlocal.dobj" "$WORK/badlocal.s" \
    >"$WORK/badlocal.log" 2>&1; then
    echo "DOBJ test: unresolved local symbol was accepted" >&2
    exit 1
fi
if ! grep 'undefined symbol %L77' "$WORK/badlocal.log" >/dev/null 2>&1; then
    cat "$WORK/badlocal.log" >&2
    echo "DOBJ test: wrong unresolved-local diagnostic" >&2
    exit 1
fi

line=$($DXRCHECK "$WORK/out.dxr" 2>/dev/null | head -1)
case "$line" in
    *"image=000010"*) ;;
    *)
        echo "DOBJ test: unexpected linked image: $line" >&2
        exit 1
        ;;
esac

# DOBJ optimization must preserve the exact image/relocation result of direct
# optimized assembly.  This source exercises relocation removal by store
# forwarding, JRST-to-next-label deletion, conditional JUMP/JRST folding, and
# opcode-only rewriting of a relocated MOVE.
"$DAS" -F -O "$WORK/opt-direct.dxr" "$WORK/opt-reloc.s"
"$DAS" -C -F -O "$WORK/opt.dobj" "$WORK/opt-reloc.s"
"$DLINK" -o "$WORK/opt-linked.dxr" "$WORK/opt.dobj"
"$DXRCHECK" -q "$WORK/opt-linked.dxr"
"$DXRCHECK" -d "$WORK/opt-direct.dxr" |
    awk '$1 == "IMAGE" || $1 == "RELOC" { print }' >"$WORK/opt-direct.dump"
"$DXRCHECK" -d "$WORK/opt-linked.dxr" |
    awk '$1 == "IMAGE" || $1 == "RELOC" { print }' >"$WORK/opt-linked.dump"
if ! cmp "$WORK/opt-direct.dump" "$WORK/opt-linked.dump" >/dev/null 2>&1; then
    echo "DOBJ test: optimized object relocation differs from direct output" >&2
    diff -u "$WORK/opt-direct.dump" "$WORK/opt-linked.dump" >&2 || :
    exit 1
fi

# Optimizer phase barriers must flush a deferred JRST/JUMP-JRST word before
# resetting local optimizer state.  Otherwise pass 2 becomes one word shorter
# than pass 1 for legal conditional/include/macro boundaries.
"$DAS" -F -O "$WORK/branch-barrier-direct.dxr" "$WORK/branch-barrier.s"
"$DAS" -C -F -O "$WORK/branch-barrier.dobj" "$WORK/branch-barrier.s"
"$DLINK" -o "$WORK/branch-barrier-linked.dxr" "$WORK/branch-barrier.dobj"
"$DXRCHECK" -d "$WORK/branch-barrier-direct.dxr" |
    awk '$1 == "IMAGE" || $1 == "RELOC" { print }' >"$WORK/branch-barrier-direct.dump"
"$DXRCHECK" -d "$WORK/branch-barrier-linked.dxr" |
    awk '$1 == "IMAGE" || $1 == "RELOC" { print }' >"$WORK/branch-barrier-linked.dump"
if ! cmp "$WORK/branch-barrier-direct.dump" "$WORK/branch-barrier-linked.dump" >/dev/null 2>&1; then
    echo "DOBJ test: deferred branch phase barrier differs from direct output" >&2
    diff -u "$WORK/branch-barrier-direct.dump" "$WORK/branch-barrier-linked.dump" >&2 || :
    exit 1
fi

# Two unresolved symbols have identical zeroed address fields in DOBJ.  The
# optimizer must compare relocation identities, not just relocation presence,
# or it could mis-forward the second load from the first store.
"$DAS" -C -O "$WORK/opt-symbols-plain.dobj" "$WORK/opt-symbols.s"
"$DAS" -C -F -O "$WORK/opt-symbols-opt.dobj" "$WORK/opt-symbols.s"
"$DAS" -C -O "$WORK/opt-symbols-def.dobj" "$WORK/opt-symbols-def.s"
"$DLINK" -o "$WORK/opt-symbols-plain.dxr" "$WORK/opt-symbols-plain.dobj" \
    "$WORK/opt-symbols-def.dobj"
"$DLINK" -o "$WORK/opt-symbols-opt.dxr" "$WORK/opt-symbols-opt.dobj" \
    "$WORK/opt-symbols-def.dobj"
"$DXRCHECK" -d "$WORK/opt-symbols-plain.dxr" |
    awk '$1 == "IMAGE" || $1 == "RELOC" { print }' >"$WORK/opt-symbols-plain.dump"
"$DXRCHECK" -d "$WORK/opt-symbols-opt.dxr" |
    awk '$1 == "IMAGE" || $1 == "RELOC" { print }' >"$WORK/opt-symbols-opt.dump"
if ! cmp "$WORK/opt-symbols-plain.dump" "$WORK/opt-symbols-opt.dump" >/dev/null 2>&1; then
    echo "DOBJ test: optimizer confused distinct symbol relocations" >&2
    diff -u "$WORK/opt-symbols-plain.dump" "$WORK/opt-symbols-opt.dump" >&2 || :
    exit 1
fi

echo "DAS DOBJ/DARC/DLINK integration passed"
