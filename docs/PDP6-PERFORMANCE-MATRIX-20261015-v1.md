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
