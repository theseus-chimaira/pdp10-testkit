#!/bin/sh
set -eu

testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-shared-fixed-epilogue-v1-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
volatile int __test_exit;

static int
multi_return(int a, int b, int c, int d, int e)
{
    volatile int v[6];

    v[0] = a + e;
    v[1] = b + 2;
    v[2] = c + 3;
    v[3] = d + 4;
    if (a < 0)
        return v[0];
    if (b == 7)
        return v[1];
    if (c > 20)
        return v[2];
    return v[0] + v[1] + v[2] + v[3];
}

int
main(void)
{
    if (multi_return(-3, 1, 2, 3, 9) != 6)
        return 1;
    if (multi_return(1, 7, 2, 3, 9) != 9)
        return 2;
    if (multi_return(1, 1, 21, 3, 9) != 24)
        return 3;
    if (multi_return(1, 1, 2, 3, 9) != 25)
        return 4;
    return 0;
}
SRC

for cpu in pdp6 ka10 ki10 ks10; do
    d="$TMP/$cpu"
    mkdir -p "$d"
    cp "$TMP/test.c" "$d/test.c"
    (
        cd "$d"
        "$KCC" -x="$cpu" -S test.c >/dev/null
    )

    body=$d/body.s
    awk '
        $0 == "multi_return:" { in_fn = 1; next }
        in_fn && /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
        in_fn { print }
    ' "$d/test.s" > "$body"

    ret_count=$(grep -Eic '^[[:space:]]*(popj[[:space:]]+17,|jrst[[:space:]]+0\(6\))[[:space:]]*$' "$body" || true)
    if [ "$ret_count" -ne 1 ]; then
        echo "$cpu: fixed-frame function did not share one epilogue" >&2
        cat "$body" >&2
        exit 1
    fi
    if ! grep -Eqi '^[[:space:]]*jrst[[:space:]]+%L[0-9]+' "$body"; then
        echo "$cpu: fixed-frame early returns did not branch to shared epilogue" >&2
        cat "$body" >&2
        exit 1
    fi

    "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
        --start 1000 --step-limit 1000000 --timeout 10 \
        --workdir "$d/run" --name shared-fixed-epilogue \
        --expect __test_exit=0 "$testroot/semantic-crt0.s" "$d/test.s" >/dev/null
    echo "$cpu shared fixed epilogue passed"
done
