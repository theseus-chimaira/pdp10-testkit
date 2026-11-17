# GCC historical C integration: batch 02 of 50 (2026-11-17 v1)

## Scope and provenance

Exactly the next **50 unresolved historical GCC C sources**, in original
ledger order after batch 01, were read and classified individually.
They include five `gcc.c-torture/execute` sources, ten
`gcc.c-torture/compile` sources, and 35 `gcc.dg` sources. Original
SHA256 fingerprints are pinned to GCC revision
`b0f5374f6d4462bb8759160ece635e306d90998f`. The 23 inapplicable
snapshots from this batch were subsequently deleted; retained originals
remain unchanged in `refs/gcc-c-unmirrored-v1/`.
The deleted-source list and rejection rationales are recorded in
`docs/GCC-C-INAPPLICABLE-REMOVALS-20261117-v1.tsv`.

The full 50-row oracle, original `dg-options` and target restrictions,
PDP-10/KCC decisions, per-compiler eligibility, adapted file path,
source fingerprint, and lost compiler-option coverage are in
`docs/GCC-C-BATCH02-20261117-v1.tsv`. This is a source-level review:
**no GCC or KCC compilation, assembler, linker, guest, simulator, or test
runner has been executed**.

| Disposition | Files |
| --- | ---: |
| Adapted and registered with pending cells | 11 |
| Deferred for missing option, runtime, ABI or diagnostic fidelity | 16 |
| Original oracle inapplicable to PDP-10 or vacuous | 23 |
| **Total** | **50** |

Of the 11 registered sources, **8 are shared**, **2 are GCC-only**, and
**1 is KCC-only** under the current set of compiler profiles. Their
runtime/compile breakdown is 8/3. There are 40 new pending GCC PDP-6
optimization cells (`o0`, `o1`, `o2`, `os`) and 18 new pending KCC PDP-6
native/base cells. No other CPU, family, or compiler status is enabled.

## Eleven registered source oracles

| Original source | Mode | Compiler(s) | Preserved oracle |
| --- | --- | --- | --- |
| `execute/pdp10-dimode-div71-1.c` | Runtime | KCC | Four 71-bit signed/unsigned wide quotient and remainder expectations |
| `execute/pdp10-dimode-stack-negconst-1.c` | Runtime | Both | Negative 71-bit argument in fifth stack slot, sum and return |
| `execute/pdp10-int9-array-opt-1.c` | Runtime | GCC | Signed/unsigned exact 9-bit array truncation and indexing |
| `compile/pdp10-regrename-1.c` | Compile | Both | SIXBIT decoding, C register pressure and compile-only control flow |
| `gcc.dg/20000614-2.c` | Runtime | Both | Four nine-bit `char` union elements occupy one 36-bit integer; accumulated result zero |
| `gcc.dg/20000707-1.c` | Compile | GCC | GNU local label, label address and extern-inline lowering |
| `gcc.dg/20001101-1.c` | Runtime | Both | Floating-to-integer conversion, branch and final return 3 |
| `gcc.dg/20001108-1.c` | Runtime | Both | `noreturn` and double/long argument forwarding yield 26 |
| `gcc.dg/20010405-1.c` | Compile | Both | Inline double function and static local storage with old-style extern declaration |
| `gcc.dg/20010822-1.c` | Runtime | Both | Volatile struct field store through matching layout reads back 9 |
| `gcc.dg/20010912-1.c` | Runtime | Both | Pointer argument changes and nested return must yield 26 |

The first eight runtime cases are under
`tests/semantic/gcc-historical-b02-v1/`. The three compilation-only
cases are under `tests/codegen/gcc-historical-b02-v1/`. **A codegen row
with `main` is still compile-only**: there is no runtime exit assertion
for its original `dg-do compile` contract.

The original tests sometimes selected other CPUs and options. This batch
preserves meaningful C-level checks while **explicitly not claiming**
coverage of unimplemented modes such as x86 `-fpic`, SPARC `-mvis`, or
GCC `-fno-strength-reduce`. The individual TSV caveats record these
limitations. In particular, `20000614-2.c` gets a volatile-derived zero
source to prevent compile-time elimination of the original loop, while
preserving its union layout and zero-result check. The codegen-only
`pdp10-regrename-1.c` has external library declarations but does not
require linking. The `20001101-1.c` adaptation preserves the executed
branch only; it is **not** a SPARC register-clobber regression.

The 71-bit division case is **KCC-only for now** because the earlier
GCC-specific `-mlong-long-71bit` mode has no separate registered
compiler profile. Do not schedule it against an unchecked GCC mode.
KCC and GCC use the **normalized 71-value-bit** DImode model in two
36-bit words, not flat 72-bit integer arithmetic. The GCC-only exact
9-bit case uses a target `size(9)` attribute which KCC must not silently
ignore. GCC local-label syntax is also explicitly unsupported by KCC.

## Deferred source classes (16)

* Original compiler options or codegen path unavailable: `20000108-1.c`
  (`-O3` tied-register asm), `20000623-1.c` (`-fno-strict-aliasing`),
  `20000629-1.c` (`-g`), `20000904-1.c` (`-fpic`),
  `20001009-1.c` (`-fpic`), `20001117-1.c` (`-finstrument-functions`),
  `20001228-1.c` (`-ffast-math`), and `20010622-1.c` (`-Wall`).
* Diagnostic oracle not yet represented: `20000926-1.c` (required warning),
  `20001116-1.c` (specific empty-body warning), `20001201-1.c` (forbidden
  diagnostic), and `20011008-1.c` (required compile error). These must
  be checked by positive/negative warning/error policies, not admitted
  as ordinary successful compilation.
* Requires target-specific runtime, layout, or semantic analysis:
  `pdp10/kl10-static-pointer-init-1.c` (KL10-only),
  `20000906-1.c` (`__builtin_trap` in bounded-pointer checks),
  `20001023-1.c` (indeterminate local array values), and
  `20010202-1.c` (packed enum/char bitfields and nine-bit byte size).

The 23 other sources have no valid equivalent oracle on the current
PDP-10: IA-64 relocation or atomic conventions, x86 fixed registers and
assembly, SPARC IEEE bits and FSR instructions, Microsoft DLL imports,
Linux process/file descriptors, huge beyond-address-space objects, or
empty sources that prove nothing. No behavior was replaced with stubs.

Same-name paths in the existing testkit are **not** automatically
considered equivalent; several compile/semantic files with the same
basenames have entirely unrelated source bodies and assertions. Each
such collision was checked before assigning a new owner.

## Static reproducibility and next batch

`tools/inventory-gcc-unmirrored-v1.py` now verifies both batch files
against the original 679 hashes, the 11 adapted file hashes, compiler
eligibility and pending matrix profiles. The earlier 30 cross-compiler
KCC/GCC reviews and their matrix cells are unchanged. Explicit source
and matrix ledgers let us continue in original order without comparing
byte-identical files or confusing GCC-only constraints with C oracles.

After this batch **555 original sources remain unresolved**:
37 same-name candidates and 518 without reviewed source-level oracles.
The next 50-file selection must include KCC compatibility for each
candidate and preserve diagnostic assertions when present. No compiler,
assembler or emulator test has been run by this batch.
