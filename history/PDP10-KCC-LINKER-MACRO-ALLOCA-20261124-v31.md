# KCC macro-rescan and alloca linker repairs (2026-11-24 v30/v31)

## Scope and original failure ownership

The v29 source-pinned linker census contained 34 KCC failed cells:
22 unresolved `alloca` (original `tests/todo/generic/20020314-1.c`),
four macro-rescan `c` (original
`tests/semantic/gcc-historical-b09-v1/macro3.c`), four
`undefined_reference` (unused static-inline original 20011115-1.c),
and four bare-machine `puts` (original macro1.c). The GCC `puts`
cases are outside this compiler repair.

## Compiler repairs

KCC v30 changes `ccpp.c` so a *function-like* macro invocation that
consumes parentheses or arguments beyond an inner replacement-list
boundary shortens that exhausted replacement's hideset. The enclosing
macro protections stay active. This makes `c(c)(c)` expand to `d`
instead of the undefined call `c(2)`. The unchanged upstream macro6.c
now also expands like the host compiler. A rejected earlier change
applied the rule to object-like macros too, breaking original strp1.c.
The final function-like-only rule preserves the strp1.c expected
string `"1+h(2)"`; original macro3.c, macro6.c and the independent
`kcc-macro-boundary-rescan-v30.c` regression pass 30/30 KCC cells
across all four CPUs and both optimization modes, with no old-green
checkpoints and strict exit policy.

KCC v31 adds real direct-call builtin support for undeclared `alloca`
and `__builtin_alloca`, retaining explicitly user-defined functions.
Parsing marks the containing function as using its existing VLA frame,
reserving AC14 as a fixed anchor. Code generation rounds 9-bit C byte
counts up to 36-bit words, returns the native 9-bit byte pointer, and
advances the caller's SP without a fake callee or runtime dependency.
Normal function-return teardown restores SP from the fixed VLA frame.
`ccout.c` no longer emits a spurious `.extern alloca` for this builtin.

The unchanged original `20020314-1.c` passes all 22 KCC cells with
strict acceptance, previously 22/22 link_fail. The new independent
`kcc-alloca-stack-lifetime-v31.c` tests writable 9-bit arrays, several
successive allocations, native integer alignment/readback, nested calls
and 32 repeated frame allocations, 22/22 strict PASS. The two unchanged
VLA regression sources `base_vla.c` and `kcc_modern_vla_scope.c` pass
44/44 with the old KCC and 44/44 with the new staged KCC. The full
seven-source KCC acceptance set passes 118/118 strict, with `-j4`
and zero old-green skips, both staged and independently reexecuted
after installation in `$HOME/cross/bin/kcc`.

The installed compiler SHA256 is:

`fdc96ab684e5575f8759fb4042354230d15388189f41c2edaed799b8136e4d29`

The previous KCC was backed up to
`$TMPDIR/pdp10-kcc-linker-v31/kcc-before-v31` and the compiler-owned
`libp10c-v2.a` remained SHA256
`ac09b8a362e4ea3ca8a7e69a2ca5a98af5a76cc85a7db909b6b3a134afb7ee41`.

Local independent result files:

* `workdir/kcc-macro-regress-final-v30/summary.txt` (30 PASS, staged)
* `workdir/kcc-alloca-original-stage-v31b/summary.txt` (22 PASS, staged)
* `workdir/kcc-alloca-strong-stage-v31/summary.txt` (22 PASS, staged)
* `workdir/kcc-vla-baseline-v31/summary.txt` (44 PASS, old compiler)
* `workdir/kcc-vla-stage-v31/summary.txt` (44 PASS, new compiler)
* `workdir/kcc-linker-accept-final-v31/summary.txt` (118 PASS, staged)
* `workdir/kcc-linker-installed-accept-v31/summary.txt` (118 PASS, installed)
* `workdir/kcc-known-link-installed-v31/summary.txt` (34 original cells)

Reproduction with the installed compiler:

```sh
export TMPDIR=${TMPDIR:-$HOME/tmp}
export PDP10_PREFIX=${PDP10_PREFIX:-$HOME/cross}
python3 tools/run-tests.py --compiler kcc --exit-policy strict -j4 \
    --source-file manifests/PDP10-KCC-LINKER-ACCEPTANCE-SOURCES-20261124-v31.txt \
    --out-dir workdir/kcc-linker-installed-accept-v31
```

The seven-source acceptance manifest SHA256 is
`0f083d5016f9adec6365bae897d4f324f862337f634f054f6cabb9d51c864716`.
The matching 34-KCC-cell original failure manifest is
`manifests/PDP10-KCC-V29-LINK-FAIL-CELLS-20261124-v31.tsv`, SHA256
`b65c816a72aa415858fc3ca422ee3c3fdf79cc4168c76694688d3a6010f1e45d`.
It is an exact unchanged extraction of the KCC rows from the 50-cell
v29 manifest; both successful and still failing cells were freshly
reexecuted after installing the corrected compiler.

## Remaining work, not falsely classified as PASS

The full historical KCC linker subset has 34 cells: 26 are repaired
and eight remain real linker errors: four `undefined_reference` caused
by KCC eagerly emitting an unreachable, unused static-inline body,
and four `puts` demanding a genuine console provider rather than the
bare-metal freestanding runtime. The KCC static-inline defect requires
reachability-aware function emission; simply folding `foo == foo`
is insufficient and leaving an actual unresolved relocation in the
assembler is not a DLINK bug. Both remain open.

An additional GCC-only observation arose from the new KCC macro
regression source: the installed GCC passes 11/44 native profiles
but at optimization O1/O2/Os returns 7 from the string-literal
comparison in 33/44 cells. This is a *separate* optimized-GCC
code-generation failure to be diagnosed in its own task; the regression
oracle has not been weakened or disabled to disguise it.

No full compiler or kernel sweep is claimed.
