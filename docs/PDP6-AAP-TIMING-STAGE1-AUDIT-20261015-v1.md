# PDP-6 AAP timing calibration: Stage 1 source audit (2026-10-15)

**Status: blocker identified; timing units and instruction boundaries not
yet established.** Do not infer microseconds or create opcode costs from
the current C emulator's pulse queue.

## Verified implementation observations

1. `emu/emu.c`, `simthread`, loops over `Task`s and invokes a task when
   its incremented counter equals `freq`. This is an unpaced host loop,
   not by itself a calibrated real-time clock. The APR task is registered
   with `freq=1` in `emu/apr.c`, `makeapr`.
2. `emu/apr.c`, `pulse`, inserts pulses in a relative-delay sorted queue
   (`TPulse.t`). During insertion, later queued delays are adjusted and
   the new pulse's delay is reduced by the preceding delays.
3. `emu/apr.c`, `stepone`, removes the head pulse and executes its callback,
   then executes zero-delay pulses. It does **not** currently advance any
   simulation clock by the head pulse's nonzero `t`, nor does the observed
   code decrement `t` as task iterations pass. Thus a callback timestamp
   based on APR task ticks would be misleading; the queue's intended time
   semantics need source-level reconciliation and executable validation.
4. `emu/apr.c`, `aprcycle`, calls `stepone`, updates I/O and memory buses,
   and schedules memory acknowledgement pulses with `200`-unit delays.
   The comments explicitly say these are TODO delays, chosen to preserve
   `MC STOP` ordering rather than independently validated hardware timings.
5. `emu/mem.c` models memory-control handshake steps synchronized with
   the APR pulse progression. The source notes uncertainty about the
   old executing-thread assumption after removal of pthreads.
6. `README.md` describes the pulse implementation as a transcription of
   PDP-6 maintenance schematics, but explicitly says timing is not yet
   completely accurate.

## Consequences and required next experiments

- Confirm whether `TPulse.t` represents intended physical time, sequence
  ordering alone, or an incomplete historical scheduler implementation.
- Establish the original delay unit against F-67 maintenance manual timing
  charts, without assuming every numeric delay is in nanoseconds.
- Build a testkit unit/integration experiment that schedules distinct
  delayed pulses and checks actual callback ordering and time progression.
- If the queue lacks time progression, fix the scheduler at its source
  rather than compensating for it in the benchmark or inventing constants.
- Identify fetch-start, completion, XCT, interrupt and abort events before
  attributing pulses to an instruction. No opcode timing measurements are
  considered accepted until this boundary work passes tests.
- Preserve the existing SIMH opcode histogram and exact dispatch comparison
  as the production performance proxy during this research.

No production emulator changes were made during this audit. Keep further
experiments and their tests in `pdp10-testkit`; only update finished
production documentation in `pdp10-doc` after calibration is validated.
