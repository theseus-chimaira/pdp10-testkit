# Optional PDP-6 performance measurements (2026-10-15 v1)

The registered `utf9-pdp6-runtime-v1` test verifies execution correctness
under KCC and GCC before collecting performance measurements. Enable
opcode profiling with:

```sh
PDP10_PREFIX="$HOME/cross" P10_UTF9_PROFILE=1 \
P10_UTF9_PROFILE_DIR="$HOME/tmp/utf9-profile-results-v1" \
  sh misc/compat/test-utf9-pdp6-runtime-v1.sh
```

This requires the installed `p10run --opcode-profile` and PDP-6 SIMH with
`CPU OPCOUNT[0-511]`. Four JSON profiles are written, one for each compiler
and UTF-9 runtime test. Each contains all 512 opcode dispatch counts,
the exact dispatch total, and optional weighted cost fields.

The default performance metric is **dispatched instructions**, a useful
optimization proxy but not a measurement of elapsed execution time. For
an independently sourced opcode cost table, supply
`P10_PDP6_COST_WEIGHTS=/path/to/weights.tsv`. The TSV fields are
`opcode_octal` and `cost_units`; unlisted executed opcodes remain unweighted.
No unverifiable default PDP-6 timing constants are supplied.

To compare versions, save a baseline profile from a passing run and run:

```sh
python3 tools/compare-pdp6-profiles-v1.py baseline.json candidate.json \
  --max-regression-pct 1
```

This exits unsuccessfully if dispatch count grows by more than 1%.
`--metric weighted` is allowed only when both profiles use the same
complete weight table. Thus partial costs cannot be mistaken for full
runtime or silently compared against different machine models.

Simulator dispatch counts include CRT and test harness instructions,
not only the codec. Compare identical workloads and simulator builds.

## General semantic matrix

Set `P10_SWEEP_PROFILE=1` when running `run-tests.sh` to profile **all
successfully executed PDP-6 semantic cells**, not just the UTF-9 special
test. The runner passes `--opcode-profile` to `p10run`, validates the
complete 512-counter histogram, and saves `opcode-profile-v1.json` within
the cell's `run` directory. If a successful execution lacks a readable
histogram, the cell is reported as `setup_fail` rather than as a valid
performance result. Non-PDP-6 machines retain their normal behavior.

Example using a new output directory (the restart runner skips already
passing cells in an existing directory):

```sh
P10_SWEEP_PROFILE=1 ./run-tests.sh --compiler gcc --family base \
  --cpu pdp6 --opt noopt --kind semantic \
  --out-dir workdir/pdp6-profile-v1
```

Use `P10_PDP6_COST_WEIGHTS` to supply a separately validated optional
opcode-cost table. Correctness is always established before profiling.
Profile regression comparisons require identical test inputs, compiler
settings and simulator configuration. The numerical dispatch count alone
does not establish PDP-6 wall-clock performance.

Validation: the real general-matrix `gcc-base-noopt` / PDP-6 cell for
`tests/semantic/regression/int_ops_more.c` passed with profiling enabled
and produced a complete JSON profile containing 4,090,986 dispatched
instructions. A compile-only semantic cell remains compile-only and
does not generate a spurious execution profile.
