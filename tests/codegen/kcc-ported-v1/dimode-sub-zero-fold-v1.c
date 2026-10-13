/* Migrated original KCC assembly-pattern regression. */
/* codegen-forbid-regex: "%DISUB" */
typedef long long Dint;
typedef unsigned long long Uint;
Dint ss(Dint x) { return x - 0LL; }
Uint us(Uint x) { return x - 0ULL; }
