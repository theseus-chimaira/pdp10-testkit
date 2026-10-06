#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
: "${KCC_SOURCE:?KCC_SOURCE must point to the KCC tree}"
: "${PDP10_PREFIX:?PDP10_PREFIX must be set}"

HOSTCC=${HOSTCC:-cc}
root=$(CDPATH= cd -- "$KCC_SOURCE" && pwd -P)
work="$TMPDIR/kcc-phase-byte-identity-20261006-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work/bin" "$work/int" "$work/split" "$work/kpt"
mkdir -p "$work/kir" "$work/kp1" "$work/kp1-kir" "$work/kopt" "$work/kopt-kir"

all_src='cc.c ccasmb.c cccreg.c cccse.c cccode.c ccdata.c ccdbug.c ccdecl.c ccerr.c cceval.c ccgen.c ccgen1.c ccgen2.c ccgswi.c ccjskp.c cclex.c ccnode.c ccout.c ccoututil.c ccpp.c ccreg.c ccstmt.c ccsym.c cctype.c ccopt.c ccvla.c'
cpp_src='cc.c ccasmb.c ccdata.c ccerr.c ccout.c ccpp.c ccppout.c ccsym.c'
core_src='cc.c ccasmb.c cccreg.c cccse.c cccode.c ccdata.c ccdbug.c ccdecl.c ccerr.c cceval.c ccgen.c ccgen1.c ccgen2.c ccgswi.c ccjskp.c cclex.c ccnode.c ccout.c ccoututil.c ccreg.c ccstmt.c ccsym.c cctype.c ccopt.c ccppin.c ccvla.c'
kparse_src='cc.c ccasmb.c ccdata.c ccdbug.c ccdecl.c ccerr.c cceval.c cclex.c ccnode.c ccppin.c ccstmt.c ccsym.c cctype.c ccoututil.c cckirwrite.c ccvla.c'
kgen_src='cc.c ccasmb.c cccreg.c cccse.c cccode.c ccdata.c ccdbug.c ccerr.c cceval.c ccgen.c ccgen1.c ccgen2.c ccgswi.c ccjskp.c ccnode.c ccreg.c ccsym.c cctype.c ccopt.c ccoututil.c cckpwrite.c cckpout.c cckirread.c ccvla.c'
kopt_src='cckopt.c cckpread.c ccout.c ccoututil.c ccdata.c ccerr.c ccasmb.c'

have_kgen=0
if [ -f "$root/cckpout.c" ] && [ -f "$root/cckopt.c" ]; then
    have_kgen=1
fi
have_kparse=0
if [ -f "$root/cckirwrite.c" ] && [ -f "$root/cckirread.c" ]; then
    have_kparse=1
fi
if [ "${KCC_REQUIRE_KGEN:-0}" = 1 ] && [ "$have_kgen" != 1 ]; then
    echo 'phase-byte-identity: required KGEN/KOPT sources are missing' >&2
    exit 1
fi
if [ "${KCC_REQUIRE_KPARSE:-0}" = 1 ] && [ "$have_kparse" != 1 ]; then
    echo 'phase-byte-identity: required KPARSE/KIR1 sources are missing' >&2
    exit 1
fi

build_host_phase()
{
    out=$1
    defs=$2
    shift 2
    (
        cd "$root"
        # shellcheck disable=SC2086
        "$HOSTCC" -std=c99 -funsigned-char -O2 \
            -DHOST_DAIMOS=1 -DHOST_UNIX=0 $defs "$@" -o "$out"
    )
}

# shellcheck disable=SC2086
build_host_phase "$work/bin/kcc-integrated-v1" '' $all_src
# shellcheck disable=SC2086
build_host_phase "$work/bin/kcpp-v1" '-DKCC_PHASE_CPP=1' $cpp_src
# shellcheck disable=SC2086
build_host_phase "$work/bin/kcc1-v1" '-DKCC_PHASE_CORE=1' $core_src
if [ "$have_kgen" = 1 ]; then
    # shellcheck disable=SC2086
    build_host_phase "$work/bin/kgen-v1" '-DKCC_PHASE_GEN=1' $kgen_src
    # shellcheck disable=SC2086
    build_host_phase "$work/bin/kopt-v1" '-DKCC_PHASE_OPT=1' $kopt_src
fi
if [ "$have_kparse" = 1 ]; then
    # shellcheck disable=SC2086
    build_host_phase "$work/bin/kparse-v1" '-DKCC_PHASE_PARSE=1' $kparse_src
fi

run_mode()
{
    mode=$1
    total=0
    for src in $all_src; do total=$((total + 1)); done
    case "$mode" in
    opt) optflag=-O ;;
    noopt) optflag=-n ;;
    *) echo "bad mode: $mode" >&2; exit 2 ;;
    esac

    n=0
    for src in $all_src; do
        b=${src%.c}
        n=$((n + 1))
        printf 'phase-byte-identity %s [%02d/%02d] %s\n' "$mode" "$n" "$total" "$src"

        common="-Pgnu99 $optflag -x=pdp6 -m=gas -DHOST_DAIMOS=1 -DHOST_UNIX=0 -Iself/include/ -Hself/include/"
        (
            cd "$root"
            # shellcheck disable=SC2086
            "$work/bin/kcc-integrated-v1" $common -S "$src" \
                -o "$work/int/$b-$mode.s" >/dev/null
            # shellcheck disable=SC2086
            "$work/bin/kcpp-v1" $common "$src" > "$work/kpt/$b-$mode.kpt"
        )
        "$work/bin/kcc1-v1" -Pgnu99 "$optflag" -x=pdp6 -m=gas -S \
            "$work/kpt/$b-$mode.kpt" -o "$work/split/$b-$mode.s" >/dev/null

        if ! cmp -s "$work/int/$b-$mode.s" "$work/split/$b-$mode.s"; then
            echo "phase-byte-identity: mismatch for $src ($mode): integrated vs KCPP/KCC1" >&2
            diff -u "$work/int/$b-$mode.s" "$work/split/$b-$mode.s" | sed -n '1,160p' >&2 || true
            exit 1
        fi

        if [ "$have_kgen" = 1 ] && [ "$have_kparse" != 1 ]; then
            "$work/bin/kgen-v1" -Pgnu99 "$optflag" -x=pdp6 -m=gas -S \
                "$work/kpt/$b-$mode.kpt" -o "$work/kp1/$b-$mode.kp1" >/dev/null
            "$work/bin/kopt-v1" "$work/kp1/$b-$mode.kp1" \
                -o "$work/kopt/$b-$mode.s"
            if ! cmp -s "$work/int/$b-$mode.s" "$work/kopt/$b-$mode.s"; then
                echo "phase-byte-identity: mismatch for $src ($mode): integrated vs KCPP/KGEN/KOPT" >&2
                diff -u "$work/int/$b-$mode.s" "$work/kopt/$b-$mode.s" | sed -n '1,160p' >&2 || true
                exit 1
            fi
        fi
        if [ "$have_kparse" = 1 ] && [ "$have_kgen" = 1 ]; then
            "$work/bin/kparse-v1" -Pgnu99 "$optflag" -x=pdp6 -m=gas -S \
                "$work/kpt/$b-$mode.kpt" -o "$work/kir/$b-$mode.kir" >/dev/null
            "$work/bin/kgen-v1" -Pgnu99 "$optflag" -x=pdp6 -m=gas -S \
                "$work/kir/$b-$mode.kir" -o "$work/kp1-kir/$b-$mode.kp1" >/dev/null
            "$work/bin/kopt-v1" "$work/kp1-kir/$b-$mode.kp1" \
                -o "$work/kopt-kir/$b-$mode.s"
            if ! cmp -s "$work/int/$b-$mode.s" "$work/kopt-kir/$b-$mode.s"; then
                echo "phase-byte-identity: mismatch for $src ($mode): integrated vs KCPP/KPARSE/KGEN/KOPT" >&2
                diff -u "$work/int/$b-$mode.s" "$work/kopt-kir/$b-$mode.s" | sed -n '1,160p' >&2 || true
                exit 1
            fi
        fi
    done
}

run_mode opt
run_mode noopt
echo 'kcc-phase-byte-identity: PASS'
