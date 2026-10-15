# PDP-6 AAP timing coverage vs DAIMOS kernel — static matrix v1

Generated from `python3 tools/aap-kernel-coverage-v1.py`. The DAIMOS checkout had unrelated uncommitted edits; this audit does not modify DAIMOS.

**Interpretation:** source mnemonic occurrences in 74 assembly files only. Neither dynamic instruction counts nor timing weights nor coverage of C-generated instructions. An exact batch family label (or the explicit PUSHJ/POPJ call-depth mapping) is a conservative evidence indicator; different labels or earlier shell fixtures may cover the opcode without appearing as a match.

| Kernel mnemonic | Static occurrences | Exact or explicitly mapped AAP batch coverage |
|---|---:|---|
| `MOVE` | 3231 | yes |
| `JRST` | 2442 | no |
| `MOVEI` | 1146 | no |
| `PUSHJ` | 1062 | no |
| `MOVEM` | 699 | no |
| `JUMPE` | 604 | no |
| `PUSH` | 489 | yes |
| `POPJ` | 484 | no |
| `ADD` | 423 | yes |
| `JUMPN` | 409 | no |
| `LSH` | 408 | yes |
| `SETZ` | 347 | yes |
| `SUB` | 319 | yes |
| `ANDI` | 315 | yes |
| `POP` | 314 | yes |
| `ADDI` | 297 | no |
| `HRRZ` | 265 | yes |
| `HLRZ` | 223 | yes |
| `CAIE` | 197 | yes |
| `SETO` | 144 | yes |
| `CAME` | 142 | yes |
| `SKIPN` | 136 | no |
| `IOR` | 131 | yes |
| `CAML` | 129 | yes |
| `BLT` | 127 | yes |
| `CAIN` | 125 | yes |
| `CONO` | 121 | no |
| `SUBI` | 118 | yes |
| `TRNE` | 117 | no |
| `CAILE` | 115 | yes |
| `JUMPL` | 105 | no |
| `LDB` | 103 | yes |
| `CAMN` | 94 | yes |
| `TRNN` | 87 | no |
| `CAIL` | 68 | yes |
| `CAMLE` | 63 | yes |
| `CAIGE` | 62 | yes |
| `TLZ` | 58 | no |
| `AND` | 56 | yes |
| `AOS` | 55 | no |
| `AOJ` | 50 | no |
| `TLNE` | 50 | no |
| `CONI` | 49 | no |
| `SKIPE` | 48 | no |
| `TLO` | 48 | no |
| `IMULI` | 44 | yes |
| `HRL` | 40 | yes |
| `HRR` | 34 | yes |
| `IORI` | 29 | yes |
| `CAMGE` | 28 | no |
| `TLNN` | 27 | no |
| `MOVNI` | 25 | yes |
| `HRLZ` | 23 | yes |
| `HRRM` | 22 | no |
| `MOVSI` | 21 | yes |
| `DATAO` | 19 | no |
| `JUMPLE` | 18 | no |
| `IORM` | 17 | yes |
| `MOVN` | 16 | yes |
| `TDNE` | 16 | no |
| `DATAI` | 15 | no |
| `CAMG` | 15 | no |
| `ADDM` | 15 | yes |
| `CAIG` | 14 | yes |
| `JUMPGE` | 13 | no |
| `XOR` | 13 | yes |
| `ILDB` | 12 | yes |
| `SOJ` | 10 | no |
| `CONSO` | 10 | no |
| `HRLM` | 8 | no |
| `DPB` | 8 | yes |
| `SKIPGE` | 7 | no |
| `JUMPG` | 7 | no |
| `IDPB` | 6 | yes |
| `TRO` | 6 | no |
| `HRRZS` | 5 | no |
| `XCT` | 5 | no |
| `ANDM` | 5 | yes |
| `HLLZ` | 5 | yes |
| `CONSZ` | 4 | no |
| `SOS` | 4 | no |
| `XORI` | 4 | yes |
| `ANDCA` | 4 | no |
| `TDNN` | 4 | no |
| `BLKO` | 3 | no |
| `XORM` | 3 | yes |
| `TRZ` | 3 | no |
| `BLKI` | 2 | no |
| `SKIPG` | 2 | no |
| `DIV` | 2 | no |
| `AOBJN` | 1 | no |
| `IBP` | 1 | no |
| `ASH` | 1 | yes |
| `ANDCM` | 1 | no |
| `ROT` | 1 | no |
| `HLLM` | 1 | no |
| `SKIPL` | 1 | no |

## Unrepresented classes (conservative exact-label match)

| Class | Unmatched source occurrences | Highest contributors |
|---|---:|---|
| byte | 1 | ibp:1 |
| block | 0 | - |
| call-stack | 1546 | pushj:1062, popj:484 |
| doubleword | 2 | div:2 |
| halfword | 36 | hrrm:22, hrlm:8, hrrzs:5, hllm:1 |
| conditionals | 162 | aos:55, aoj:50, camge:28, camg:15, soj:10, sos:4 |
| logical-tests | 421 | trne:117, trnn:87, tlz:58, tlne:50, tlo:48, tlnn:27, tdne:16, tro:6, tdnn:4, andca:4, trz:3, andcm:1 |
| interrupts-io | 223 | cono:121, coni:49, datao:19, datai:15, conso:10, consz:4, blko:3, blki:2 |

## Interpretation and priority

1. Calls and returns (`PUSHJ` 1062, `POPJ` 484) have now gained 100 verified call-depth/return-value guest cases in batch100 v4. Additional stack boundaries, parameter passing and interrupt interactions remain untested.
2. Conditional compares (`CAI`/`CAM`) occur frequently. Batch100 v3 newly supplies ten variants each for ten predicate forms, but this is not a comprehensive boundary test of all combinations.
3. `BLT` now has 100 validated nonoverlapping 1–10-word transfer cases, including continuation milestones. LDB/DPB now have 100 byte-width/position cases; ILDB/IDPB now have 100 tested pre-increment pointer cases; IBP, word-crossing and I/O/interrupt paths (223 static references) require separate real-guest investigations.
4. Logical test/modify instructions (421 unmatched source occurrences) and memory destination forms warrant additional fixtures.
5. Static counts include all kernel assembly sources, not just whichever modules are linked into a specific boot image. They cannot establish runtime hotness. Compare against a specific linked image and measured opcode histogram before weighting optimization decisions.

## Acceptance criteria for broad coverage

- Guest result and control-flow validation for high-frequency kernel families across addressing modes and boundary values.
- Repeatable trace-on/off comparisons and deterministic completion; no reliance on timing assertions alone.
- Mark unmeasurable exceptions explicitly; do not claim full interrupt/I/O timing coverage.
- Match baseline/candidate execution, emulator revision and memory maps before comparing logical ticks.
