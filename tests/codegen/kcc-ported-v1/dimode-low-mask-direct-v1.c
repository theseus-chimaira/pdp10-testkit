/* Original KCC assembly policy, preserved. */
/* codegen-require-regex: "(?i)SETZ" "(?i)AND.*\\[1\\]" "(?i)AND.*\\[377\\]" "(?i)AND.*\\[7777\\]" "(?i)AND.*\\[1777\\]" */
/* codegen-forbid-regex: "(?i)SETZ\\s+[4-7],|MOVEI\\s+[4-7],(1|377|7777|1777)" */
unsigned long long m2(unsigned long long x) { return x % 2ULL; }
unsigned long long m8(unsigned long long x) { return x % 256ULL; }
unsigned long long mask(unsigned long long x) { return x & 4095ULL; }
unsigned long long rmask(unsigned long long x) { return 1023ULL & x; }
