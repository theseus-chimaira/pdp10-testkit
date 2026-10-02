#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

tmp=${TMPDIR:-/tmp}/kcc-pp-undef.$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat >"$tmp/pp-undef.c" <<'EOF'
#define DAIMON_MRES_DRIVER_RUNTIME_ONLY 1
#undef DAIMON_MRES_DRIVER_RUNTIME_ONLY
#ifndef DAIMON_MRES_DRIVER_RUNTIME_ONLY
int pp_undef_ok(void)
{
    return 1;
}
#else
#error undef failed
#endif

#define CONFIGFS_MUTATION_ONLY 1
#undef CONFIGFS_MUTATION_ONLY
#ifndef CONFIGFS_MUTATION_ONLY
int pp_second_undef_ok(void)
{
    return 1;
}
#endif
EOF

(
    cd "$tmp"
    "$OLDPWD/kcc" -E -x=pdp6 pp-undef.c >pp-undef.i 2>pp-undef.err
)
grep 'pp_undef_ok' "$tmp/pp-undef.i" >/dev/null
grep 'pp_second_undef_ok' "$tmp/pp-undef.i" >/dev/null

echo "undef preprocessor regression passed"
