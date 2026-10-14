# Compatibility matrix audit (2026-10-14)

Static audit of the 38 ordered `group=compat` scripts in `COMPILER_MATRIX.tsv`.
No script has yet been converted to a compiler/CPU/optimization matrix cell.
`K` = KCC, `G` = GCC; `mixed` means separately compiled caller/callee
objects. `shape` checks specific generated instructions rather than program
semantics. For CPU portability, `candidate` means **test first**, not proven.
Most GCC cases use `-O1`; most KCC cases use `-x=base`. `KS` is KS10 and
`P6` is PDP-6. These are *current* settings, not proposed limitations.

## Batch 1 (10 scripts)

| Script (`test-*.sh`) | Current coverage | Recommendation |
| --- | --- | --- |
| aggregate-return-abi | K/G, base, G O1, shape | Separate ABI layout invariant from optimizer-sensitive assembly; CPU/optimization candidates |
| extended-aggregate-abi | K/G, base, G O1, shape | Same; preserve register/stack ABI invariants |
| gcc-callee-save-pushpop | G, P6/KA10, O1 vs Os, shape + execute | Paired optimization comparison, not independent O0/O2 cells; retain P6/KA10 baseline |
| gcc-cross-word-bitfield | G, KS, O0/O1, execute | Genuine per-CPU/optimization semantic cells; extend supported combinations |
| gcc-dimode-divmod | G, KS, O2, 71-bit, execute | Per-CPU/optimization cells if helper runtime supports CPU |
| gcc-scalar-move-order | G, O2/Os, shape | Restrict to relevant optimization modes; avoid assuming identical assembly at O0/O1 |
| int71-header | K/G, base, G O1, compile | Compiler language/ABI compile matrix candidate; verify required 71-bit modes |
| kcc-gcc-aggregate-stack | K/G mixed, KS, G O1, execute | Mixed caller/callee direction x CPU x compiler optimization |
| kcc-gcc-cross-word-bitfield | K/G mixed, KS, G O1, execute | Mixed-direction ABI cells across supported CPUs/optimizations |
| kcc-gcc-direct-abi | K/G mixed, KS, G O1, 71-bit, execute | Mixed ABI matrix, guard mandatory 71-bit configuration |

## Batch 2 (10 scripts)

| Script (`test-*.sh`) | Current coverage | Recommendation |
| --- | --- | --- |
| kcc-gcc-layout-edge | K/G mixed, KS, G O1, 71-bit, execute | Mixed ABI matrix; compare layouts independently of optimizer |
| kcc-gcc-negative-dimode | K/G mixed, KS, G O2, 71-bit, execute | Mixed ABI matrix; include signed edge values and helper availability |
| kcc-gcc-nested-union | K/G mixed, KS, G O1, 71-bit, execute | Mixed ABI matrix; CPU candidates after validation |
| kcc-gcc-object-symbol | K/G, base, G O1, assemble/object/link | Toolchain/linker matrix, not simulator semantic cell; vary optimization and CPU only when meaningful |
| kcc-gcc-reloc | K/G mixed, KS, G O1, 71-bit, execute | Mixed-direction relocation/ABI matrix |
| kcc-gcc-representation-adapter | K/G mixed, KS, G O1, execute | Mixed ABI with representation adapter; preserve explicit adapter contract |
| kcc-gcc-runtime-helper | K/G linked, KS, G O1, 71-bit, execute | Linked-helper dependency matrix, check runtime symbol ownership |
| kcc-gcc-varargs-matrix | K/G mixed, KS, G O1, 71-bit, execute | Mixed variadic ABI matrix; preserve caller/callee direction |
| language-casts | K only, P6 target, shape | KCC-specific narrow-type instruction regression; validate other targets individually |
| language-char-enum | K/G, P6, G O1, execute | Per-compiler, CPU and optimization semantic matrix candidate |

## Batch 3 (9 scripts)

| Script (`test-*.sh`) | Current coverage | Recommendation |
| --- | --- | --- |
| language-compat | K/G, base, G O1, KS execute + negative compile | Split positive semantic runtime and deliberate KCC attribute rejection; keep compiler-specific expected outcome |
| language-conversions | K/G, base, G O1, P6 execute | Semantic matrix candidate; check target/runtime coherence |
| language-direct-widening | K/G, P6, G O1, 71-bit, execute | Semantic matrix candidate with required language mode |
| language-full-range | K/G, P6, G O1, 71-bit, execute | Semantic matrix candidate with edge-value coverage |
| language-promotions | K/G, base, G O1, P6 execute | Semantic matrix candidate |
| layout-float-abi | K/G, base, G O1, shape | ABI layout/representation invariants; do not demand identical instruction selection |
| mixed-call-depth | K/G mixed, KS, G O1, 71-bit, execute | Cross-compiler call-chain matrix; control combinatorial growth |
| mixed-fixed-exec | K/G mixed, KS, G O1, 71-bit, execute | Mixed-direction executable ABI matrix |
| packed-bitptr-arith | K/G, P6, G O1, execute | Per-compiler CPU/optimization semantic cells; validate character layout |

## Batch 4 (9 scripts)

| Script (`test-*.sh`) | Current coverage | Recommendation |
| --- | --- | --- |
| packed-bitptr | K/G, P6, G O1, execute | Per-compiler CPU/optimization semantic cells |
| packed-char | K/G, P6, G O1, execute | Per-compiler CPU/optimization semantic cells |
| pointer-abi | K/G, base, G O1, shape | Architecture-wide ABI rules; replace optimizer-specific grep where possible |
| small-aggregate-arg-abi | K/G mixed, KS, G O1, execute | Mixed-direction ABI matrix |
| symbol-runtime-abi | K/G, base, G O1, shape | Compiler/toolchain ABI and symbol invariant matrix |
| wide-call-abi | K/G, base, G O1, 71-bit, shape | Split register ABI invariants from code-shape expectations |
| wide-data-layout | K/G, base, G O1, 71-bit, compile/shape | Per-compiler/CPU/optimization layout checks where supported |
| wide-int-modes | K/G, base, G O1, GCC 71/72-bit, compile/shape | Explicit *language-mode* dimension; 71/72 tests must not be merged blindly |
| wide-varargs-abi | K/G, base, G O1, 71-bit, KS execute | GCC->KCC variadic ABI plus KCC control; not yet symmetric KCC->GCC |

## Migration rules

1. Preserve the exact existing verification behavior until replacement cells
   demonstrate equivalent coverage. Record CPU/ISA capabilities explicitly.
2. Move independent execution tests to ordinary compiler/CPU/optimization
   cells. Do not multiply assembly-shape assertions across optimizations
   whose generated instruction sequences were not part of the original claim.
3. Give mixed compiler tests independent `caller_compiler`,
   `callee_compiler`, `caller_opt`, `callee_opt`, `cpu`, and `isa` selectors.
   Only enumerate valid combinations; runtime and link support are prerequisites.
4. Keep paired optimization comparisons as paired tests, not two unrelated
   independently green cells. Split combined positive/negative tests.
5. Retain tests of the *set on condition* code-generation pattern; these are
   not references to a separate compiler.
6. During migration require a baseline and parity test per moved script,
   restartable cell reporting, and explicit unsupported reasons.

This is a source-level audit, not an execution/compatibility certification.
