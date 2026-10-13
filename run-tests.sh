#!/usr/bin/env sh
# Restartable local PDP-10 C test runner.
# Only PDP10_PREFIX is required; tools are found below $PDP10_PREFIX/bin.
set -eu
cd "$(dirname "$0")"
. ./tools/pdp10-env.sh
pdp10_setup_env
case "${1-}" in
    verify|all)
        shift
        exec python3 tools/p10tk-suites-v1.py verify "$@"
        ;;
    das-fast|das|das-native|gcc-bare-libgcc|pdp10-tools|clean|kcc-regression|kcc-semantic|kcc-all)
        suite=$1
        shift
        exec python3 tools/p10tk-suites-v1.py "$suite" "$@"
        ;;
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
