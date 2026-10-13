/* KCC instruction regression, migrated to native matrix. */
/* codegen-require-regex: "(?i)move[i]?\\s+1,\\[?0?377777777777\\]?" "(?i)move[i]?\\s+2,\\[?0?377777777777\\]?" "(?ims)\\A(?:(?!^\\s*movsi\\s+1,0?400000).)*^\\s*movsi\\s+1,0?400000[^\\n]*\\n(?:(?!^\\s*movsi\\s+1,0?400000).)*^\\s*movsi\\s+1,0?400000[^\\n]*\\n(?:(?!^\\s*movsi\\s+1,0?400000).)*^\\s*movsi\\s+1,0?400000[^\\n]*\\n(?:(?!^\\s*movsi\\s+1,0?400000).)*^\\s*movsi\\s+1,0?400000[^\\n]*\\n" "(?i)move\\s+1,\\[0?377777777777\\]" "(?i)move\\s+2,\\[0?377777777777\\]" */
typedef unsigned long long U;
typedef long long S;
U b34m1(void) { return 0x3ffffffffULL; }
U b34(void) { return 0x400000000ULL; }
U b35m1(void) { return 0x7ffffffffULL; }
U b35(void) { return 0x800000000ULL; }
U b36(void) { return 0x1000000000ULL; }
U b70(void) { return 0x400000000000000000ULL; }
U b70m1(void) { return 0x3fffffffffffffffffULL; }
U b70dec(void) { return 1180591620717411303424ULL; }
S n70(void) { return -0x400000000000000000LL; }
U cast70(void) { return (U)0x400000000000000000ULL; }
