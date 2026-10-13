/* Original KCC assembly policy, preserved. */
/* codegen-require-regex: "DIADD" */
/* codegen-forbid-regex: "(?im)^\\s*d?movem\\s+[1-4],-?[0-9]+\\(17\\)" */
typedef long long Dint;
Dint addpair(Dint a, Dint b) { return a + b; }
