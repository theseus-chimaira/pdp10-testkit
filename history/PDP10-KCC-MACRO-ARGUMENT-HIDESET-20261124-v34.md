# KCC macro argument recursion suppression v34

The console-free v33 exact replay ran all 20 historical diagnostic
cells: 16 GCC PASS, four KCC run_fail in macro1.c, returning octal 0103
(decimal 67, the stpcpy assertion line). No link failures remained.

KCC ccpp.c margs() copied raw tokens using tokize(), resetting pt_is.
When an already expanded argument supplied an IS_MHID identifier,
this discarded permanent recursion suppression. The incorrect expansion
was `2 + M(2 + 2 + M(9))`; the correct expansion is
`2 + M(2 + M(9))`. The original guest assertion expects 42.
The v34 fix copies IS_MHID for identifier tokens from a token list;
ordinary source tokens still use normal classification. No new token
field, allocator or runtime dependency is introduced.

Compiler commit 8fc1bdc; installed executable SHA256
84c1c95a8c4cddae3c578930ac69ad784080188c529133d1e5f788bbf15ad621.
The staged build used committed v32 sources plus this ccpp.c change,
excluding unrelated working-tree changes. Native compiler execution
was not tested. The former executable was backed up under TMPDIR.

- Original macro1.c staged strict replay: 4/4 PASS.
- Six-source staged strict acceptance: 60/60 PASS, including new
  kcc-macro-argument-hideset-v34.c and v30 macro boundary regression.
- Installed exact 20-cell historical diagnostic replay: 20/20 PASS,
  zero old green skips, zero failures; 16 GCC and four KCC.
- The v33 and v34 exact result manifests pin source, assembly and
  report hashes. The v33 failure evidence remains immutable.

The historical 50-cell link-failure cohort is cumulatively closed by
v31, v32 and v34 verification. This is not a full sweep or proof of
all current matrix cells. The separate optimized GCC byte-string
regression remains open. No console implementation or assertion
weakening was used.
