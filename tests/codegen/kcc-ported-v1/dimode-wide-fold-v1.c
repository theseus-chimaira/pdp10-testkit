/* codegen-kcc-policy-only: yes */
/* KCC 72-bit folded expressions; preserve original per-function checks. */
/* codegen-forbid-regex: "(?im)^\\s*(LSHC|ASHC)\\s+" */
/* codegen-require-regex: "(?ims)^l34:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*MOVSI\\s+2,0?200000" "(?ims)^l70:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*MOVSI\\s+1,0?400000" "(?ims)^r35:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*MOVEI\\s+1,1" "(?ims)^r35:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*SETZ\\s+2," "(?ims)^ar35:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*MOVE\\s+1,\\[0?777777777777\\]" "(?ims)^ar70:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*MOVE\\s+2,\\[0?377777777777\\]" "(?ims)^ceq:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*MOVEI\\s+1,1" "(?ims)^clt:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*MOVEI\\s+1,1" */
typedef long long S;
typedef unsigned long long U;
U l34(void) { return 1ULL << 34; }
U l35(void) { return 1ULL << 35; }
U l36(void) { return 1ULL << 36; }
U l70(void) { return 1ULL << 70; }
U r35(void) { return 0x400000000000000000ULL >> 35; }
U r36(void) { return 0x400000000000000000ULL >> 36; }
U r70(void) { return 0x400000000000000000ULL >> 70; }
S ar35(void) { return ((S)0x400000000000000000ULL) >> 35; }
S ar70(void) { return ((S)0x400000000000000000ULL) >> 70; }
U carry(void) { return 0x7ffffffffULL + 1ULL; }
U borrow(void) { return 0x800000000ULL - 1ULL; }
U comp(void) { return ~0x400000000000000000ULL; }
S negmin(void) { return -((S)0x400000000000000000ULL); }
int ceq(void) { return (1ULL << 70) == 0x400000000000000000ULL; }
int clt(void) { return ((S)0x400000000000000000ULL) < 0; }
