# UTF-9 standalone codec validation (2026-10-14, v1)

Implementation: `pdp10-tools/utf9-codec-v1.c` and `.h` (sibling repository).
RFC 4042 section 3, including corrected U+10000 threshold (verified erratum
7868). This implementation accepts Unicode scalar values only: U+0000 through
U+10FFFF excluding UTF-16 surrogates. It rejects overlong/noncanonical,
truncated, excess-length, and out-of-range nonet sequences.

Host-side test source: `misc/compat/test-utf9-codec-v1.c`. It checks RFC
examples, boundaries, malformed input, and full scalar round trips. Build:

```sh
export TMPDIR=${TMPDIR:-$HOME/tmp}
cc -std=c99 -O2 -Wall -Wextra -Werror -I"$HOME/git/pdp10-tools" \
    misc/compat/test-utf9-codec-v1.c \
    "$HOME/git/pdp10-tools/utf9-codec-v1.c" -o "$TMPDIR/test-utf9-codec-v1"
"$TMPDIR/test-utf9-codec-v1"
```

Result: PASS on the host, including full Unicode scalar round trips. The
codec now also has strict UTF-8 scalar decoding and UTF-8 to UTF-9 nonet
array conversion. Invalid/overlong UTF-8, surrogates and values greater
than U+10FFFF are rejected; incomplete sequences return -2. The converter
checks all input and output capacity before writing to the destination.

`tests/semantic/utf9-codec-pdp6-v1.c` compiles and runs successfully on a
PDP-6 with both KCC and GCC -O0, linking the codec object from its C99
source with the minimal `p10run` harness. Both runs PASS. This remains a
library codec, not a host file conversion tool or a KCC source-encoding
change. Keep ASCII-only compiler syntax policy intact pending separate
design work.

## Target-side boundary regression (2026-10-15)

`tests/semantic/utf9-codec-pdp6-v2.c` exercises UTF-9 scalar boundaries,
the UTF-16 surrogate gap, maximum Unicode code point, malformed UTF-8
and UTF-9 sequences, and atomic output on insufficient buffer capacity.
It uses only freestanding C99 and no hosted library functions.

Both KCC PDP-6 and GCC PDP-6 `-O0` compiled the production codec and this
test as separate assembly sources and executed them through `p10run` with
`__test_exit=0`: **PASS for both compilers**. The test is additive to the
earlier target smoke test and does not change SIXBIT/S6REC storage policy.
