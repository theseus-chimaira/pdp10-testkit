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
if [ "$#" -ne 0 ]; then echo "unexpected arguments: $*" >&2; exit 2; fi
exec python3 tools/run-misc-suites.py "$suite"
