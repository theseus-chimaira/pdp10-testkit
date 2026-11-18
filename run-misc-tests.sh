#!/usr/bin/env sh
# Specialized compiler, ABI, assembler, and tool tests.
set -eu
cd "$(dirname "$0")"
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
. ./tools/pdp10-env.sh
pdp10_setup_env
suite=${1:-verify}
if [ "$#" -gt 0 ]; then shift; fi
if [ "$suite" = "run-id" ]; then
    if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
        echo "usage: run-misc-tests.sh run-id TEST_ID [--manual]" >&2
        exit 2
    fi
    if [ "$#" -eq 2 ] && [ "$2" != "--manual" ]; then
        echo "only --manual is accepted after TEST_ID" >&2
        exit 2
    fi
    exec python3 tools/run-misc-suites.py run-id "$@"
fi
if [ "$suite" = "list-manual" ]; then
    if [ "$#" -ne 0 ]; then
        echo "list-manual takes no arguments" >&2
        exit 2
    fi
    exec python3 tools/run-misc-suites.py list-manual
fi
if [ "$#" -ne 0 ]; then echo "unexpected arguments: $*" >&2; exit 2; fi
exec python3 tools/run-misc-suites.py "$suite"
