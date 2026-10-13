/* Preserves the original KCC assembly checks. */
/* codegen-kcc-check: "dimode-div-one-scratch" */
long long sq(long long a, long long b) { return a / b; }
long long sr(long long a, long long b) { return a % b; }
unsigned long long uq(unsigned long long a, unsigned long long b) { return a / b; }
unsigned long long ur(unsigned long long a, unsigned long long b) { return a % b; }
