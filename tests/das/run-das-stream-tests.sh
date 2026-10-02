#!/bin/sh
set -eu

TEST_ROOT=${TEST_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
BASE=$TMPDIR/das-stream-$$
SRC=$BASE.s
DXR=$BASE.dxr
STATS=$BASE.stats
SYMSRC=$BASE-symbols.s
SYMSTATS=$BASE-symbols.stats
LITSRC=$BASE-literals.s
LITSTATS=$BASE-literals.stats
WORDS=120000
SYMBOLS=12000
LITERALS=2500
trap 'rm -f "$SRC" "$DXR" "$STATS" "$SYMSRC" "$SYMSTATS" "$LITSRC" "$LITSTATS"' 0 1 2 3 15

awk -v n="$WORDS" 'BEGIN {
    print ".text"
    print ".entry main"
    print "main: MOVEI 1,1"
    for (i = 1; i < n; i++)
        print "MOVE 2,1"
}' > "$SRC"

"$DAS_ROOT/das" -M -A -O "$DXR" "$SRC" 2> "$STATS"
"$DAS_ROOT/dxrcheck" -q "$DXR"

grep '^das-memory: retained-statement-words=0$' "$STATS" >/dev/null
grep '^das-memory: retained-image-words=0$' "$STATS" >/dev/null
grep '^das-memory: symbol-bucket-words=2048$' "$STATS" >/dev/null
grep '^das-memory: symbol-cache-words=825$' "$STATS" >/dev/null
grep '^das-memory: parser-classifications=240004$' "$STATS" >/dev/null
PROBES=$(sed -n 's/^das-memory: parser-token-probes=//p' "$STATS")
[ -n "$PROBES" ]
[ "$PROBES" -le 24 ]
PEAK=$(sed -n 's/^das-memory: peak-work-words=//p' "$STATS")
case $PEAK in
    ''|*[!0-9]*)
        echo "bad DAS peak-work report: $PEAK" >&2
        exit 1
        ;;
esac
if [ "$PEAK" -gt 65536 ]; then
    echo "DAS exceeded 64 kword work budget: $PEAK" >&2
    exit 1
fi

EXPECTED=$(( (2 + WORDS + (WORDS + 35) / 36) * 8 ))
ACTUAL=$(wc -c < "$DXR" | tr -d ' ')
if [ "$ACTUAL" -ne "$EXPECTED" ]; then
    echo "streamed DXR size mismatch: got $ACTUAL expected $EXPECTED" >&2
    exit 1
fi

awk -v n="$SYMBOLS" 'BEGIN {
    print ".text"
    print ".entry L00000"
    for (i = 0; i < n; i++)
        printf "L%05d: MOVEI 1,0\n", i
    for (i = n - 1; i >= 0; i--)
        printf "MOVEI 2,L%05d\n", i
}' > "$SYMSRC"
"$DAS_ROOT/das" -M -A -O "$DXR" "$SYMSRC" 2> "$SYMSTATS"
"$DAS_ROOT/dxrcheck" -q "$DXR"
grep "^das-memory: symbol-spill-records=$SYMBOLS$" "$SYMSTATS" >/dev/null
SYMPEAK=$(sed -n 's/^das-memory: peak-work-words=//p' "$SYMSTATS")
if [ -z "$SYMPEAK" ] || [ "$SYMPEAK" -gt 65536 ]; then
    echo "DAS symbol spill exceeded 64 kword work budget: $SYMPEAK" >&2
    exit 1
fi

awk -v n="$LITERALS" 'BEGIN {
    print ".text"
    print ".entry main"
    print "main: MOVEI 1,msg"
    for (i = 0; i < n; i++)
        print "MOVEI 2,[POINT 9,msg,35]"
    print "HALT"
    print ".data"
    print "msg: SIXBIT /ABC/"
}' > "$LITSRC"
"$DAS_ROOT/das" -M -A -O "$DXR" "$LITSRC" 2> "$LITSTATS"
"$DAS_ROOT/dxrcheck" -q "$DXR"
grep "^das-memory: literal-spill-records=1$" "$LITSTATS" >/dev/null
LITWORDS=$(sed -n 's/^das-memory: literal-spill-words=//p' "$LITSTATS")
case $LITWORDS in
    ''|*[!0-9]*)
        echo "bad DAS literal spill word report: $LITWORDS" >&2
        exit 1
        ;;
esac
if [ "$LITWORDS" -ge $((LITERALS * 65)) ]; then
    echo "DAS still uses fixed-size literal records: $LITWORDS words" >&2
    exit 1
fi
LITPEAK=$(sed -n 's/^das-memory: peak-work-words=//p' "$LITSTATS")
if [ -z "$LITPEAK" ] || [ "$LITPEAK" -gt 65536 ]; then
    echo "DAS literal spill exceeded 64 kword work budget: $LITPEAK" >&2
    exit 1
fi

echo "das bounded stores passed ($WORDS words, $SYMBOLS symbols, $LITERALS literals; peak $PEAK words)"
