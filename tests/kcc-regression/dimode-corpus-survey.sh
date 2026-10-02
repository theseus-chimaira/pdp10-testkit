#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-corpus-survey-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/corpus.c" <<'SRC'
typedef long long D;
typedef unsigned long long U;
D da(D a,D b) { return a+b; }
D ds(D a,D b) { return a-b; }
D dm(D a,D b) { return a*b; }
D dd(D a,D b) { return a/b; }
D dr(D a,D b) { return a%b; }
U ud(U a,U b) { return a/b; }
U ur(U a,U b) { return a%b; }
D ba(D a,D b) { return a&b; }
D bo(D a,D b) { return a|b; }
D bx(D a,D b) { return a^b; }
D sl(D a,int n) { return a<<n; }
D sr(D a,int n) { return a>>n; }
U us(U a,int n) { return a>>n; }
int ce(D a,D b) { return a==b; }
int cl(D a,D b) { return a<b; }
int ul(U a,U b) { return a<b; }
D ld(D *p) { return *p; }
void st(D *p,D v) { *p=v; }
D call(D (*f)(D),D a) { return (*f)(a); }
D cv(int a) { return a; }
int ci(D a) { return (int)a; }
D mix(D a,D b,D c,D d,D e,D f) { return ((a+b)^(c|d))+(e*f); }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    d="$TMP/$cpu"
    mkdir "$d"
    cp "$TMP/corpus.c" "$d/corpus.c"
    (cd "$d" && "$KCC" -x="$cpu" -S corpus.c >/dev/null)
    asm="$d/corpus.s"
    awk '
      /^[[:space:]]*[Mm][Oo][Vv][Ee][[:space:]]/ {
        line=$0; sub(/^[[:space:]]*[Mm][Oo][Vv][Ee][[:space:]]+/,"",line)
        split(line,a,","); gsub(/[[:space:]]/,"",a[1]); gsub(/[[:space:]]/,"",a[2])
        if (a[1] == a[2]) badmove++
      }
      END { if (badmove) exit 1 }
    ' "$asm" || { echo "$cpu: redundant MOVE AC,AC found" >&2; exit 1; }
    if awk '
      /^[[:space:]]*[Ss][Ee][Tt][Zz][[:space:]]/ { z=$2; gsub(/,/,"",z); next }
      z != "" && /^[[:space:]]*(SETZ|SETCA|MOVEI)[[:space:]]/ {
        a=$2; gsub(/,/,"",a); if (a==z) exit 1; z=""
      }
      { z="" }
    ' "$asm"; then :; else
      echo "$cpu: clearing instruction immediately overwritten" >&2; exit 1
    fi
    n=$(grep -Ec '^[[:space:]]*(MOVE|MOVEM|SETZ|ADD|SUB|IMUL|AND|IOR|XOR|LSHC|ASHC|CAM|JUMP)' "$asm" || true)
    [ "$n" -gt 40 ] || { echo "$cpu: corpus unexpectedly small ($n instructions)" >&2; exit 1; }
done
echo 'DImode corpus peephole survey passed'
