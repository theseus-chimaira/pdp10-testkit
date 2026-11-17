#!/bin/sh
# Preserve the native KCC MAKE suffix and recursive CLEAN assertions.
# These were previously coupled to an unrelated DAIMOS OS RM test.
set -eu
: "${TMPDIR:=$HOME/tmp}"
kcc=${KCC_REPO:-"$HOME/git/kcc"}
export TMPDIR
test -f "$kcc/daimos.mk"

python3 - "$kcc" <<'PY'
from pathlib import Path
import re
import sys

make = (Path(sys.argv[1]) / 'daimos.mk').read_text()
# The original DAIMOS-hosted oracle hardcoded /OPTION/BASE/EXEC/DAS,
# but native KCC now names the assembler through NATIVE_DAS.  Verify
# both the variable binding and the actual expanded recipe; do not
# replace these assertions with mere text presence or compile success.
assert re.search(r'(?m)^NATIVE_DAS = DAS$', make)
assert re.search(r'(?m)^\.S\.DOBJ:\n\t@\$\(NATIVE_DAS\) -F -C -O \$@ \$<', make)
assert not re.search(r'(?m)^BUILD/[^\n]+\.DOBJ:', make)
assert re.search(r'(?m)^CLEAN:\n\t@\$\(NATIVE_RM\) -R -F BUILD$', make)
print('PASS: KCC native assembler suffix and recursive CLEAN rules')
PY

mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/kcc-native-make-clean-suffix-20261010-v1.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work/BUILD"
cp "$kcc/daimos.mk" "$work/daimos.mk"
printf '; native KCC assembler suffix test\n' > "$work/BUILD/PROBE.S"
(cd "$work" && make -r -f daimos.mk -n BUILD/PROBE.DOBJ) > "$work/output"
grep -Fxq 'DAS -F -C -O BUILD/PROBE.DOBJ BUILD/PROBE.S' "$work/output"
echo 'PASS: KCC native directory-qualified .S.DOBJ inference'
