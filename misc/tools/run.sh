#!/bin/sh
# Compatibility entry point: the per-tool special registry owns execution.
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
exec "$here/run-misc-tests.sh" pdp10-tools
