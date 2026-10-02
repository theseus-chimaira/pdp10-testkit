#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-fp-cast-vrnarrow-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/fp-return.c" <<'SRC'
float fmul(a, b)
float a;
float b;
{
    return a * b;
}

int main()
{
    float f;
    f = fmul(2.0f, 3.0f);
    return (int)f != 6;
}
SRC

cat > "$TMP/fp-basic.c" <<'SRC'
static float ff(a, b)
float a;
float b;
{
    return (a - b) * 3.0f;
}

int main()
{
    return (int)ff(7.0f, 2.0f) != 15;
}
SRC

for cpu in pdp6 ka10 ki10 ks10 base pdp10; do
    d="$TMP/$cpu"
    mkdir -p "$d"
    cp "$TMP/fp-return.c" "$d/fp-return.c"
    cp "$TMP/fp-basic.c" "$d/fp-basic.c"
    (cd "$d" && "$KCC" -S -v=nostats -x="$cpu" fp-return.c >/dev/null)
    (cd "$d" && "$KCC" -S -v=nostats -n -x="$cpu" fp-return.c >/dev/null)
    (cd "$d" && "$KCC" -S -v=nostats -x="$cpu" fp-basic.c >/dev/null)
    (cd "$d" && "$KCC" -S -v=nostats -n -x="$cpu" fp-basic.c >/dev/null)
done

echo "floating cast vrnarrow regression passed"
