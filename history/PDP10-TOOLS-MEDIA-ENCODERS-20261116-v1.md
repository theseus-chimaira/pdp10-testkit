# Independent PDP10-TOOLS media-encoder regressions (2026-11-16 v1)

Status: **PASS** on the source-built `pdp10-tools` revision
`fbef3d0334d9` (the exact commit was reported by the isolated runner).

The independent checkout still contains 30 separately compiled host
utilities. `misc/tools/run.sh` continues to archive its exact clean
Git revision into `$TMPDIR`, build in isolation, and run the existing
object, linker, fold, superoptimizer, KA10 runner, CSIX, and install
checks. Three previously uncovered media encoders now have independent
output oracles in `misc/tools/media-encoders-test-v1.py`:

| Tool | Positive contract | Rejected inputs |
| --- | --- | --- |
| `mkdt` | Two 18-bit little-endian halves per 36-bit word, exact 128-word padding to 1,024 bytes, including an all-ones word | Greater-than-36-bit octal word, unsupported media type |
| `mkstream` | DAIMON magic, `image_words,,entry_offset` header, four-position sparse deposit map, later deposit overwrites an address | Deposit outside the init range, malformed octal, zero image size |
| `words2pt` | Exactly five MSB-first bytes per 36-bit word, first byte restricted to four value bits, accepts comments without altering output | Greater-than-36-bit word, non-octal digit, unsupported type |

The tests compare full output bytes/text against independently
constructed constants and enforce nonzero exit status on invalid
inputs. They run using the actual programs from the same isolated
build as the other `pdp10-tools` checks. No emulated media-device
interaction or successful PDP-6 physical bootstrap is inferred from
these format checks.

Acceptance:

```
mkdt: PASS (128-word padding, 18-bit halves, bad input)
mkstream: PASS (DAIMON stream, sparse deposits, invalid input)
words2pt: PASS (five-byte 36-bit encoding, bad input)
pdp10-tools media encoders: PASS
install stale-tool cleanup contract: PASS
pdp10-tools generic regressions: PASS
suite tools: 1 executed, 1 passed, 0 failed
```

The specialized tools suite intentionally retains one authoritative
aggregate entry in `SPECIAL_TESTS.tsv`: splitting it into independent
entries would require one shared, verified source-build setup so tests
do not repeatedly rebuild or silently mix revisions. That registry
work remains open. No changes were required in `pdp10-tools`, the
DAIMOS kernel, KCC, or DAS.
