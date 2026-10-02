#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work="$TMPDIR/kcc-terminal-commutative-ac1-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"
cat > "$work/t.c" <<'SRC'
volatile int __test_exit;

int add_ab(a, b) int a, b; { return a + b; }
int add_ba(a, b) int a, b; { return b + a; }
int and_ba(a, b) int a, b; { return b & a; }
int or_ba(a, b) int a, b; { return b | a; }
int xor_ba(a, b) int a, b; { return b ^ a; }
int mul_ab(a, b) int a, b; { return a * b; }
int mul_ba(a, b) int a, b; { return b * a; }
int sub_ba(a, b) int a, b; { return b - a; }
unsigned usub_ba(a, b) unsigned a, b; { return b - a; }

int main(void)
{
        if (add_ab(7, 5) != 12 || add_ba(7, 5) != 12)
                return 1;
        if (and_ba(074, 052) != (074 & 052))
                return 2;
        if (or_ba(074, 052) != (074 | 052))
                return 3;
        if (xor_ba(074, 052) != (074 ^ 052))
                return 4;
        if (mul_ab(-7, 5) != -35 || mul_ba(-7, 5) != -35)
                return 5;
        if (sub_ba(7, 5) != -2)
                return 6;
        if (usub_ba(7U, 5U) != (unsigned)(5U - 7U))
                return 7;
        return 0;
}
SRC

for cpu in pdp6 ka10 ki10 ks10; do
        d="$work/$cpu"
        mkdir "$d"
        cp "$work/t.c" "$d/t.c"
        (cd "$d" && TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -R=t t.c >/dev/null)
        asm="$d/t.s"

        for spec in \
                'add_ab add' 'add_ba add' \
                'and_ba and' 'or_ba ior' 'xor_ba xor' \
                'mul_ab imul' 'mul_ba imul'; do
                fn=${spec%% *}
                op=${spec#* }
                body=$(sed -n "/^$fn:/,/^[A-Za-z_][A-Za-z0-9_]*:/p" "$asm" | sed '$d')
                printf '%s\n' "$body" | grep -Eiq "^[[:space:]]*$op[[:space:]]+1,2([[:space:]]|$)" || {
                        echo "$cpu: $fn did not operate directly in AC1" >&2
                        printf '%s\n' "$body" >&2
                        exit 1
                }
                if printf '%s\n' "$body" | grep -Eiq '^[[:space:]]*move[[:space:]]+[3-7],[12]([[:space:]]|$)'; then
                        echo "$cpu: $fn retained a commutative temporary move" >&2
                        printf '%s\n' "$body" >&2
                        exit 1
                fi
        done

        for fn in sub_ba usub_ba; do
                body=$(sed -n "/^$fn:/,/^[A-Za-z_][A-Za-z0-9_]*:/p" "$asm" | sed '$d')
                printf '%s\n' "$body" | grep -Eiq '^[[:space:]]*movn[[:space:]]+1,1([[:space:]]|$)' || {
                        echo "$cpu: $fn did not negate AC1 directly" >&2
                        printf '%s\n' "$body" >&2
                        exit 1
                }
                printf '%s\n' "$body" | grep -Eiq '^[[:space:]]*add[[:space:]]+1,2([[:space:]]|$)' || {
                        echo "$cpu: $fn did not add the minuend directly" >&2
                        printf '%s\n' "$body" >&2
                        exit 1
                }
        done

        "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
                --step-limit 1000000 --timeout 20 --workdir "$work/run-$cpu" \
                --name "terminal-commutative-ac1-v1-$cpu" \
                --expect __test_exit=0 \
                "$testroot/semantic-crt0.s" "$asm" "$KCC_RT" >/dev/null
done

printf '%s\n' 'terminal commutative AC1 regression passed'
