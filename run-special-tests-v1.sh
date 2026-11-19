#!/bin/sh
# Explicit, non-matrix test selection. Native DAIMOS cases remain gated.
set -eu
cd "$(dirname "$0")"
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
exec python3 tools/run-special-tests-v1.py "$@"
