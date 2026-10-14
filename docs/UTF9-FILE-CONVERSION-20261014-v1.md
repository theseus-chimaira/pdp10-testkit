# UTF-9 packed file exchange converter (2026-10-14, v1)

Tool: `pdp10-tools/utf9-file-v1`, built and installed through that
repository's Makefile. Usage: `utf9-file-v1 INPUT.utf8 OUTPUT.u9p`.

The **host interchange format**, not a native DAIMOS filesystem format,
contains an eight-octet unsigned big-endian count of UTF-9 nonets followed
by that many nine-bit values, bit-packed most significant bit first.
Padding bits at the end are zero; no implicit Unicode BOM or terminator
is added. Conversion streams through its input with bounded RAM usage.
The count allows distinguishing trailing padding from real text data.

The tool rejects invalid UTF-8 and incomplete sequences, guards against
direct or hard-linked input/output aliasing, and removes an output file
when conversion fails. It requires a seekable output to patch the nonet
count; it is not a stdin/stdout filter. It does not yet implement reverse
conversion, native DAIMOS text-file storage, or compiler source decoding.

Validation: `misc/compat/test-utf9-file-v1.py /path/to/utf9-file-v1`.
Independent Python reference packing covers ASCII, embedded NUL, Unicode
boundaries, supplementary code points and long mixed-content strings,
plus malformed inputs and input/output alias rejection.
