#!/bin/sh
# Verify bare GCC links and executes all PDP-10 byte-pointer difference tables.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
PDP10_PREFIX=${PDP10_PREFIX:?set PDP10_PREFIX to the rebuilt toolchain prefix}
GCC=$PDP10_PREFIX/bin/pdp10-dec-none-gcc
P10RUN=$PDP10_PREFIX/bin/p10run
SRC=$ROOT/tests/semantic/validation-gcc/bare-runtime/badl-tables.c
CRT0=$ROOT/support/crt0.s
TMPBASE=${TMPDIR:-$ROOT/workdir}
TMP=$TMPBASE/gcc-badl-tables-v2-$$

mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

[ -x "$GCC" ] || { echo "compiler not found: $GCC" >&2; exit 1; }
[ -x "$P10RUN" ] || { echo "p10run not found: $P10RUN" >&2; exit 1; }
# The ordinary run-misc-tests.sh dispatcher exports PDP10_PREFIX, not
# individual SIMH paths.  Use the same installed default executables as
# p10run, while allowing explicit simulator paths for candidate testing.
SIMH_PDP6=${SIMH_PDP6:-$PDP10_PREFIX/bin/pdp6}
SIMH_KA=${SIMH_KA:-$PDP10_PREFIX/bin/pdp10-ka}
[ -x "$SIMH_PDP6" ] || { echo "PDP-6 emulator not executable: $SIMH_PDP6" >&2; exit 1; }
[ -x "$SIMH_KA" ] || { echo "KA10 emulator not executable: $SIMH_KA" >&2; exit 1; }

# Direct p10run must never inherit the OS libc.a. Preserve the installed
# GCC driver/link test above; isolate only the simulator-linked guests.
compiler_prefix=$(
        P10TK_BADL_RUNTIME_OUT="$TMP" \
        PYTHONPATH="$ROOT/tools${PYTHONPATH:+:$PYTHONPATH}" \
        python3 -c 'import os
from compiler_stdlib_prefix_v1 import prepare_script_prefix
print(prepare_script_prefix(os.environ["P10TK_BADL_RUNTIME_OUT"],
                            os.environ["PDP10_PREFIX"], "gcc"))'
)

PATH=$PDP10_PREFIX/bin:$PATH
export PATH PDP10_PREFIX SIMH_PDP6 SIMH_KA

"$GCC" -O2 -march=pdp6 -S "$SRC" -o "$TMP/badl.s"
for sym in '%BADL6' '%BADL7' '%BADL8' '%BADL9' '%BADLH'; do
        grep "$sym" "$TMP/badl.s" >/dev/null || {
                echo "missing generated helper reference: $sym" >&2
                exit 1
        }
done

# This direct driver link verifies that dlink receives libgcc.a without a
# testkit-local helper copy.  Runtime execution below checks table contents.
"$GCC" -O2 -march=pdp6 "$SRC" -o "$TMP/badl-direct.dxr"
test -s "$TMP/badl-direct.dxr"

# Resolve tool provenance before overriding PDP10_PREFIX for the guest:
# some POSIX shells expand multiple leading assignments in sequence.
installed_assembler=$PDP10_PREFIX/bin/pdp10-dec-none-as
installed_dlink=$PDP10_PREFIX/bin/dlink
for machine in pdp6 ka10; do
        work=$TMP/run-$machine
        mkdir -p "$work"
        PDP10_PREFIX="$compiler_prefix" \
        PDP10_GCC="$GCC" \
        PDP10_AS="$installed_assembler" \
        PDP10_DLINK="$installed_dlink" \
        "$P10RUN" --machine "$machine" --mode deposit --exec-mode step \
                --step-limit 200000 --timeout 30 \
                --workdir "$work" --name badl-tables-$machine \
                --gcc-extra -O2 --gcc-extra -march=pdp6 \
                --expect __test_exit=0 --report "$work/report.txt" \
                "$CRT0" "$SRC"
        grep '^result=PASS$' "$work/report.txt" >/dev/null
        case "$machine" in
        pdp6) grep "^simh=$SIMH_PDP6$" "$work/report.txt" >/dev/null ;;
        ka10) grep "^simh=$SIMH_KA$" "$work/report.txt" >/dev/null ;;
        esac
        grep "^gcc=$GCC$" "$work/report.txt" >/dev/null
        grep "^assembler=$PDP10_PREFIX/bin/pdp10-dec-none-as$" "$work/report.txt" >/dev/null
        grep "^dlink=$PDP10_PREFIX/bin/dlink$" "$work/report.txt" >/dev/null
done

echo "PDP-10 bare libgcc BADL table regression passed"
