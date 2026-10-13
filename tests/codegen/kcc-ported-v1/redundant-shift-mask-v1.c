/* codegen-kcc-policy-only: yes */
/* KCC codegen assertion migrated from legacy shell. */
/* codegen-require-regex: "(?ims)^needed:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?andi\\s+" */
/* codegen-forbid-regex: "(?ims)^redundant:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?andi\\s+" */
unsigned long redundant(x)
unsigned long x;
{
    return (x >> 26) & 01777UL;
}

unsigned long needed(x)
unsigned long x;
{
    return (x >> 26) & 0777UL;
}
