# KCC literal repairs v36c (2026-11-24)

KCC commit c9e688e; installed hosted SHA256:
58d1028f6cf42f5fc80a31df8bc9eb5a02c17450b790bbcaceb33a6e1b550525.

- Reuse native 36-bit int as wchar_t; wide literals are arrays of int,
  converted to word pointers as required. Preserve literal element
  counts and type in sizeof, address-taking, indexing and initializers.
- The existing literal pool retains one octet per ordinary character.
  A ninth-bit narrow literal promotes to two octets per element and a
  wide literal to five octets per element. No extra permanent pool or
  per-node fields. KIR1 uses storage flags and explicit byte count.
- The host raw byte source reader preserves high-bit bytes; packed
  seven-bit and C-SIX paths are unchanged.

Installed original replay (strict): 20010325-1.c 22/22 PASS;
20000227-1.c 22/22 PASS. New kcc-wide-literal-v36b.c 22/22 PASS.
Six narrow guard runtime cells passed, 36 compile-only checks passed
in staging. Existing C-SIX guard passes including native ccsrc assembly
and assembly-to-object. Hosted split phase transport passed at -O and
-n, including exact wide words and existing float transport. Native
PDP-6 cross-compilation of cclex, ccnode, cckirwrite and cckirread passed.
The phase host build emits a pre-existing cc.c return-type warning.

Remaining historical KCC failures: 103 runtime, zero compile/link.
GCC was not run or modified. Native compiler execution not verified;
no full sweep. Wide UCN escape mapping uses Unicode scalar values;
full multibyte source decoding and narrow UCN conversion are not claimed.
The fixed literal pool capacity is unchanged, so wide strings use more
of the existing pool. The concurrent native KGEN edits remain untouched.
Exact installed evidence is recorded in v36c result manifests.
