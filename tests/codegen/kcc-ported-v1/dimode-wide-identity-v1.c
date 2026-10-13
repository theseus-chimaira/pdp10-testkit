/* codegen-kcc-policy-only: yes */
/* Normalized KCC assembly assertions. */
/* codegen-require-regex: "(?im)^\\s*LSHC\\s+[^,]+,-43$" "(?im)^\\s*LSHC\\s+[^,]+,-44$" "(?im)^\\s*LSHC\\s+[^,]+,-106$" */
/* codegen-forbid-regex: "lshc\\s+[^\\n]*,-1" */
typedef long long S;
typedef unsigned long long U;
S sd35(S x) { return x / 0x800000000LL; }
S sd36(S x) { return x / 0x1000000000LL; }
S sd70(S x) { return x / 0x400000000000000000LL; }
U ud35(U x) { return x / 0x800000000ULL; }
U um35(U x) { return x % 0x800000000ULL; }
U and35(U x) { return x & 0x800000000ULL; }
U or35(U x) { return x | 0x800000000ULL; }
U xor35(U x) { return x ^ 0x800000000ULL; }
