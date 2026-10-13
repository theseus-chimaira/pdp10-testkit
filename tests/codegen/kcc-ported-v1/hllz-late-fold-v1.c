/* Migrated KCC assembly assertions. */
/* codegen-require-regex: "(?ims)^highmask:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hllz\\s+[0-7]+,0\\([0-7]+\\)" */
/* codegen-forbid-regex: "(?ims)^highmask:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*trz\\s+[0-7]+,777777" */
unsigned long highmask(unsigned long *p)
{
    unsigned long x;

    x = *p;
    return x & 0777777000000UL;
}
