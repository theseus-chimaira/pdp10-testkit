# P1 original floating sprintf oracle: 930513-1.c (v1)

Date: 2026-11-20. This is a bounded original-source integration, **not**
the deferred compiler/CPU/optimization sweep.

The unchanged original `tests/todo/generic/930513-1.c` invokes `sprintf`
through an explicitly typed function pointer, passes a floating argument
`5.0` with format `%.0f`, and asserts `buf[0] == '5'` and `buf[1] == 0`.
It checks actual output bytes; it is not a vacuous formatting test.
Its SHA256 is
`0007986905cfa0ddbc7face84420a15d201b746a87e7a32440e5a4d3e442ba44`.

The installed GCC target `stdio.h` and real buffered sprintf formatter
remove the historical target-header compilation blocker. Three
previously inactive GCC optimization cells were enabled without changing
the original source. Six focused actual PDP-6 compiler/emulator runs PASS:

| Compiler | Profiles | Result |
| --- | --- | --- |
| KCC | noopt, opt | 2/2 PASS |
| GCC | O0, O1, O2, Os | 4/4 PASS |

Every `p10run` report records `rc=0`, `result=PASS`, HALT, and
`__test_exit=0`. Its corresponding linker map resolves the real
`sprintf`, `f`, `abort` and `exit` symbols. All 12 report/map files
are SHA256-pinned by the manifest and immutable archive:

- `docs/PDP10-P1-930513-ORIGINAL-EVIDENCE-20261120-v1.tsv`
- `refs/p10tk-p1-930513-original-20261120-v1.tar.gz`

The registered `p1-930513-original-v1` verification test checks original
assertions, source identity, normal matrix registration, previous v14
blocked status, all six exact profiles, real guest completion, link maps
and archive members. Nine negative controls reject corrupted or missing
source, profile, status, report and registration evidence.

The immutable P1 resolution v14 (43 covered, 24 blocked) is superseded
for current decisions by v15 (44 covered, 23 blocked). The fixed
59-source batch assignment remains unchanged; Batch 5 is now 2/10
covered. This closes test construction for the checked PDP-6 intent,
**not** all floating-point behavior or all target CPUs. KA10/KI10/KS10
remain pending. The full sweep remains deferred.
