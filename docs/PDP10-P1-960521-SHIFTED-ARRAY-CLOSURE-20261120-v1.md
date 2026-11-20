# P1 960521 native pointer-boundary oracle (v1)

Date: 2026-11-20. Scope: generic `pdp10-testkit` only. Full compiler,
CPU and optimization sweeps are deferred. No compiler, allocator,
assembler, original historical source or sibling repository was altered.

## Original test: bounds and genuine hosted dependency

The historical `tests/todo/generic/960521-1.c` source is frozen at
SHA256 `e3fe6e96cbd7d6334c99fc332c1e3f689ca9ee1e6de498b3892c71160002ade7`.
Its default `BLOCK_SIZE=32768` needs two distinct `malloc` allocations
of 32768 native `int` values each: **65536 words total**, before
program text, runtime, heap metadata and stack. The nominal bare PDP-6
memory configuration cannot satisfy this exact request. The original
increments the `b` base pointer after storing a zero, fills `a[]` and
`b[]`, and asserts that `b[-1]` remains zero. It does not independently
assert every written array entry or guard against crossing the end.

The freshly selected installed-toolchain PDP-6 original profiles:

| Compiler/profile | Outcome |
| --- | --- |
| KCC native noopt | SIMH timeout, `rc=124`, no HALT |
| GCC native O0 | SIMH timeout, `rc=124`, no HALT |

Both original link maps contain real `malloc`, `foo`, `abort`, `exit`
and `main` definitions. The two timeouts are **not** guest assertion
failures and do not prove malloc correctness or a compiler miscompile.

## Independent compiler-semantic test

`tests/semantic/regression/pdp10-shifted-array-boundary-v1.c` tests
the original native array-indexing/pointer-adjustment behavior without
pretending that a freestanding target has a working hosted heap. Its
two real static 4096-native-word arrays occupy 8192 words of data,
well within the target. The exact `*b++ = 0`, both original loop
forms, and `b[-1]` sentinel are preserved. It additionally checks
both canaries on the structured `b[]` allocation and **all** array
values after execution. The original's full memory-capacity contract
remains a separate runtime task and is not inferred from this test.

| Companion profile | Status |
| --- | --- |
| KCC native PDP-6 noopt, opt | 2 PASS |
| GCC native PDP-6 O0, O1, O2, Os | 4 PASS |

The original/companion source SHA256s, original timeouts, six real
guest PASS/zero-exit results, linker maps and generated assembly are
pinned in `PDP10-P1-960521-SHIFTED-ARRAY-EVIDENCE-20261120-v1.tsv` and
`refs/p10tk-p1-960521-shifted-array-20261120-v1.tar.gz`.
`tools/test-p1-960521-shifted-array-v1.py` verifies 24 archived
artifacts and rejects ten negative mutations, including forged
original guest successes, changed compiler identities, unregistered
matrix cells and mutated archival evidence.

The live P1 v19 source-construction ledger records this compiler
semantic intent as covered, with an explicit unresolved
`hosted-malloc-and-large-memory-contract` follow-up. The unchanged
original remains present and its real timeouts remain failures.
No test-only heap allocator was added, and no cross-CPU success
was claimed.

For a narrowly selected retest:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-960521-pointer-boundary-20261120-v1" \
  --source tests/semantic/regression/pdp10-shifted-array-boundary-v1.c \
  --compiler all --family native --cpu pdp6 --opt all -j 6
python3 tools/test-p1-960521-shifted-array-v1.py
python3 tools/build-p1-semantic-resolution-v19.py
```
