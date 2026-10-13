/* codegen-kcc-policy-only: yes */
/* Migrated original KCC instruction assertions. */
/* codegen-require-regex: "(?ims)^shift1:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:lsh\\s+1,1)" "(?ims)^shift_add_self:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+[0-7]+,1)" "(?ims)^shift_add_other:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:lsh\\s+1,1)" "(?ims)^shift_xor:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:lsh\\s+1,-3)" "(?ims)^ash_add:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:ash\\s+1,-2)" */
/* codegen-forbid-regex: "(?ims)^shift1:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+[0-7]+,1|move\\s+1,[0-7]+)" */
unsigned long
shift1(x)
unsigned long x;
{
    return x << 1;
}

unsigned long
shift_add_self(x)
unsigned long x;
{
    return (x << 1) + x;
}

unsigned long
shift_add_other(x, y)
unsigned long x;
unsigned long y;
{
    return (x << 1) + y;
}

unsigned long
shift_xor(x)
unsigned long x;
{
    return (x >> 3) ^ 5;
}

long
ash_add(x)
long x;
{
    return (x >> 2) + 1;
}
