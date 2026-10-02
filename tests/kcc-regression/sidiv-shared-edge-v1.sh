#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work="$TMPDIR/kcc-sidiv-shared-edge-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"
cat > "$work/t.c" <<'SRC'
volatile int __test_exit;
volatile int va,vb,vc,vd,ve,vf;
int f1(a,b) int a,b; { return a/b; }
int f2(a,b,c,d) int a,b,c,d; { return (a/b)+(c/d); }
int f3(a,b,c,d,e,f) int a,b,c,d,e,f; { return (a/b)+(c/d)+(e/f); }
int f4(a,b,c,d) int a,b,c,d; { return (a%b) + (c%d); }
int f5(a,b,c,d) int a,b,c,d; { int x=a/b; int y=c%d; return x-y; }
int main(void)
{
 int m=(-34359738367L-1L);
 va=m; vb=3; vc=m; vd=-3; ve=m; vf=5;
 if (f1(va,vb) != -11453246122L) return 1;
 if (f2(va,vb,vc,vd) != 0) return 2;
 if (f3(va,vb,vc,vd,ve,vf) != -6871947673L) return 3;
 if (f4(va,vb,ve,vf) != -5) return 4;
 if (f5(va,vb,ve,vf) != -11453246119L) return 5;
 return 0;
}
SRC
for cpu in pdp6 ka10 ki10 ks10; do
 d="$work/$cpu"
 mkdir "$d"
 cp "$work/t.c" "$d/t.c"
 (cd "$d" && TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -R=t t.c >/dev/null)
 asm="$d/t.s"
 case "$cpu" in
 pdp6)
   helpers=$(grep -c '^%SIDH' "$asm" || true)
   calls=$(grep -c 'PUSHJ.*%SIDH' "$asm" || true)
   [ "$helpers" -ge 6 ] || { echo "PDP-6: expected shared signed-IDIV helpers" >&2; exit 1; }
   [ "$calls" -ge 10 ] || { echo "PDP-6: expected shared helper call sites" >&2; exit 1; }
   if grep -q '^%SIDN' "$asm"; then
     echo 'PDP-6: old per-site signed-IDIV edge body survived' >&2
     exit 1
   fi
   ;;
 ka10|ki10|ks10)
   if grep -q '^%SIDH' "$asm"; then
     echo "$cpu: unexpected PDP-6 signed-IDIV helper" >&2
     exit 1
   fi
   ;;
 esac
 "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
   --step-limit 3000000 --timeout 20 --workdir "$work/run-$cpu" \
   --name "sidiv-shared-edge-v1-$cpu" --expect __test_exit=0 \
   "$testroot/semantic-crt0.s" "$asm" "$KCC_RT" >/dev/null
done
printf '%s\n' 'shared signed-IDIV edge regression passed'
