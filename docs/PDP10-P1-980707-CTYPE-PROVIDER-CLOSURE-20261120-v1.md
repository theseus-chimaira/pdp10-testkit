# KCC PDP-6 980707: `isspace` brings duplicate `exit`/`abort` owners (v1)

Date: 2026-11-20. Scope: **`pdp10-testkit` only**. This report
corrects the previous suspected linker/assembler interpretation in
`PDP10-P1-BATCH5-CONTRACT-20261120-v1.md`. No historical original,
runtime, linker, compiler, assembler or sibling repository was changed.
The full compiler/CPU/optimization sweep remains deferred.

## Current original result and six explicit object symbols

The original `tests/todo/generic/980707-1.c` is unchanged at SHA256
`43c389a719d17d876d0f9f942d5db81f737c8eed7608de204862f23a6359e7b7`.
It uses target `isspace` to split a text buffer into two arguments;
its `strcmp` assertions call `abort` on mismatch and `exit(0)` on
success. It needs real ctype behavior and correct guest termination.

The fresh installed KCC native PDP-6 noopt source still reports
**`link_fail`: `dlink: duplicate global: exit`**. The six explicitly
assembled objects contain precisely one `DEF exit` and one
`DEF abort`: the upstream freestanding CRT's termination helpers.
The C object references `isspace` but does not define it. The selected
real freestanding string/strcmp fragments do not supply `isspace`.

The default installed `lib/libc.a` **does** supply `isspace` but its
hosted runtime also supplies `exit` and `abort`. Consequently, resolving
ctype via the hosted library gives two owners for those termination
entrypoints. This is a real two-provider conflict, not proof of a
broken `dlink` symbol-table collision check.

## Five controlled live original-object links

The exact six original `.dobj` objects, canonical libc and canonical
libgcc were replayed through installed `dlink` in original order.

| Explicit objects and linked archives | Actual result |
| --- | --- |
| All six objects, including test CRT `exit`/`abort`, plus libc | **FAIL** duplicate global `exit` |
| Drop only explicit `exit`, retaining explicit `abort`, plus libc | **FAIL** duplicate global `abort` |
| Drop explicit `exit` and `abort`, retain real string/strcmp fragments and libc | **LINK PASS**; map has one each of `exit`, `abort`, `isspace`, `strcmp`, `strcpy`, `main` and `__test_exit` |
| All six original objects, without libc | **FAIL** unresolved `isspace` |
| Only CRT and original compiler object with libc | **LINK PASS**; library resolves ctype/string and both termination symbols |

**Neither LINK PASS proves the original guest test passes.** The
freestanding test harness termination functions must store the
observable `__test_exit` status and HALT. Merely accepting hosted
libc's own `exit` and `abort` without validating those guest semantics
could silently defeat the failure oracle. Therefore the testkit
must not remove its termination helpers as an expedient workaround.

## Archived and repeatable evidence

`refs/p10tk-p1-980707-ctype-provider-20261120-v1.tar.gz` retains
the six native original linker objects, five actual linker outcomes
and two successful linker maps. The corresponding manifest
`PDP10-P1-980707-CTYPE-PROVIDER-EVIDENCE-20261120-v1.tsv`
SHA256-pins all 13 artifacts. It uses the currently installed
unmodified archives:

* `lib/libc.a`: `c38253782d1ad94649c83f1751e49618608e1d7fd844ddff3a97c2c73b216091`
* `lib/gcc-lib/pdp10-dec-none/3.2/libgcc.a`: `9bead1fd78365d1fa96f868c24e3234d035673e16db01301946f553aa4b097d2`

`tools/test-p1-980707-ctype-provider-v1.py` checks the frozen source,
all artifact hashes, original duplicate-global diagnosis, full map
symbol ownership and six negative provenance controls. Its
`--require-cross` option also runs all five real installed `dlink`
scenarios, checks the single explicit `exit`/`abort` definitions via
`pdp10-objdump`, and compares output/maps byte-for-byte.

## Disposition and remaining P1 work

The original result stays **`link_fail`**; P1 test construction is
still **blocked**. Runtime behavior of the ctype splitter, matching
`abort`/`exit` paths and fully preserved 9-bit target representation
remains to be proved. The observed `isspace` symbol is available in
the hosted archive but is not a currently standalone freestanding
member selected by the compiler runner. Do not conflate that provider
gap with a universally missing libc function.

This and `920501-8.c` are now independently diagnosed overlapping
provider conflicts. Their original `dlink` diagnostics are genuine;
neither is currently evidence of a broken linker implementation.
The nine separate compiler ICE/signal cases retain repair priority.

To replay only these exact original linker objects:

```sh
export TMPDIR="${TMPDIR:-$HOME/tmp}"
python3 tools/test-p1-980707-ctype-provider-v1.py --require-cross
```
