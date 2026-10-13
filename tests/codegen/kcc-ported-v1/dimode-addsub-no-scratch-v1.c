/* KCC instruction regression, migrated to native matrix. */
/* codegen-require-regex: "DIADD" "DISUB" */
/* codegen-forbid-regex: "SETZ" "LSH.*-43" */
long long add71(long long a, long long b) { return a + b; }
long long sub71(long long a, long long b) { return a - b; }
unsigned long long addu71(unsigned long long a, unsigned long long b) { return a + b; }
unsigned long long subu71(unsigned long long a, unsigned long long b) { return a - b; }
