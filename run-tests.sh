#!/usr/bin/env sh
# Restartable local PDP-10 C test runner.
# Only PDP10_PREFIX is required; tools are found below $PDP10_PREFIX/bin.
set -eu
cd "$(dirname "$0")"
. ./tools/pdp10-env.sh
pdp10_setup_env
exec python3 tools/run-tests.py "$@"
