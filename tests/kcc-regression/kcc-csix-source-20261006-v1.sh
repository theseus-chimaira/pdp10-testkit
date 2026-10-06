#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
: "${KCC_SOURCE:?KCC_SOURCE must point to the KCC tree}"

HOSTCC=${HOSTCC:-cc}
root=$(CDPATH= cd -- "$KCC_SOURCE" && pwd -P)
work="$TMPDIR/kcc-csix-source-20261006-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work/bin" "$work/ascii" "$work/packed" "$work/csix"

if [ ! -f "$root/ccsrc.c" ] || [ ! -f "$root/ccsrc.h" ]; then
    echo 'kcc-csix-source: source reader implementation missing' >&2
    exit 1
fi

cat > "$work/ascii/Case.H" <<'EOF'
#define UpperValue 17
#define braces(x) ((x) ? '{' : '}')
EOF

cat > "$work/ascii/Main.C" <<'EOF'
#include "Case.H"
int lower_name = UpperValue;
char *MixedString = "Aa@{|}~`\\n\\x41";
int tri_array[2] = ??< 1, 2 ??>;
int digraph(void) <% return tri_array<:0:>; %>
int main(void) { return braces(lower_name) == '{' ? 0 : 1; }
EOF

# Generate native 36-bit host containers for both plain packed ASCII and
# S6REC/C-SIX.  A host container is one 36-bit word in eight little-endian
# bytes; the high 28 container bits must be zero.
python3 - "$work/ascii" "$work/packed" "$work/csix" <<'PY'
import pathlib, struct, sys

srcdir = pathlib.Path(sys.argv[1])
packdir = pathlib.Path(sys.argv[2])
sixdir = pathlib.Path(sys.argv[3])

def hostword(w):
    return struct.pack('<Q', w & ((1 << 36) - 1))

def packed_ascii(data):
    out = bytearray()
    # Native text uses LF; normalize host CRLF before packing.
    data = data.replace(b'\r\n', b'\n')
    for off in range(0, len(data), 5):
        chunk = data[off:off+5]
        # Bit 0 is the 36th/spare bit in five-by-seven packed ASCII.  Set it
        # deliberately so the test proves KCPP ignores it.
        w = 1
        for i, ch in enumerate(chunk):
            if ch > 0x7f:
                raise SystemExit('non-ASCII fixture')
            w |= ch << (29 - 7*i)
        out += hostword(w)
    return bytes(out)

def csix_line(line):
    out = []
    for ch in line:
        c = ch
        if 'a' <= c <= 'z':
            out.append(c.upper())
        elif 'A' <= c <= 'Z':
            out.extend(('@', c))
        elif c == '@':
            out.extend(('@', '@'))
        elif c == '`':
            out.extend(('@', "'"))
        elif c == '{':
            out.extend(('@', '<'))
        elif c == '|':
            out.extend(('@', '!'))
        elif c == '}':
            out.extend(('@', '>'))
        elif c == '~':
            out.extend(('@', '-'))
        elif c == '\t':
            # Canonical host conversion expands to the next 8-column stop.
            col = len(out)
            out.extend(' ' * (8 - (col & 7)))
        elif 0x20 <= ord(ch) <= 0x5f:
            out.append(c)
        else:
            raise SystemExit('unencodable C-SIX fixture character %r' % c)
    return ''.join(out)

def csix_s6rec(data):
    text = data.decode('ascii').replace('\r\n', '\n')
    out = bytearray()
    # splitlines() would lose the final empty record distinction; emit one
    # S6REC record for each physical source line without the LF itself.
    lines = text.split('\n')
    if lines and lines[-1] == '':
        lines = lines[:-1]
    for line in lines:
        enc = csix_line(line)
        out += hostword((1 << 30) | len(enc))
        for off in range(0, len(enc), 6):
            chunk = enc[off:off+6]
            w = 0
            for i in range(6):
                v = 0
                if i < len(chunk):
                    o = ord(chunk[i])
                    if not 0x20 <= o <= 0x5f:
                        raise SystemExit('C-SIX physical char outside SIXBIT')
                    v = o - 0x20
                w = (w << 6) | v
            out += hostword(w)
    return bytes(out)

for name in ('Main.C', 'Case.H'):
    data = (srcdir / name).read_bytes()
    (packdir / name).write_bytes(packed_ascii(data))
    (sixdir / name).write_bytes(csix_s6rec(data))
PY

cpp_src='cc.c ccasmb.c ccdata.c ccerr.c ccout.c ccpp.c ccppout.c ccsym.c ccsrc.c'
(
    cd "$root"
    # shellcheck disable=SC2086
    "$HOSTCC" -std=c99 -funsigned-char -O2 -DHOST_DAIMOS=1 -DHOST_UNIX=0 \
        -DKCC_PHASE_CPP=1 $cpp_src -o "$work/bin/kcpp-v1"
)

run_one()
{
    dir=$1
    out=$2
    (
        cd "$dir"
        "$work/bin/kcpp-v1" -Pgnu99 -O -x=pdp6 -m=gas -I. Main.C > "$out"
    )
}

run_one "$work/ascii" "$work/ascii.kpt"
run_one "$work/packed" "$work/packed.kpt"
run_one "$work/csix" "$work/csix.kpt"

cmp "$work/ascii.kpt" "$work/packed.kpt"
cmp "$work/ascii.kpt" "$work/csix.kpt"

# A dangling C-SIX escape is a storage error, not an implicit literal '@'.
python3 - "$work/csix/Bad.C" <<'PY'
import pathlib, struct, sys
p = pathlib.Path(sys.argv[1])
def w(v): return struct.pack('<Q', v & ((1 << 36) - 1))
line = '@'
word = 0
for i, c in enumerate(line):
    word |= (ord(c) - 0x20) << (30 - 6*i)
p.write_bytes(w((1 << 30) | len(line)) + w(word))
PY
if (cd "$work/csix" && "$work/bin/kcpp-v1" -Pgnu99 -O -x=pdp6 -m=gas Bad.C \
        >"$work/bad.kpt" 2>"$work/bad.err"); then
    echo 'kcc-csix-source: malformed trailing @ was accepted' >&2
    exit 1
fi

echo 'kcc-csix-source: PASS'
