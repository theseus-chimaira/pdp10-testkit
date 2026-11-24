# KCC v32: reachability-correct static-inline emission

Date: 2026-11-24. Scope: Unix-hosted KCC cross compiler and its original
PDP-6/KA10/KI10/KS10 guest tests. The native DAIMOS KGEN file-service
integration is not changed by this host-only compiler repair.

## Original failure and verified root causes

Original upstream fixture:
`tests/semantic/gcc-historical-b01-v1/20011115-1.c`.
The original v29 linker census found four KCC `link_fail` cells. It
defines `static inline foo()` with a reference to the intentionally
undefined external `undefined_reference`, and `static inline bar()`
whose `if (foo == foo)` must always return true before `foo()`.

KCC previously compared the identical function designator addresses
at runtime instead of folding their guaranteed equality. In `-n`,
it additionally emitted code after the now-unconditional return.
More fundamentally, KCC generated each static-inline body at parse
time regardless of whether any emitted instruction could reach it.
Even after the branch was folded, `foo` itself remained in the
assembler and forced the external reference. Parser `Srefs` was not a
reliable code-emission oracle: it includes references appearing only
inside discarded functions or branches.

## KCC implementation

`ccstmt.c` folds equality/inequality of two designators of the *same*
function symbol to the correct constant result, even with `-n`.
The fold happens after binary type/flag validation, not before it.
An early attempted parser change replaced a binary node too soon and
crashed KCC when later validation inspected its now-missing children.
That attempt was rejected and corrected before acceptance.

`ccgen1.c` handles constant conditions independently of the optimizer
switch and stops emitting an unreachable statement suffix after a
guaranteed return, goto, break or continue. It preserves the suffix
when it contains any labels, and recognizes a constant if-condition
as terminating only when the selected branch itself terminates. The
new `kcc-inline-branch-labels-v32.c` regression checks jumps into a
later label and into an otherwise unselected else branch.

For `HOST_UNIX`, `ccgen.c` now captures the actual generated assembler
for each internal-linkage `static inline` definition into a temporary
file instead of immediately writing it into the module. It retains
only one small record per candidate function and one record per
distinct emitted symbol dependency; it does not retain parse trees or
full function bodies in compiler RAM. `ccout.c` records symbol uses
as they are really written to assembler operands. Ordinary functions
and data are reachability roots; a buffered inline definition's own
references are only activated when that inline definition is reached.

At module end (`cc.c`), a monotone closure over these reference edges
selects reachable deferred function bodies. The compiler replays those
bodies in source order from the file and emits extern declarations
only for symbols that appear in live assembly or its selected inline
definitions. Recursive call graphs are handled without recursion in
the closure algorithm. Section-state saving/restoration ensures that
interleaved code, literals and data retain valid assembler segments.
An unreachable inline body cannot contribute a bogus external symbol.
No missing symbol is silenced if an emitted live body needs it.

This implementation is explicitly limited to the hosted Unix emitter:
native DAIMOS KGEN cannot assume Unix `tmpfile()` exists. Extending
the same on-disk buffering protocol to native KGEN needs a verified
native file-service interface. The native output path remains at its
previous emission behavior, not a falsely claimed repaired state.

## Tests and observed exclusions

The historical `20011115-1.c` now passes all four of its formerly
failing KCC cells in both optimized and `-n` profiles, and emits no
`undefined_reference` relocation. The new
`kcc-static-inline-reachability-v32.c` passes 22/22 KCC profiles:
reachable transitive inline calls, function-pointer initializer,
mutual recursion, preservation of a real external `abort` dependency
and absence of the intentionally missing symbol in unreachable code.
The independent branch/label source passes another 22/22.

The first broad historical neighbor selection contained 238 cells.
It produced 214 PASS, 22 `compile_fail` and two `policy_fail`:
all 24 non-PASS results were confirmed against the unchanged installed
v31 compiler and were not caused by this patch. In particular:

* `tests/codegen/upstream-gcc/compile/20001205-1.c` uses GNU extended
  assembler constraints, which KCC v31 and v32 both reject at parse
  time (22 cells). It remains registered and unchanged but is not a
  valid strict acceptance test for the separate inline repair.
* `tests/codegen/kcc-ported/gnu-function-attributes.c` required the
  incorrect public label `helper:` for a `static inline` internal
  function. Its real assembler symbol is `$helper:`. The exact regex
  was corrected to require `$helper:` instead; the original fixture
  passes 2/2 cells with old v31 **and** new v32. The warning-count
  assertions were not weakened or changed.

The source-pinned strict 14-source acceptance
`manifests/PDP10-KCC-STATIC-INLINE-ACCEPTANCE-SOURCES-20261124-v32.txt`
passed 216/216 new v32 staged cells, `-j4`, with zero reused green
results. The separate 22/22 branch/label test subsequently extended
this to 238 distinct tested cells. The manifest includes both new
regressions; the installed-compiler rerun passed all 238 cells with strict policy, -j4 and zero reused checkpoints.

The same exact 34 original KCC link-failing cells from the v31 manifest
were independently rerun on both the v32 staged and installed compilers: **30 PASS,
four link_fail**. The only remaining four failures come from the
original `macro1.c` source's dependency on a real hosted `puts`
console. Those are not compiler bugs and no dummy output routine was
introduced in the bare-metal compiler library.

## Reproduction

From `pdp10-testkit`, with the installed KCC:

```sh
export TMPDIR=${TMPDIR:-$HOME/tmp}
export PDP10_PREFIX=${PDP10_PREFIX:-$HOME/cross}
python3 tools/run-tests.py --compiler kcc --exit-policy strict -j4 \
    --source-file manifests/PDP10-KCC-STATIC-INLINE-ACCEPTANCE-SOURCES-20261124-v32.txt \
    --out-dir workdir/kcc-static-inline-suite-installed-v32

python3 tools/run-tests.py --exit-policy ice-only -j4 \
    --cell-file manifests/PDP10-KCC-V29-LINK-FAIL-CELLS-20261124-v31.tsv \
    --out-dir workdir/kcc-known-link-installed-v32
```

The second run's `ice-only` policy retains all four actual `link_fail`
statuses; it does not mean they are PASS. No full compiler sweep or
native DAIMOS KGEN acceptance is claimed by these focused results.
