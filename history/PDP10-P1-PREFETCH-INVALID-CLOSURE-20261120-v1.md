# P1 closure: native-width invalid-address prefetch (v1)

Date: 2026-11-20. Batch 4 slot 1, original
`tests/semantic/upstream/extensions/builtin-prefetch-6.c`,
previously had only a NULL no-fault companion and was P1 **partial**.
The new freestanding source
`tests/semantic/regression/pdp10-prefetch-invalid-address-v1.c`
completes the original *test-construction intent* for PDP-6.
The original upstream source and its hash remain unchanged.

## Executed semantic contract

The historical source uses `sizeof(void *) * 8` for its one-hot
address patterns, even though PDP-10 native C has nine bits per
character. The companion deliberately uses
`sizeof(void *) * 9`, verifies a native 36-bit pointer and
`unsigned long`, and enumerates all **36** one-hot address values
followed by **29** zero entries, retaining the original loop bound
of **65**. Read and write `__builtin_prefetch` loops evaluate
each address-producing function once; the test checks the resulting
130 calls, unchanged raw source bit patterns and checksums.
None of the invalid pointers is dereferenced.

On a PDP-6 without a hardware prefetch instruction the hint may be
elided. **The compiler must still evaluate the address expressions**
and the guest must not fault. Passing this test is not evidence for
an implemented hardware prefetch instruction. It does establish
the original source's no-fault and expression-evaluation *test
oracle* without host `stdio`, `malloc`, or invented runtime stubs.

| Installed native profile | Observed status |
| --- | --- |
| GCC PDP-6 O0 | PASS |
| GCC PDP-6 O1 | PASS |
| GCC PDP-6 O2 | PASS |
| GCC PDP-6 Os | PASS |

All four reports have `rc=0`, `result=PASS`, guest HALT,
`__test_exit=0` and `fail_id=0`. The source and each actual
guest report are SHA256-pinned in
`manifests/PDP10-P1-PREFETCH-INVALID-EVIDENCE-20261120-v1.tsv` and
`refs/p10tk-p1-prefetch-invalid-evidence-20261120-v1.tar.gz`.
`tools/audit-p1-prefetch-invalid-v1.py` checks complete 65-entry
read/write coverage, all four guest reports, matrix ownership,
and the original historical SHA/state. Seven negative controls
prevent removal of profiles, false success, changed source identity
or tampered simulator evidence.

Reproduce only these four cells:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/run-tests.py \
  --source tests/semantic/regression/pdp10-prefetch-invalid-address-v1.c \
  --family native --cpu pdp6 --compiler gcc --opt all \
  --out-dir "$TMPDIR/p10tk-p1-prefetch-invalid-pdp6-20261120-v1" -j 2
python3 tools/test-p1-prefetch-invalid-v1.py
```

The existing `pdp10-prefetch-address-effects-v1.c` remains an
independent check of volatile address expressions and NULL hints.
The original KCC unresolved prefetch builtin is a **compiler/runtime
issue**, not a reason to leave test construction incomplete.

Live P1 resolution v10 therefore records this obligation as
**covered** rather than partial: 39 covered, 0 partial, 28 blocked.
Source batches v9 retain exactly the same 59 original identities
and ten-source Batch 4 assignment. The v9/v8 predecessors remain
immutable historical status snapshots.
