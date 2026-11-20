# GCC PDP-10 two-host-byte string builtin folding repair (v1)

Date: 2026-11-20. Only the owning `gcc-pdp10` compiler and
`pdp10-testkit` were modified. The full compiler/CPU/optimization
sweep remains deferred. No DAIMOS libc or fake string provider was
selected. Historical compiler failures are preserved unchanged.

## Diagnosed GCC implementation defect

Narrow PDP-10 9-bit literal `STRING_CST` nodes store **two host
bytes per target character** so values `0400..0777` survive host
8-bit `char` storage. The original GCC 3.2 `gcc/builtins.c` generic
`c_strlen()` instead called host `strlen()` on these raw bytes.
The first host byte for the ASCII space in `" a b"` is zero, so
the compiler incorrectly inferred target length zero and transformed
`strcpy(dest, " a b")` into a *one-character* `memcpy`.

The original independent native PDP-6 literal test had three actual
GCC O1/O2/Os `run_fail`, `fail_id=3` (missing `'a'`), and the
original space-token scanner had three matching optimized GCC
`run_fail`, `fail_id=8` (first token pointer). Their immutable
original evidence is in
`PDP10-P1-980707-SPACE-TOKEN-CLOSURE-20261120-v1.md` and its
archived per-guest reports.

The compiler correction uses the `PDP10_STRING_CST_9BIT_P` flag to
compute logical string lengths and read the real 9-bit NUL, not
the leading host zero of ordinary ASCII characters. All indexes
and offsets in the calculation are **target-character units**.
The compiler's generic `c_getstr` now declines raw-host `strcmp`,
`strchr` and related folds on the two-byte representation: it is
not a usable host C string. These operations remain real target C
calls or use other correct target-level transformations. Short
`memcpy` of literal strings still uses the PDP-10-aware
`pdp10_builtin_string_data_init` and store callback, not the
unsafe host string access. No runtime library function was replaced.

Rebuilt the installed PDP-10 GCC 3.2 `cc1` with the GCC tree's
GNU89 host-compiler flags and installed the resulting executable
under `$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/cc1`.
The previous executable was preserved in a versioned `$TMPDIR`
backup. The original compiler binary SHA256 is
`d43034a6151e57787514ff6293b6d8da846de34a6192766d701505dab1eb6cc8`;
the corrected installed binary SHA256 is
`0c33d1e7e93dd372e8b503aabf167c3299acdd830b289199c679ca07a7529b8a`.
The corrected `gcc/builtins.c` source SHA256 is
`32d2e6d1c375d8d313ecfb59fb0455f03aebc0338efeecb409d4a5c718e13513`.

## Real native PDP-6 results

An independent C89 normal-matrix source,
`pdp10-builtin-string9-constant-v1.c`, checks `strlen` for ASCII,
embedded NUL, offsets and `0400..0777` characters; constant
`strcmp`/`strncmp`/`memcmp` with 9-bit values; and volatile
reads of `strcpy` output including the NUL terminator.
The *old* compiler was explicitly reinstalled for one focused
baseline run, and the corrected `cc1` restored immediately.

| Native guest source | GCC O0 | GCC O1 | GCC O2 | GCC Os |
| --- | --- | --- | --- | --- |
| New string9 oracle, **old** cc1 | `run_fail` ID 1 | `run_fail` ID 1 | `run_fail` ID 1 | `run_fail` ID 1 |
| New string9 oracle, **corrected** cc1 | PASS | PASS | PASS | PASS |
| Existing literal `strcpy` oracle, corrected | PASS | PASS | PASS | PASS |
| Existing space-token pointer scanner, corrected | PASS | PASS | PASS | PASS |

All native outcomes came from actual PDP-6 SIMH guest execution,
with `__test_exit=0` and `fail_id=0` for corrected GCC PASS. The
original before-fix failures remain real, not retroactively PASS.
Optimized GCC `strcpy` assembly now copies all **five** target bytes,
including the NUL terminator, rather than emitting one `DPB`.
All target runtime cells retain compiler-owned `libp10c-v2.a`.

**Separate KCC finding:** The new 9-bit constant oracle was also
executed with KCC noopt and opt; both `run_fail` at `fail_id=6`
(`strlen("\\400x") == 2`). KCC emits that literal as a string
beginning with byte zero, truncating `0400` rather than storing a
9-bit code unit. Its own native compiler/literal implementation
needs investigation. This is **not** a failure of the repaired GCC
optimizer, nor a reason to disable the KCC test or change its
assertions. Both genuine KCC failures remain scheduled.

## Evidence and follow-up limits

`docs/PDP10-GCC-STRING9-FOLD-REPAIR-EVIDENCE-20261120-v1.tsv`
pins **18** original/new source/profile results and source/executable
identities, and hashes every raw status, log, assembly, linker map
and simulator report. The versioned archive
`refs/p10tk-gcc-string9-fold-repair-20261120-v1.tar.gz`
contains **90** raw artifacts, SHA256
`11305bc5fd7ded5e224696f9ddcfb123e9538497be343c54ec4dbfeff8e34e85`.

`tools/test-gcc-string9-fold-repair-v1.py` checks all source
identities, exact matrix registrations, compiler binary hashes,
real guest HALTs, octal `fail_id` and exit values, optimized code
emitting a five-byte copy, the separate KCC high-octal truncation,
all 90 artifact hashes and 11 negative controls.

The unchanged `980707-1.c` original still lacks a real hosted
`isspace` provider and target `ctype.h`; no original hosted program
is claimed to pass. This closes the *observed* optimized GCC
`strcpy` code-generation defect and more broadly validates these
9-bit builtins on PDP-6 only. Other CPU targets and full hosted
string/ctype services are not verified. P1 source-construction
counts remain **54 covered / 13 blocked**, and frozen batches
**46 covered / 13 blocked**.

Run only the focused commands below; the KCC portion of the new
string9 test is expected to return nonzero due to its separate bug:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
./run-tests.sh --out-dir "$TMPDIR/p10tk-gcc-strcpy-fixed-pdp6-20261120-v1" \
  --source tests/semantic/regression/pdp10-strcpy-space-literal-v1.c \
  --compiler gcc --family native --cpu pdp6 --opt all -j 4
./run-tests.sh --out-dir "$TMPDIR/p10tk-gcc-token-fixed-pdp6-20261120-v1" \
  --source tests/semantic/regression/pdp10-space-token-pointer-v1.c \
  --compiler gcc --family native --cpu pdp6 --opt all -j 4
./run-tests.sh --out-dir "$TMPDIR/p10tk-string9-builtin-fixed-20261120-v1" \
  --source tests/semantic/regression/pdp10-builtin-string9-constant-v1.c \
  --compiler gcc --family native --cpu pdp6 --opt all -j 4
python3 tools/test-gcc-string9-fold-repair-v1.py
python3 tools/build-p1-semantic-resolution-v27.py
python3 tools/audit-p1-source-batches-v26.py
```
