#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work="$TMPDIR/kcc-subbp-index-arithmetic-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"
cat > "$work/t.c" <<'SRC'
volatile int __test_exit;
typedef signed _KCCtype_char6 c6;
typedef signed _KCCtype_char7 c7;
typedef signed _KCCtype_char8 c8;
typedef signed _KCCtype_char9 c9;
typedef signed _KCCtype_char16 c16;
typedef signed _KCCtype_char18 c18;
typedef signed _KCCtype_int32 c32;
static c6 a6[20]; static c7 a7[20]; static c8 a8[20]; static c9 a9[20];
static c16 a16[20]; static c18 a18[20]; static c32 a32[20];
int d6(p,q) c6*p,*q; { return p-q; }
int d7(p,q) c7*p,*q; { return p-q; }
int d8(p,q) c8*p,*q; { return p-q; }
int d9(p,q) c9*p,*q; { return p-q; }
int d16(p,q) c16*p,*q; { return p-q; }
int d18(p,q) c18*p,*q; { return p-q; }
int d32(p,q) c32*p,*q; { return p-q; }
int main(void) {
 if(d6(&a6[17],&a6[3])!=14) return 1;
 if(d7(&a7[17],&a7[3])!=14) return 2;
 if(d8(&a8[17],&a8[3])!=14) return 3;
 if(d9(&a9[17],&a9[3])!=14) return 4;
 if(d16(&a16[17],&a16[3])!=14) return 5;
 if(d18(&a18[17],&a18[3])!=14) return 6;
 if(d32(&a32[17],&a32[3])!=14) return 7;
 if(d6(&a6[3],&a6[17])!=-14) return 8;
 return 0;
}
SRC
for cpu in pdp6 ka10 ki10 ks10; do
 d="$work/$cpu"
 mkdir "$d"
 cp "$work/t.c" "$d/t.c"
 (cd "$d" && TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -R=t t.c >/dev/null)
 if grep -Eq '^[[:space:]]*CAIN[[:space:]]+15,' "$d/t.s"; then
   echo "$cpu: linear SUBBP position search survived" >&2
   exit 1
 fi
 "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
   --step-limit 3000000 --timeout 20 --workdir "$work/run-$cpu" \
   --name "subbp-index-arithmetic-v1-$cpu" --expect __test_exit=0 \
   "$testroot/semantic-crt0.s" "$d/t.s" "$KCC_RT" >/dev/null
done
printf '%s\n' 'SUBBP arithmetic byte-index regression passed'
