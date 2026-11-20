# P1 targeted libc/runtime probe (2026-11-20, v1)

Scope: three exact original C sources, PDP-6 only, KCC native noopt and
GCC native O0. No matrix activation, upstream edits, fake stubs, or broad
sweep. Reproduction uses `tools/probe-deferred-libc-v1.py` with each
source listed below and `--compiler all`. Logs are in the operational
`$TMPDIR/p10tk-p1-libc-targeted-20261120-v1` directory.

| Source | Initial KCC | GCC |
| --- | --- | --- |
| tests/semantic/upstream/extensions/20010518-2.c | run_fail | run_fail |
| tests/semantic/upstream/extensions/memcpy-bi.c | pass | pass |
| tests/todo/generic/920501-2.c | link_fail | run_fail |

The packed-structure test `20010518-2.c` returned nonzero from both
compilers. Its packed attribute, compound literals, and memcpy operations
need separate isolation; this is not evidence that memcpy itself failed.
The `memcpy-bi.c` source passes on both compilers.

The KCC `920501-2.c` link failure was precisely:

    dlink: undefined symbol: __kcc_umoddi3

The real installed implementation is already present in
`$PDP10_PREFIX/lib/kcc/kccrt-dimode-div.s`, which exports four DImode
quotient/remainder helpers. The semantic runner's KCC runtime ownership
map omitted these four symbols. The mapping now selects this one installed
member once, with no source implementation or ABI workaround.

A focused KCC PDP-6 noopt retest of `920501-2.c` after the mapping fix
**passes**. This is a verified runner integration fix, not a change to
KCC arithmetic code. GCC O0 still reports run_fail: its SIMH output
shows `Step expired` and `__test_exit=1`. It requires independent
arithmetic/step-budget investigation and is not declared passing.

The targeted results do not validate archive-linked DXR execution; the
semantic runner uses installed assembly fragments. The production archive
linker check remains separate. The original P1 historical evidence ledger
is deliberately unchanged.
