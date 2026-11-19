# PDP10 P1 semantic source resolution: live v6

Date: 2026-11-19. Immutable imported-source and historical baseline
manifests remain unchanged. This version advances the source-specific
P1 *test-construction* state after completion of Batch 2; it does not
reclassify original compiler failures as passing tests.

## State and ownership

| Scope | Count |
| --- | ---: |
| Historical upstream source identities | 67 |
| Covered source intents | **28** |
| Partially covered intents | **6** |
| Blocked intents | **33** |
| **Actionable P1 source obligations** | **39** |
| Frozen initial actionable batches | 59, grouped 10+10+10+10+10+9 |
| Finished batches | Batch 1: **10/10**, Batch 2: **10/10** |

Exactly eight of the 67 source identities were covered before the
original frozen 59-task batch plan. Exactly twenty assigned sources
have now completed construction, leaving 39 in the fixed remaining
batches. The historical `activation=deferred` of all 67 original
sources remains a provenance distinction, not the current P1 status.

The current status is pinned in
`PDP10-P1-SEMANTIC-RESOLUTION-20261119-v6.tsv` with one row per
original source. The matching batch assignment and live states are in
`PDP10-P1-SOURCE-BATCHES-20261119-v5.tsv`. Registered auditors verify
every original SHA256, existing independent companion observations,
all 30 new Batch 2 observations, active normal matrix registrations
and the special original-source instrumentation option requirements.

## Five final Batch 2 dispositions

- **`nestfunc-3.c`: covered.** Independently calculated, bounded GNU
  nested-closure callback/captured-sum oracle (8 invocations, sum 105)
  avoids the original signed-long overflow. The source is a genuine
  GCC regression: O1 PASS, O0 abort at the sum assertion and O2/Os
  wall timeouts. No simulator timeout is reported as a compiler abort.
- **`20010122-1.c`: covered.** Real depth-0/depth-1 GNU return-address
  builtin, `noinline`, `alloca` and both returned/side-effect address
  groups. Four GCC profiles fail the first nonvacuous address equality;
  the original undefined return of a local pointer is not copied.
- **`bf-sign-2.c`: covered.** Standard 36-bit-int bitfield promotion
  (six prior KCC/GCC PASS) plus GNU 3/35-bit unsigned-long-long fields
  (four GCC PASS), including max field values. Unsupported KCC GNU
  extension is not claimed to pass.
- **`eeprof-1.c`: covered.** Original source executed unchanged at all
  four GCC optimization modes with genuine `-finstrument-functions`
  and its intended `-D__pdp10__` short-symbol aliases. Original
  instrumented entry/exit assertions PASS. This option-sensitive source
  uses a registered special verifier rather than an unconfigured
  ordinary semantic matrix cell.
- **`991228-1.c`: covered.** Native non-IEEE DEC D-format double sign
  and continuation bits, GNU designated union initializer, and an
  unguarded original signbit function. The original function form
  still triggers a true GCC O0 compiler ICE; KCC optimized also fails
  native double continuation sign. These remain explicit compiler
  follow-ups, NOT incomplete P1 test construction.

Full evidence: `docs/PDP10-P1-BATCH2-FINAL-20261119-v1.md` and
`docs/PDP10-P1-BATCH2-FINAL-RESULTS-20261119-v1.tsv`, with archived
original compiler, linker and guest logs under `refs/`.

## Next priorities

P1 now continues with **Batch 3**, consisting of five target-width
adaptation sources and five partially covered historical sources.
Only source-specific independent oracles can close a P1 obligation.
The original 59 work assignments do not shrink or reorder.

All compiler ICEs, incorrect code generation, native runtime helper
linkage and linker relocation failures stay visible for the later
**P2** compiler/toolchain repair phase. AAP architecture correctness
and expansion remain **P3**. These later repair dependencies do not
retroactively reopen completed P1 test-construction work.
