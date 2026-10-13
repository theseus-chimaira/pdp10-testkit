/* codegen-kcc-policy-only: yes */
/* Ported KCC-specific assembler shape regression. */
/* codegen-require-regex: "(?im)^\s*iori\s+1,0?123456" "(?im)^\s*andi\s+1,0?777" "(?im)^\s*xori\s+1,0?123" "(?im)^\s*tlo\s+1,0?123456" */
/* codegen-forbid-regex: "(?im)^\s*movei\s+[0-9]+,(0?123456|0?777|0?123)\s*$" */
int ior_low(int x) { return x | 0123456; }
int and_low(int x) { return x & 0777; }
int xor_low(int x) { return x ^ 0123; }
int ior_high(int x) { return x | 0123456000000; }
