/* codegen-kcc-policy-only: yes */
/* Normalized KCC assembly assertions. */
/* codegen-require-regex: "DIADD" "(?im)^\\s*(dmove|move)\\s+[^\\n]*,[^\\n]*\\(" */
/* codegen-forbid-regex: "(?im)^\\s*d?movem\\s+[1-4],-?[0-9]+\\(17\\)" */
typedef long long Dint;
Dint addpair(Dint a, Dint b) { return a + b; }
Dint loadpair(Dint *p) { return *p; }
