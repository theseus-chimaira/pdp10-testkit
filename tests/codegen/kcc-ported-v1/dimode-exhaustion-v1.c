/* Normalized KCC assembly assertions. */
/* codegen-require-regex:  */
/* codegen-forbid-regex:  */
typedef long long D;
typedef unsigned long long U;
D f(D a, D b, D c, D d) { return ((a + b) ^ (c - d)) + (a ? c : d); }
U g(U a, U b, U c) { return ((a | b) & ~c) + (b ? a : c); }
int h(D a, D b, U c, U d) { return a < b || c >= d; }
