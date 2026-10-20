#!/bin/sh
# Verify full KCPP/KPARSE/KGEN/KOPT transport of exact PDP-10 floats.
# This checks the float precision and guest behavior, independent of the
# general KIR1 byte-identity regression (which remains a manual blocker).
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
source_root=${KCC_SOURCE:-$HOME/git/kcc}
hostcc=${HOSTCC:-cc}
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-kpcode2-float-phase-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work/bin"

host_adapter="$root/misc/kcc-regression/host-daimos-path-v1.c"
cpp_src='cc.c ccasmb.c ccdata.c ccerr.c ccout.c ccpp.c ccppout.c ccsym.c ccsrc.c'
parse_src='cc.c ccasmb.c ccdata.c ccdbug.c ccdecl.c ccerr.c cceval.c cclex.c ccnode.c ccppin.c ccstmt.c ccsym.c cctype.c ccoututil.c cckirwrite.c ccbind.c ccvla.c'
gen_src='cc.c ccasmb.c cccreg.c cccse.c cccode.c ccdata.c ccdbug.c ccerr.c cceval.c ccgen.c ccgen1.c ccgen2.c ccgswi.c ccjskp.c ccnode.c ccreg.c ccsym.c cctype.c ccopt.c ccoututil.c cckpwrite.c cckpout.c cckirread.c ccvla.c'
opt_src='cckopt.c cckpread.c ccout.c ccoututil.c ccdata.c ccerr.c ccasmb.c'

build_phase()
{
    executable=$1
    phase_def=$2
    shift 2
    (
        cd "$source_root"
        # shellcheck disable=SC2086
        "$hostcc" -std=c99 -funsigned-char -O2 -DHOST_DAIMOS=1 \
            -DHOST_UNIX=0 "$phase_def" "$@" "$host_adapter" \
            -o "$work/bin/$executable"
    )
}

echo 'Building KPCODE2 four-phase host compiler'
# shellcheck disable=SC2086
build_phase kcpp -DKCC_PHASE_CPP=1 $cpp_src
# shellcheck disable=SC2086
build_phase kparse -DKCC_PHASE_PARSE=1 $parse_src
# shellcheck disable=SC2086
build_phase kgen -DKCC_PHASE_GEN=1 $gen_src
# shellcheck disable=SC2086
build_phase kopt -DKCC_PHASE_OPT=1 $opt_src

source="$root/tests/semantic/kcc-pdp6-float-fold-v1.c"
for mode in opt noopt; do
    flag=-O
    [ "$mode" = noopt ] && flag=-n
    echo "KPCODE2 four-phase PDP-6 float test: $mode"
    (
        cd "$source_root"
        "$work/bin/kcpp" -Pgnu99 "$flag" -x=pdp6 -m=gas \
            "$source" >"$work/$mode.kpt"
    )
    "$work/bin/kparse" -Pgnu99 "$flag" -x=pdp6 -m=gas -S \
        "$work/$mode.kpt" -o "$work/$mode.kir"
    "$work/bin/kgen" -Pgnu99 "$flag" -x=pdp6 -m=gas -S \
        "$work/$mode.kir" -o "$work/$mode.kp2"
    "$work/bin/kopt" "$work/$mode.kp2" -o "$work/$mode.s"
    if ! grep -q '0234400000002' "$work/$mode.s"; then
        echo "KPCODE2 lost target 27-bit floating-point precision" >&2
        exit 1
    fi
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 900000 --timeout 35 \
        --workdir "$work/run-$mode" --name "kpcode2-float-$mode-v1" \
        --expect __test_exit=0 --expect kff_case_v1=024 \
        --expect kff_cmp_v1=1 \
        "$root/support/crt0-upstream-v1.s" \
        "$work/$mode.s" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    echo "PASS KPCODE2 target-precision phase guest ($mode)"
done
