#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-addsub-registers-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;

Dint addpair(a, b)
Dint a, b;
{
    return a + b;
}

Dint subpair(a, b)
Dint a, b;
{
    return a - b;
}

Dint sub_store_mem(out, ap, bp)
Dint *out, *ap, *bp;
{
    *out = *ap - *bp;
    return *out;
}
SRC

body_count()
{
    awk -v fn="$1" '
        $0 == fn ":" { in_fn = 1; next }
        in_fn && $0 ~ /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
        in_fn && NF { n++ }
        END { print n + 0 }
    ' "$2"
}

for cpu in pdp6 ka10 pdp10 ki10; do
    d="$TMP/$cpu"
    mkdir "$d"
    cp "$TMP/test.c" "$d/test.c"
    (cd "$d" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm="$d/test.s"

    n=$(body_count addpair "$asm")
    if [ "$n" -gt 30 ]; then
        echo "$cpu: DImode add still spills excessively ($n lines)" >&2
        exit 1
    fi

    grep -q '^subpair:' "$asm"
    grep -q '^sub_store_mem:' "$asm"
done

echo "DImode add/sub register-pressure regression passed"
