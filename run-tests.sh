#!/usr/bin/env sh
# Restartable compiler/CPU/optimization matrix runner.
# Only PDP10_PREFIX is required; tools are found below $PDP10_PREFIX/bin.
set -eu
cd "$(dirname "$0")"
. ./tools/pdp10-env.sh
pdp10_setup_env
case "${1-}" in
    list|list-kcc|list-gcc)
        suite=$1
        shift
        case "$suite" in
            list-kcc) compiler=kcc ;;
            list-gcc) compiler=gcc ;;
            *) compiler=all ;;
        esac
        exec python3 tools/run-tests.py --list-only --compiler "$compiler" --family all --cpu all --opt all "$@"
        ;;
    test|test-parallel)
        shift
        ;;
    reset)
        shift
        exec python3 tools/run-tests.py --reset --compiler all --family all --cpu all --opt all "$@"
        ;;
esac
exec python3 tools/run-tests.py "$@"
