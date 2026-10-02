#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
tmp=$TMPDIR/kcc-gnu-packed-aggregate-stream-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/shape.c" <<'SRC'
struct big {
    unsigned char a,b,c,d,e,f,g,h,i,j,k,l;
} __attribute__((packed));
static struct big x[3];
void discarded(void) { x[1] = x[0]; }
void chained(void) { x[2] = x[1] = x[0]; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    d=$tmp/$cpu
    mkdir -p "$d"
    cp "$tmp/shape.c" "$d/t.c"
    (cd "$d" && TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -R=gpackagg t.c)
    s=$d/gpackagg.s
    if grep -qi '%ADJBPH' "$s"; then
        echo "$cpu: packed aggregate stream still uses ADJBP helper" >&2
        exit 1
    fi
    n=$(grep -E '^[[:space:]]*[A-Za-z]' "$s" | wc -l)
    if [ "$n" -gt 190 ]; then
        echo "$cpu: packed aggregate stream rebuilt byte pointers ($n instructions)" >&2
        exit 1
    fi
done
cat > "$tmp/run.c" <<'SRC'
volatile int __test_exit;
struct big {
    unsigned char a,b,c,d,e,f,g,h,i,j,k,l;
} __attribute__((packed));
static struct big x[3];
static int eq(struct big *p)
{
    return p->a==1 && p->b==2 && p->c==3 && p->d==4
        && p->e==5 && p->f==6 && p->g==7 && p->h==8
        && p->i==9 && p->j==10 && p->k==11 && p->l==12;
}
int main(void)
{
    x[0].a=1; x[0].b=2; x[0].c=3; x[0].d=4; x[0].e=5; x[0].f=6;
    x[0].g=7; x[0].h=8; x[0].i=9; x[0].j=10; x[0].k=11; x[0].l=12;
    x[1].a=70; x[2].a=80;
    x[2] = x[1] = x[0];
    if (!eq(&x[1])) return 1;
    if (!eq(&x[2])) return 2;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackaggrun run.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 3000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-aggregate-stream --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackaggrun.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed aggregate streaming regression passed'
