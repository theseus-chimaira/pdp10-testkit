# Packed by-value argument-copy timeout repair v23

Date: 2026-11-24

## Existing timeout cluster

The old comprehensive source
`tests/semantic/kcc-ported/gnu-packed-byvalue.c` had 27 GCC
`timeout` checkpoints and 17 `run_fail` checkpoints. O1/O2/Os
frequently entered a long LDB/DPB/IBP loop when copying a packed
argument to an outgoing call slot. Its source covers 3, 6, 11,
and 20-byte records, including return-by-value and by-value calls.

## Reduced evidence and backend repair

Removing all but the three-byte struct, maker and sum function
preserved the timeout. For the second packed copy in `main`, GCC's
earliest dumped RTL placed `count = count - 1` in the copy preheader
while leaving `if (count != 0) goto copy_loop` as the loop tail.
The count never changed inside the loop. This is a real emitted
control-flow bug, not a slow simulator or an invalid test limit.

The GCC backend now generates one `decrement_and_branch_until_zero`
parallel RTL instruction. The PDP-10 machine description lowers
this directly to `SOJN`, keeping the decrement bound to the branch
and avoiding separate motion through argument-libcall sequencing.
It also saves a machine word compared with separate SUBI/JUMPN.

The rebuilt installed GCC completed the full 44-cell original
source matrix in isolated
`workdir/pdp10-packed-timeouts-v23-isolated`:

| Result | Before | After |
| --- | ---: | ---: |
| pass | 0 | 0 |
| run_fail | 17 | 44 |
| timeout | 27 | 0 |

**All 27 historical timeouts are resolved**, but the underlying
packed by-value field-value assertions still fail. These runtime
failures are explicitly open and must not be described as PASS.

## Permanent regression

The C89 source
`tests/semantic/regression/pdp10-packed-argument-copy-loop-v23.c`
is registered in `COMPILER_MATRIX.tsv`. It tests termination of
packed argument copies for 3, 6, 11, and 20-byte by-value calls.
Its callees deliberately do not inspect the argument fields, to
isolate the loop-counting repair from the separately failing
packed-argument ABI semantics. The official runner passed **36/36
GCC profile cells** in the isolated v23 checkpoint directory.
Staged PDP-6, KI10 and KS10 runs also passed at O0 and O2;
the O2 assembly contains eight directly count-bound SOJN loops.

Five earlier v19-v22 test sources were rerun from scratch against the
installed v23 compiler in an independent checkpoint directory:
**284/284 GCC/KCC PASS**, strict exit policy, no skipped old PASS
statuses. This covers the earlier wide-int, nested-function and
byte-pointer repairs without relabeling the packed ABI failures.

## Remaining timeout picture

Before v23 the original sweep snapshot had 49 timeout cells left
unrepaired: 27 in this GCC source and 22 in two optimized KCC
tests (`20020402-3.c` and `20001203-2.c`). The v23 GCC repair
reduces that historical timeout remainder to **22 KCC cells**.
Other full-sweep failures are not changed by this accounting.
