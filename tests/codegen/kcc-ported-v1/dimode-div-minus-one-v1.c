/* codegen-kcc-policy-only: yes */
/* Original KCC instruction assertion migration. */
/* codegen-require-regex: "(?i)MOVN" "(?i)SETZ" "source" */
/* codegen-forbid-regex: "%DIDIV" */
long long divm1(long long x) { return x / -1LL; }
long long modm1(long long x) { return x % -1LL; }
extern long long source(void);
long long modside(void) { return source() % -1LL; }
