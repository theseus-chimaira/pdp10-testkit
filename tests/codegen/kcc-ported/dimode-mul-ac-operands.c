/* codegen-kcc-policy-only: yes */
/* Normalized KCC assembly assertions. */
/* codegen-require-regex: "(?i)MUL" "(?i)IMUL" */
/* codegen-forbid-regex: "(?ims)%DIMUM(?:(?!POPJ).)*?(?:PUSH\\s+17|POP\\s+17|SUB\\s+17,\\[1,,1\\])" */
long long smul(long long a, long long b) { return a * b; }
unsigned long long umul(unsigned long long a, unsigned long long b) { return a * b; }
