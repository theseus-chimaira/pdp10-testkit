/* codegen-kcc-policy-only: yes */
/* KCC codegen assertion migrated from legacy shell. */
/* codegen-require-regex: "(?im)^\\s*CAML?\\s+" */
typedef long long D;
typedef unsigned long long U;
int scmp(D a, D b) { return a < b; }
int ucmp(U a, U b) { return a <= b; }
