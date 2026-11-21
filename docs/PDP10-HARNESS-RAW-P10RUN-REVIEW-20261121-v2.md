# Raw p10run caller source review (v2)

Date: 2026-11-21. Scope: harness entry-point policy and source audit.
Compiler fixes and the full compiler matrix are explicitly deferred.

## Reviewed source inventory

`docs/RAW-P10RUN-CALLERS-20261121-v2.tsv` enumerates all 69 lexical
candidates and pins the SHA256 of every script. Each of the 60
registered dispatcher-only scripts was inspected for KCC and/or GCC
compiler references, including the installed freestanding archive
probe and the mixed KCC/GCC ABI checks. Classification is based on
compiler references in the source, not on the script filename.

| Classification | Count | Supported execution entry point |
| --- | ---: | --- |
| KCC-only guest | 23 | `./run-misc-tests.sh run-id <registered-id>` |
| GCC-only guest | 8 | `./run-misc-tests.sh run-id <registered-id>` |
| Mixed KCC/GCC guest | 29 | `./run-misc-tests.sh run-id <registered-id>` |
| Explicitly isolated registered guest | 5 | Registered dispatcher; previously tested direct modes |
| Historical superseded scripts | 3 | Not active; do not use as the supported entry point |
| Runner environment helper | 1 | Not an executable guest test |

The 60 dispatcher-only scripts intentionally do not acquire an
independent raw execution guarantee. The existing registered dispatcher
selects compiler-owned freestanding libc for each guest group, and
requires KCC and GCC installed archive hashes to match for mixed
scripts. Raw execution could instead select an OS-owned `lib/libc.a`
and would bypass that gate. Making a second implicit library policy in
all 60 scripts is unnecessary for the pre-sweep goal and would increase
RAM/disk/process overhead. Standalone isolation remains warranted only
for the five scripts already explicitly supporting raw execution.

`tools/audit-raw-p10run-v2.py` checks ledger ownership, exact script
SHA256, explicit compiler-evidence classification and new/stale
callers. A changed script fails closed until reviewed and re-pinned.
This is a source-level review, not a dynamic test of all 60 scripts.

## Tests

- GCC-only: `./run-misc-tests.sh run-id gcc-9bit-data-section-v1`:
  PASS, O0/O1/O2/Os on PDP-6.
- KCC-only: `./run-misc-tests.sh run-id kcc-dimode-storage-v1`:
  PASS, two semantic cases in optimized/unoptimized PDP-6 modes.
- Mixed: `./run-misc-tests.sh run-id freestanding-search-v1`:
  PASS, KCC optimized/unoptimized and GCC O0/O1/O2/Os on PDP-6.
- `tools/audit-raw-p10run-v2.py`: PASS, 69/69 classified.
- `tools/audit-script-ownership-v6.py`: PASS, 593 scripts owned.
- `tools/audit-test-inventory-v2.py`: PASS, 413 special tests.
- Four negative controls: wrong SHA256, wrong compiler evidence,
  duplicate ledger row and missing ledger row all rejected.
- Python syntax checks: PASS.

## Outstanding

The 60 registered scripts have not all been executed in this change.
The remaining pre-sweep gate is interruption/restart and checkpoint
recovery acceptance; the 123,576-cell full matrix is not started.
Any future need for direct execution of a dispatcher-only script
requires a separate, versioned isolation change and native regression.
