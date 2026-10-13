#!/bin/sh
# Validate public build targets without running any compiler or build recipe.
set -eu
: "${KCC_REPO:?}" "${BMAKE:?}" "${MAKESYSPATH:?}"
cd "$KCC_REPO"
for makecmd in gmake "$BMAKE"; do
    "$makecmd" -n -f Makefile > "$TMPDIR/kcc-target-default.out"
    "$makecmd" -n -f Makefile cross > "$TMPDIR/kcc-target-cross.out"
    cmp "$TMPDIR/kcc-target-default.out" "$TMPDIR/kcc-target-cross.out"
    "$makecmd" -n -f Makefile native > "$TMPDIR/kcc-target-native.out"
    grep -q 'KCPP.dxr\|KCPP\.dxr\|kcpp' "$TMPDIR/kcc-target-native.out"
    if "$makecmd" -n -f Makefile host-built > /dev/null 2>&1; then
        echo 'obsolete host-built alias accepted' >&2; exit 1
    fi
    if "$makecmd" -n -f Makefile native-built > /dev/null 2>&1; then
        echo 'obsolete native-built alias accepted' >&2; exit 1
    fi
done
# The native file is staged in uppercase, but host parsers can validate its
# topology without requiring a host filesystem containing SIXBIT source paths.
python3 - <<'PY'
from pathlib import Path
p=Path('daimos.mk').read_text()
assert '.PHONY: NATIVE INSTALL CLEAN' in p
assert 'NATIVE: BUILD BUILD/KCPP.DXR BUILD/KPARSE.DXR BUILD/KGEN.DXR BUILD/KOPT.DXR BUILD/KCC.DXR' in p
assert not any(line.startswith('ALL:') for line in p.splitlines())
for alias in ('KCPP:', 'KPARSE:', 'KGEN:', 'KOPT:', 'DRIVER:'):
    assert not any(line.startswith(alias) for line in p.splitlines())
PY
echo 'PASS: cross/native target contract in GNU and BSD Make'
