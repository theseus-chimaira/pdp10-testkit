# GCC string folding v44b

Review commit f11b292 (repair/string-fold-v44b), based on 994fef8.
Hosted cc1 SHA256:
a56b1ff680229d1477819eeaca6bf0413d21b3d9823918700a5d3bffb93f1f09.

Decode two-host-byte narrow strings in all three constant element
read paths and use logical target element counts for bounds. Preserve
the original byte-pointer selector on dynamic aggregate references.
The added 9-bit string regression exposed dynamic indexing failure
on v44a; v44b fixes this without changing the oracle.

132/132 string checks, 132/132 additional packed-copy, bit-offset
and wide-narrow guards, and 22/22 KCC string regression checks pass.
77 historical cells recovered: 44 unsigned-character string-literal
cells and 33 optimized macro-boundary cells. The macro preprocessor
itself was not defective. Previous v44 repairs account for 31 more
recoveries; the recorded staged backlog is 2726 cells (176 exact-type,
2550 original historical runtime). No full sweep or installation;
earlier cumulative acceptance is still incomplete.
