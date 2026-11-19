# P1 installed freestanding libc verification (2026-11-19, v1)

Targeted operational check only; no full compiler/CPU/optimization matrix.
No compiler, runtime or upstream source changed.

Installed KCC and GCC libp10c-v2.a archives have identical SHA256:

    ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41

Registered test installed-freestanding-archive-v1 was rerun:

    PASS installed-libp10c-kcc-v1 on pdp6
    PASS installed kcc archive extraction and PDP-6 libc ABI
    PASS installed-libp10c-gcc-v1 on pdp6
    PASS installed gcc archive extraction and PDP-6 libc ABI

The script checks installed KCC/GCC string.h, assembles callers into DOBJ,
links with production dlink and the installed DARC archive, checks the map
for four selectively extracted symbols (memcpy, strlen, strcmp, strstr),
and rejects unrelated extractions. Its PDP-6 execution verifies those same
calls using p10run with installed assembly sources. Importantly, this
runtime check is a **separate source link**, not execution of the
DARC-linked DXR image. The distinction must not be lost.

Reproduce:

    sh misc/compat/test-installed-freestanding-archive-v1.sh

## Remaining P1 work

1. The normal semantic runner selects installed freestanding assembly
   fragments by referenced symbol and passes them directly to p10run.
   Check that its symbol selection and transitive dependencies are
   complete; this is not the production archive-extraction path.
2. The archive intentionally does not provide hosted malloc, formatted
   I/O, alloca or the complete variadic hosted ABI. Do not confuse these
   prerequisites with freestanding string/memory support. See
   docs/PDP10-SPECIAL-DEFERRED-PREREQUISITES-20261118-v2.md and
   docs/PDP10-VARARGS-AND-GCC-ICE-20261118-v4.md.
3. Verify installed header selection, remaining ABI contracts, byte
   pointer corners and runtime helper ownership before the large sweep.
4. BLT cutoff, qsort, string optimizations and memory/step-count
   benchmarks remain separate measured work, not evidence that archive
   correctness is missing.

No full semantic-oracle closure or broad sweep PASS is claimed.
