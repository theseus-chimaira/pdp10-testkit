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

Result: PASS on the host. PDP-6 native code generation and simulation are
not yet tested. This is a scalar/nonet codec, not a UTF-8 file transcode
utility, filesystem integration, or a KCC source-encoding change. Keep
ASCII-only compiler syntax policy intact pending separate design work.
