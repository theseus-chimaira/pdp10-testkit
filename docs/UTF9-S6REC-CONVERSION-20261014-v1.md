# Explicit UTF-9 to native SIXBIT/S6REC conversion (2026-10-14, v1)

`pdp10-tools/utf9-s6rec-v1` consumes the counted packed UTF-9 `.u9p`
interchange format and writes native S6REC text records in the established
36-bit host-word container. **SIXBIT/S6REC remains the native filesystem
text representation.** This converter is an explicit optional bridge.

Default mode rejects any decoded Unicode character outside ASCII 040–0137
(except LF, which ends an S6REC record). This preserves representability
without silently substituting characters. `--lossy` explicitly substitutes
`?` for unrepresentable characters. Malformed UTF-9, invalid padding or
unexpected trailing data always fail regardless of mode; partial output is
removed. Same-file and hard-link input/output aliases are rejected.
Lowercase ASCII is **not** part of the direct SIXBIT repertoire and is
therefore rejected in strict mode; neither case folding nor C-SIX escaping
is applied implicitly.

Usage: `utf9-s6rec-v1 [--lossy] INPUT.u9p OUTPUT.s6rec`.

Validation: `misc/compat/test-utf9-s6rec-v1.py` runs strict successful
round trips through `csix -d`, default rejection, lossy replacement,
hard-link protection and malformed-input rejection.
