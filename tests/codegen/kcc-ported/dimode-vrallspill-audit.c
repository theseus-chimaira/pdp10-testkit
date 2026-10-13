/* codegen-kcc-policy-only: yes */
/* Original KCC source and codegen assertions. */
typedef long long D;
typedef unsigned long long U;
D addsub(D a, D b, D c) { return a + b - c; }
D divide(D a, D b) { return b ? a / b : a; }
U bits(U a, U b, U c) { return (a & b) ^ ~c; }
D tern(D a, D b, int c) { return c ? a : b; }
int logic(D a, D b) { return a && b; }
