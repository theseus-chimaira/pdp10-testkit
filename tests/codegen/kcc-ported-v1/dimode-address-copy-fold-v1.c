/* KCC 72-bit pair address-copy elimination. */
/* codegen-require-regex: "(?i)DIADD" */
/* codegen-forbid-regex: "(?im)^\\s*(setm|movei)\\s+.*\\(17\\)" */
typedef long long Dint;
Dint addpair(Dint a, Dint b) { return a + b; }
