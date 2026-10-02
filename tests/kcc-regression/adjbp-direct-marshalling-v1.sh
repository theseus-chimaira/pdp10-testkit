#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work="$TMPDIR/kcc-adjbp-direct-marshalling-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"
cat > "$work/t.c" <<'SRC'
volatile int __test_exit;
char ga[64];

char *adjust(p, n)
char *p;
int n;
{
        return p + n;
}

int main(void)
{
        int i;

        for (i = 0; i < 64; ++i)
                ga[i] = i;
        if (*adjust(&ga[20], 7) != 27)
                return 1;
        if (*adjust(&ga[20], -7) != 13)
                return 2;
        return 0;
}
SRC
for cpu in pdp6 ka10 ki10 ks10; do
        d="$work/$cpu"
        mkdir "$d"
        cp "$work/t.c" "$d/t.c"
        (cd "$d" && TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -R=t t.c >/dev/null)
        asm="$d/t.s"
        body=$(sed -n '/^adjust:/,/^[A-Za-z_][A-Za-z0-9_]*:/p' "$asm" | sed '$d')

        case "$cpu" in
        pdp6)
                printf '%s\n' "$body" | grep -q '%ADJBPH' || {
                        echo 'PDP-6 adjust lost simulated ADJBP helper' >&2
                        exit 1
                }
                printf '%s\n' "$body" | grep -Eiq '^[[:space:]]*add[[:space:]]+17,\[2,,2\]' || {
                        echo 'PDP-6 adjust lost required stack marshalling' >&2
                        exit 1
                }
                ;;
        ka10|ki10)
                printf '%s\n' "$body" | grep -q '%ADJBPH' || {
                        echo "$cpu: adjust lost simulated ADJBP helper" >&2
                        exit 1
                }
                if printf '%s\n' "$body" | grep -Eiq '^[[:space:]]*add[[:space:]]+17,\[2,,2\]'; then
                        echo "$cpu: unnecessary PDP-6 stack marshalling survived" >&2
                        exit 1
                fi
                printf '%s\n' "$body" | grep -Eiq '^[[:space:]]*move[[:space:]]+16,' || {
                        echo "$cpu: helper count is not marshalled directly through AC16" >&2
                        exit 1
                }
                ;;
        ks10)
                printf '%s\n' "$body" | grep -Eiq '^[[:space:]]*adjbp[[:space:]]' || {
                        echo 'KS10 adjust lost native ADJBP' >&2
                        exit 1
                }
                if printf '%s\n' "$body" | grep -q '%ADJBPH'; then
                        echo 'KS10 adjust unexpectedly uses simulated ADJBP helper' >&2
                        exit 1
                fi
                ;;
        esac

        "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
                --step-limit 1000000 --timeout 20 --workdir "$work/run-$cpu" \
                --name "adjbp-direct-marshalling-v1-$cpu" \
                --expect __test_exit=0 \
                "$testroot/semantic-crt0.s" "$asm" "$KCC_RT" >/dev/null
done

printf '%s\n' 'direct ADJBP marshalling regression passed'
