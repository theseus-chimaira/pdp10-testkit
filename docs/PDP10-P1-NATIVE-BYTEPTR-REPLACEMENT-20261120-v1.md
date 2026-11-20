# Native PDP-10 byte-pointer matrix replacement (2026-11-20, v1)

The imported `tests/semantic/upstream/extensions/old.tort.c` has
been **deleted**. There is no preserved copy in the active source tree
and no additional compiler test pointing to it. The current executable
replacement is the single C89 source:

    tests/semantic/regression/pdp10-byte-pointer-torture-v1.c

It contains no system-specific operating-system branches, 8-bit-byte
expectations, formatted I/O, allocation, or hosted includes. It uses
native PDP-10 C storage units: 9-bit character, 18-bit short and
36-bit word. It returns zero on success, calls the real bare-metal
`abort` on any mismatch, and records the exact failure in `fail_id`.

The test checks `unsigned char *`, `unsigned short *` and
`unsigned long *` separately, converting through `void *` and back
across a function-pointer call; it checks pointer identity, loaded
values, element stepping, array members, mixed-structure members,
and active union members. No unrelated-type aliasing is used.

## Normal compiler matrix

The original matrix row was removed; one `semantic-regression`
row now owns the new source. PDP-6 has two scheduled KCC profiles
(opt and noopt) and four GCC profiles (O0, O1, O2, Os). Known failures
are recorded with the runnable `fail` status, not hidden as
`unsupported` or unregistered. Other native CPU/optimization
profiles are `pending`, not claimed to have passed.

Six real installed-toolchain PDP-6 runs through the **normal**
`tools/run-tests.py` runner give:

| Profile | Result | `fail_id` (octal) | Failed assertion |
| --- | --- | --- | --- |
| KCC noopt | run_fail | 012 | first scalar byte pointer identity |
| KCC opt | run_fail | 014 | first scalar halfword pointer identity |
| GCC O0 | run_fail | 025 | first array byte pointer data readback |
| GCC O1 | run_fail | 034 | halfword array next-element pointer |
| GCC O2 | run_fail | 034 | halfword array next-element pointer |
| GCC Os | run_fail | 034 | halfword array next-element pointer |

All six actually HALT with `rc=0`, nonzero `__test_exit` and
`fail_id`. These are completed guest assertion failures, not step
or wall-clock timeouts, and the test was **not weakened** to make any
compiler pass.

Focused reproduction:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/run-tests.py \
  --source tests/semantic/regression/pdp10-byte-pointer-torture-v1.c \
  --family native --cpu pdp6 --compiler all --opt all \
  --out-dir "$TMPDIR/p10tk-native-byteptr-replacement-matrix-20261120-v1" \
  -j 2
python3 tools/test-p1-native-byteptr-replacement-v1.py \
  --failures "$TMPDIR/p10tk-native-byteptr-replacement-matrix-20261120-v1/failures.tsv"
```

The six-cell run intentionally exits nonzero because the actual
compilers fail. The host verifier must pass and proves all six
runtime failures with real linker/simulator reports. It has five
negative controls for matrix ownership, dropped cells, duplicate
registration, false P1 closure and changed batch assignment.

## Historical evidence is not the replaced source

The deleted source had SHA256:

    c4476261cb571a4e2666da59d8fc8438f7d0e6acebd1570ca955e20d05f3c96c

The replacement's SHA256 is:

    2b7543b425ffa690cd73848b581bb18791989d07af5d7372969664cea1bfe534

The historical P1 classifications and archived compiler logs are
unchanged. `tools/p1_source_replacement_v1.py` implements an exact,
single-source migration rule: it requires the old path to be **absent**
and requires the new path to match its pinned SHA256. It rejects
arbitrary edits or other source substitutions.

The live `PDP10-P1-SEMANTIC-RESOLUTION-20261120-v9.tsv` and
`PDP10-P1-SOURCE-BATCHES-20261120-v8.tsv` preserve the frozen
historical 67-source and 59-batch identities, but explicitly point
the current follow-up to the new test. Batch 6 slot 3 remains
`blocked`: new compiler failures are actual evidence, not testkit
acceptance. Active batch probing resolves the retired source identity
to the new canonical file. Historical old-source results must **never**
be used to claim failure/pass of the replacement.

This is testkit source and registration work only. No compiler,
assembler, runtime implementation, imported test elsewhere, or
DAIMOS kernel source was modified. The full sweep remains deferred.
