# DAS tests

This directory owns DAS assembler regressions.  Generic `pdp10-tools`
regressions live under `tests/pdp10-tools`; the assembler source tree contains
build/install logic only.

Run the fast suite with:

    make PDP10_PREFIX=/usr/local DAS_ROOT=../das test-das-fast

Run the complete suite with:

    make PDP10_PREFIX=/usr/local DAS_ROOT=../das test-das

Build and execute the native two-phase DAS chain under DAIMOS with:

    make PDP10_PREFIX=/usr/local DAS_ROOT=../das DAIMOS_REPO=../DAIMOS \
        test-das-native

The native test installs DAS, DAS1 and DAS2 into a fresh D6FS boot image,
assembles an S6REC source through the public DAS driver, then executes the
resulting DXR image under DAIMOS.

`DAS_ROOT` must name a DAS source checkout.  The testkit builds the host tools
there before running the suite.  Set `TMPDIR` to a writable temporary directory;
the DAS tests do not assume `/tmp` exists.  Tests keep their temporary output
outside the DAS source tree.
