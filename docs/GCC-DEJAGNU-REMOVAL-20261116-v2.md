# GCC DejaGNU removal and test ownership (2026-11-16 v2)

## Scope

The PDP-10 GCC 3.2 distribution no longer carries the DejaGNU compiler
test suite (`gcc/testsuite/`, 7,789 tracked files) or the DejaGNU-backed
C++ library test suite (`libstdc++-v3/testsuite/`, 240 files).  The old
`mkcheck.in` and `testsuite_flags.in` test drivers were also removed.
All original files remain recoverable from GCC revision `b0f5374`.

The separate `libiberty/testsuite` demangler regression does not use
DejaGNU; it remains part of the independent libiberty source contract.

GCC's Makefile no longer generates `site.exp` or runs `runtest`.
Its obsolete `check` targets reject invocation with a pointer to
`pdp10-testkit`; they do not silently pass. The top-level Makefile
no longer builds, checks, installs, or packages DejaGNU. The C++
library Makefile and configure script no longer descend into the
removed testsuite.

The former C++ `testsuite_flags.in` also supplied a production include
path contract to the top-level GCC build.  That non-test dependency
was preserved in `libstdc++-v3/build_includes.in`, with the same
`--build-includes` invocation and without DejaGNU.

## PDP-10 regression ownership

The 18 previously reviewed target artifacts (14 C, four shell)
are preserved unchanged under `refs/gcc-pdp10-target-v2/`.
Twelve source files have a DejaGNU-free, explicitly registered
`validation` runner: `misc/validation/test-gcc-target-codegen-v2.py`.
The new runner uses the original optimization and CPU options and
asserts the expected and forbidden assembler patterns. Historical
`dg-*` directives survive as source comments only; the runner does
not interpret them.

The remaining two C files are companion inputs for four historical
shell probes. Subsequent static ownership work has registered three
preserved probes with explicit current source paths: libgcc byte-pointer
octal tables, freestanding static-member exclusions, and 71/72-bit
mode-selection macros. The fourth probe (`bare-dlink-libgcc.sh`) is
covered by the stronger pre-existing `badl-tables` registration, which
also tests direct driver linking and guest execution. See
`docs/GCC-TARGET-SHELL-OWNERSHIP-20261116-v3.md` for the precise
crosswalk. The new registrations have **not been executed** yet. No old
test is counted as passing merely because its source was preserved.

The ITS-only CIRC test was previously deleted as not applicable to
DAIMOS and was neither copied nor converted to a different test.

## Historical feasibility review

The other unreviewed GCC cases are not automatically imported. Their
original sources are accessible from GCC Git revision `b0f5374`.
`tools/audit-gcc-c-feasibility-v1.py` reads those source blobs directly
from the Git object database, preserving a reproducible review queue
despite the working-tree deletion. The existing
`GCC-C-FEASIBILITY-PREFLIGHT-20261116-v1.tsv` contains 693 cases
without byte-identical central source matches; it remains a source
review inventory, not execution evidence. Check native PDP-10
36-bit/9-bit layouts, non-IEEE floating point, ISA, libc requirements,
and original assertions before any future activation.

The earlier `CROSS-REPO-TEST-CENSUS-20261116-v1.*` files are historical
source snapshots. Their GCC test counts no longer describe the live
checkout, but their recorded provenance remains valid.
