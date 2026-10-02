#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work=$TMPDIR/kcc-byteptr-register-incdec-v1-$$
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"
cat > "$work/t.c" <<'SRC'
volatile int __test_exit;
char *inc(register char *p) { return ++p; }
char *dec(register char *p) { return --p; }
short *sinc(register short *p) { return ++p; }
short *sdec(register short *p) { return --p; }

int main(void)
{
        char a[8];
        short h[4];
        register char *p;
        register short *q;

        a[1] = 23;
        a[2] = 47;
        p = &a[1];
        if (*++p != 47)
                return 1;
        if (*--p != 23)
                return 2;
        h[1] = 1234;
        h[2] = 2345;
        q = &h[1];
        if (*++q != 2345)
                return 3;
        if (*--q != 1234)
                return 4;
        return 0;
}
SRC
for cpu in pdp6 ka10 ki10 ks10; do
        d=$work/$cpu
        mkdir "$d"
        cp "$work/t.c" "$d/t.c"
        (cd "$d" && TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -R=t t.c >/dev/null)
        asm=$d/t.s
        inc_body=$(sed -n '/^inc:/,/^dec:/p' "$asm")
        printf '%s\n' "$inc_body" | grep -Eiq '^[[:space:]]*ibp[[:space:]]+[0-9]+([[:space:]]|$)' || {
                echo "$cpu: register ++p did not use IBP" >&2
                exit 1
        }
        if printf '%s\n' "$inc_body" | grep -Eq '%ADJBPH|^[[:space:]]*adjbp[[:space:]]'; then
                echo "$cpu: register ++p still uses ADJBP" >&2
                exit 1
        fi
        if [ "$cpu" = pdp6 ] || [ "$cpu" = ka10 ] || [ "$cpu" = ki10 ]; then
                dec_body=$(sed -n '/^dec:/,/^main:/p' "$asm")
                if printf '%s\n' "$dec_body" | grep -q '%ADJBPH'; then
                        echo "$cpu: register --p still uses ADJBP helper" >&2
                        exit 1
                fi
                printf '%s\n' "$dec_body" | grep -Eiq '^[[:space:]]*hrrz[[:space:]]+16,0\(17\)' || {
                        echo "$cpu: register --p lost PDP-6-safe stack address adjustment" >&2
                        exit 1
                }
        else
                sed -n '/^dec:/,/^sinc:/p' "$asm" | grep -Eiq '^[[:space:]]*adjbp[[:space:]]' || {
                        echo 'KS10 register --p lost native ADJBP' >&2
                        exit 1
                }
        fi
        sinc_body=$(sed -n '/^sinc:/,/^sdec:/p' "$asm")
        printf '%s\n' "$sinc_body" | grep -Eiq '^[[:space:]]*ibp[[:space:]]+[0-9]+([[:space:]]|$)' || {
                echo "$cpu: register short ++p did not use IBP" >&2
                exit 1
        }
        if [ "$cpu" = pdp6 ] || [ "$cpu" = ka10 ] || [ "$cpu" = ki10 ]; then
                sdec_body=$(sed -n '/^sdec:/,/^main:/p' "$asm")
                if printf '%s\n' "$sdec_body" | grep -q '%ADJBPH'; then
                        echo "$cpu: register short --p still uses ADJBP helper" >&2
                        exit 1
                fi
        fi
done

"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 1000000 --timeout 20 --workdir "$work/run-pdp6" \
        --name byteptr-register-incdec-v1 --expect __test_exit=0 \
        "$testroot/semantic-crt0.s" "$work/pdp6/t.s" "$KCC_RT" >/dev/null

echo 'register byte-pointer inc/dec regression passed'
