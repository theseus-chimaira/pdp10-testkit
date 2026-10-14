# SIXBIT/S6REC and UTF-9 interchange round trip (2026-10-14, v1)

The host tool `s6rec-utf9-v1 INPUT.s6rec OUTPUT.u9p` converts canonical
native S6REC host-word records to the separately defined counted, packed
UTF-9 interchange container. Each raw six-bit character code maps to its
ASCII value 040–0137; record boundaries map to LF. No C-SIX escaping or
implicit case folding is performed. UTF-9/SIXBIT conversion remains
**explicit**, and SIXBIT/S6REC remains DAIMOS's native filesystem text.

The inverse `utf9-s6rec-v1` remains strict by default, rejecting Unicode
outside the directly representable SIXBIT range; only `--lossy` performs
explicit `?` replacement. The canonical round trip is byte-exact for
supported values and LF-terminated records. Noncanonical S6REC headers,
truncated 36-bit host containers, nonzero record padding and input/output
hard-link aliases are rejected.

Test with `misc/compat/test-s6rec-utf9-v1.py UTF9-S6REC S6REC-UTF9
UTF9-FILE`. This host interchange is not a change to DAIMOS's on-disk
filesystem format or native text ABI.
