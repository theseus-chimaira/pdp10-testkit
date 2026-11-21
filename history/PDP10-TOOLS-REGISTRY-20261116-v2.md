# Independent PDP10-TOOLS registry dispatch (2026-11-16 v2)

**ACCEPTED: 9 independently reported tests PASS; one isolated source build.**

The previous `pdp10-tools` special registration owned one aggregate
`misc/tools/run.sh` invocation. Its output covered multiple utilities,
but the registry could record only one timeout and one status. Replaying
the aggregate for every utility would rebuild the entire independent
repository nine times and could not establish per-utility ownership.

## Architecture

`tools/run-misc-suites.py` now allocates a single private directory
under `$TMPDIR` and invokes `misc/tools/prepare-v2.sh` **once**.
Preparation refuses tracked changes to the selected independent Git
checkout, archives the exact `HEAD` revision, builds every tool and
test fixture in that private snapshot, prints the source SHA, and
installs only private symlinks to the built executables.

It then invokes `run_special("tools")`, which reads ordered, enabled
`tools` entries from `SPECIAL_TESTS.tsv`. Nine small case wrappers under
`misc/tools/cases/` use the same `PDP10_TOOLS_WORK`, without running
`make` or rebuilding test objects. Each has its own 120-second timeout,
PASS line, and error report. A failing case does not hide subsequent
case outcomes; the suite itself exits with failure if any case fails.
`TemporaryDirectory` removes the private build, including when a case
times out or preparation fails. `misc/tools/run.sh` remains a thin
compatibility entry to the same authoritative dispatcher, not a second
execution path.

| Registered test | Coverage |
| --- | --- |
| `pdp10-tools-dobj-v2` | DOBJ/DARC linker/object contract |
| `pdp10-tools-objdump-v2` | PDP-10 disassembly output |
| `pdp10-tools-p10fold-v2` | Exact folding, dlink plans and safety exclusions |
| `pdp10-tools-p10super-cfg-v2` | Conditional CFG equivalences |
| `pdp10-tools-p10super-rewrite-v2` | Rewrite, scheduling and unsafe-dependency rejection |
| `pdp10-tools-p10run-v2` | KA10 functional runner pipeline |
| `pdp10-tools-csix-v2` | C-SIX round trips and malformed input |
| `pdp10-tools-media-v2` | mkdt, mkstream, words2pt full output and input rejection |
| `pdp10-tools-install-v2` | Clean install/uninstall and stale-tool removal |

The inventory audit rejects a new `tools` entry that bypasses the
per-case owner directory, is not runnable as a shell case, or uses a
non-repository execution profile. This prevents an aggregate from
silently returning to the registry. One independent `verify` entry,
`test-pdp10-tools-registry-v2`, uses a synthetic source directory and
an injected case failure to confirm ordered per-case timeouts, that
later cases still run, accurate independent PASS/FAIL accounting, a
single shared preparation, suite failure propagation and private
directory cleanup on either case failure or preparation failure.

## Executed acceptance

From clean `pdp10-testkit`, using the unchanged independent
`pdp10-tools` source revision `fbef3d0334d91b6cda46895b66f75a67a2eb4bb8`:

```
./run-misc-tests.sh pdp10-tools
pdp10-tools independent source revision: fbef3d0334d91b6cda46895b66f75a67a2eb4bb8
pdp10-tools isolated build prepared
PASS pdp10-tools-dobj-v2
PASS pdp10-tools-objdump-v2
PASS pdp10-tools-p10fold-v2
PASS pdp10-tools-p10super-cfg-v2
PASS pdp10-tools-p10super-rewrite-v2
PASS pdp10-tools-p10run-v2
PASS pdp10-tools-csix-v2
PASS pdp10-tools-media-v2
PASS pdp10-tools-install-v2
suite tools: 9 executed, 9 passed, 0 failed
```

The original tool and test binaries were compiled exactly once during
the run. The independent repository's files and the project/compiler
checkouts were not modified. This is a source-backed test of the nine
listed tool workflows, **not** a claim of coverage for all 30 tools,
all PDP-10 machines, physical device paths or full compiler matrices.
