#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
: "${CSIX:?CSIX must point to the csix tool}"

work="$TMPDIR/csix-v1-test-$$"
trap 'rm -rf "$work"' 0 1 2 3 15
mkdir -p "$work"

# Input deliberately uses CRLF and TAB.  Canonical decoding uses LF and
# expands TAB to the next eight-column stop before C-SIX encoding.
python3 - "$work/input.c" <<'PY'
import pathlib, sys
pathlib.Path(sys.argv[1]).write_bytes(
    b'#include "Case.H"\r\n'
    b'int lower_name = UpperValue;\r\n'
    b'\tchar *Mixed = "Aa@{|}~`\\\\n\\\\x41";\r\n'
    b'int tri[2] = ??< 1, 2 ??>;\r\n'
    b'int dig(void) <% return tri<:0:>; %>\r\n')
PY

cat > "$work/expect.c" <<'EOF'
#include "Case.H"
int lower_name = UpperValue;
        char *Mixed = "Aa@{|}~`\\n\\x41";
int tri[2] = ??< 1, 2 ??>;
int dig(void) <% return tri<:0:>; %>
EOF

"$CSIX" -e "$work/input.c" "$work/source.s6"
"$CSIX" -d "$work/source.s6" "$work/output.c"
cmp "$work/expect.c" "$work/output.c"

# stdin/stdout paths are supported for pipeline use.
cat "$work/expect.c" | "$CSIX" -e - - | "$CSIX" -d - - > "$work/pipe.c"
cmp "$work/expect.c" "$work/pipe.c"

# A source file without final newline cannot be represented reversibly as
# line-record S6REC and must be rejected.
printf 'int x;' > "$work/noeol.c"
if "$CSIX" -e "$work/noeol.c" "$work/noeol.s6" >/dev/null 2>&1; then
        echo 'csix: accepted source without final newline' >&2
        exit 1
fi

# Create structurally valid S6REC records with malformed C-SIX and padding.
python3 - "$work" <<'PY'
import pathlib, struct, sys

root = pathlib.Path(sys.argv[1])

def word(v):
    return struct.pack('<Q', v & ((1 << 36) - 1))

def six(chars):
    w = 0
    for i in range(6):
        v = 0
        if i < len(chars):
            v = ord(chars[i]) - 0x20
        w = (w << 6) | (v & 0x3f)
    return w

# Unknown @ escape.
(root / 'bad-escape.s6').write_bytes(
    word((1 << 30) | 2) + word(six('@?')))

# Dangling @ escape.
(root / 'dangling.s6').write_bytes(
    word((1 << 30) | 1) + word(six('@')))

# Nonzero payload padding after a one-character record.
w = six('A') | 1
(root / 'bad-padding.s6').write_bytes(
    word((1 << 30) | 1) + word(w))

# Non-text record type.
(root / 'bad-type.s6').write_bytes(word((2 << 30) | 0))

# Truncated word container.
(root / 'truncated.s6').write_bytes(b'\x01\x02\x03')
PY

for bad in bad-escape dangling bad-padding bad-type truncated; do
        if "$CSIX" -d "$work/$bad.s6" "$work/$bad.out" >/dev/null 2>&1; then
                echo "csix: accepted malformed input $bad" >&2
                exit 1
        fi
done

echo 'csix-v1: PASS'
