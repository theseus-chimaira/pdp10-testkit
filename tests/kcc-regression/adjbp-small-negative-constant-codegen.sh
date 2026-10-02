#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work="$TMPDIR/kcc-adjbp-small-negative-constant-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"
cat > "$work/t.c" <<'SRC'
volatile int __test_exit;
char *m1(char *p) { return p - 1; }
char *m2(char *p) { return p - 2; }
char *m3(char *p) { return p - 3; }
char *m4(char *p) { return p - 4; }
char *m5(char *p) { return p - 5; }

int main(void)
{
        char a[16];
        char *p;
        int i;

        for (i = 0; i < 16; ++i)
                a[i] = i + 1;
        p = &a[9];
        if (*m1(p) != 9) return 1;
        if (*m2(p) != 8) return 2;
        if (*m3(p) != 7) return 3;
        if (*m4(p) != 6) return 4;
        if (*m5(p) != 5) return 5;
        return 0;
}
SRC
for cpu in pdp6 ka10 ki10 ks10; do
        d="$work/$cpu"
        mkdir "$d"
        cp "$work/t.c" "$d/t.c"
        (cd "$d" && TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -R=t t.c >/dev/null)
        asm="$d/t.s"
        if [ "$cpu" = pdp6 ] || [ "$cpu" = ka10 ] || [ "$cpu" = ki10 ]; then
                for fn in m1 m2 m3 m4 m5; do
                        body=$(sed -n "/^$fn:/,/^[A-Za-z_][A-Za-z0-9_]*:/p" "$asm" | sed '$d')
                        if printf '%s\n' "$body" | grep -q '%ADJBPH'; then
                                echo "$cpu: $fn still uses ADJBP helper" >&2
                                exit 1
                        fi
                        printf '%s\n' "$body" | grep -Eiq '^[[:space:]]*hrrz[[:space:]]+16,0\(17\)' || {
                                echo "$cpu: $fn lost PDP-6-safe word-address adjustment" >&2
                                exit 1
                        }
                done
        else
                for fn in m1 m2 m3 m4 m5; do
                        body=$(sed -n "/^$fn:/,/^[A-Za-z_][A-Za-z0-9_]*:/p" "$asm" | sed '$d')
                        printf '%s\n' "$body" | grep -Eiq '^[[:space:]]*adjbp[[:space:]]' || {
                                echo "KS10 $fn lost native ADJBP" >&2
                                exit 1
                        }
                done
        fi
done

"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 1000000 --timeout 20 --workdir "$work/run-pdp6" \
        --name adjbp-small-negative-constant-v1 --expect __test_exit=0 \
        "$testroot/semantic-crt0.s" "$work/pdp6/t.s" "$KCC_RT" >/dev/null

printf '%s\n' 'small negative constant ADJBP codegen regression passed'
