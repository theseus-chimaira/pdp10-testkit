# GCC packed-record byte-pointer ABI: compiler correction (2026-11-18, v5)

## Source and scope

This follow-up starts from the v4 testkit checkpoint `f9bd104` and
repairs the still-failing real `misc/compat/packed-char.c` oracle.
The compiler change is committed/pushed in `pdp10-gcc` as `c099c40`.
The original C source, its `sizeof` checks, its pointer arithmetic
and its executed field assertions are unchanged.

The new GCC-only companion
`misc/compat/gcc-packed-record-pointer-v1.c` adds checked writes
through a packed three-character record pointer, a record-pointer
increment across a word boundary, pointer-based reads, and
constant-array-index reads of every field in the two selected records.
The registered `test-gcc-packed-record-pointer-v1.sh` executes both
the original and new tests; no assertion or failure is suppressed.

## Three cooperating root causes

1. `pdp10_md_array_offset` padded constant-index records whose bit
   size did not divide 36. A packed three-character record has
   `sizeof==3`, so its bit stride must be 27, not 36. GCC formerly
   placed successive records at separate word addresses, while
   record-pointer arithmetic advanced by three 9-bit bytes.
2. The ordinary `COMPONENT_REF` expansion flattened subbyte record
   fields to word-aligned memory plus a relative field position. This
   lost the byte position already encoded in the pointer's P/S field.
   Consequently, later optimization could collapse different field
   reads, and stores through a pointer could overwrite the wrong bytes.
   The repair constructs a true QImode byte-addressed MEM at the
   `expand_expr` read path and the `expand_assignment` write path
   for nonvolatile explicitly packed 9-bit record fields. Static
   constant array-field reads use the same early address construction.
   This happens **before** the optimizer, not as an output-time
   replacement of already merged loads or stores.
3. At `-O0`, when a record byte pointer lived in a stack slot, the
   dynamic address constructor discarded its P/S selector and
   installed a fixed byte selector relative to the right-half word
   address. Its indirect-reference path now also accepts a pointer
   loaded from memory, preserving the complete encoded pointer before
   applying the field's byte increment.

The repair is limited to explicit packed 9-bit record fields and
their actual pointer/array addressing. Ordinary word pointers,
nonpacked records and independently handled scalar 6/7/8-bit
array padding retain their established behavior. Volatile access
semantics are not newly claimed by this targeted validation.

## Targeted verification and deployment

The independently built compiler passed **32/32 target-executed cells**:
PDP-6, KA10, KI10 and KS10, each at `-O0/-O1/-O2/-Os`, for both the
unchanged original and the new stricter companion source.
Additional separately executed PDP-6 compiler checks passed:
`packed-bitptr.c` at `-O1`, `packed-bitptr-arith.c` at `-O1`,
and `pdp10-gcc-char-word-boundary-v45.c` at four optimization levels
(six more cells). The first extended test was proven discriminating:
without the early write fix it failed with `__test_exit=025`
(octal), and with only that fix it still failed on a static read
(`__test_exit=040`). The final change passes both original oracles.

The repaired compiler is installed at
`$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/cc1` with SHA256
`d43034a6151e57787514ff6293b6d8da846de34a6192766d701505dab1eb6cc8`.
Its previous installed binary remains as
`cc1.pre-packed-record-20261118-v1` in the same directory. The
driver, assembler, linker and runtime libraries were not replaced.
The new registered 32-cell cross-CPU/optimization suite also
passed **32/32** using this operational installation. Operational
`packed-char`, `packed-bitptr` and `packed-bitptr-arith`
compatibility scripts passed, as did a targeted eight-script
interoperability smoke batch (mixed compiler runtime helpers,
mixed variadic ABI, GCC 71-bit arithmetic, cross-word bit fields,
aggregate stack ABI, installed freestanding archive, KCC DImode
scratch preservation and GCC VLA ICE compilation).

Staged per-cell logs remain under
`$TMPDIR/p10tk-gcc-packed-4cpu-4opt-20261118-v1`;
independent neighbor logs are in
`$TMPDIR/p10tk-gcc-packed-neighbor-staged-v1`.
The registered operational 32-cell run records its console log at
`$TMPDIR/p10tk-gcc-packed-record-operational-20261118-v1.log`.

## Still unresolved

- The original variable-sized variadic-aggregate runtime oracle
  `20020412-1.c` remains deferred even though the separate compiler
  ICE is fixed. Its runtime aggregate-copy path must be checked
  against the actual 9-bit byte-pointer `memcpy` ABI.
- Remaining hosted `printf`, `sprintf`, `malloc` dependencies
  and unsupported historical `varargs.h` cases are independent.
- This was a focused compiler repair, **not** a full compiler,
  optimization, KCC, or DAIMOS OS matrix sweep. The 269-source
  deferred disposition is unchanged.
