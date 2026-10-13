/* Migrated KCC assembly assertions. */
/* codegen-require-regex: "(?i)hrlz" */
/* codegen-forbid-regex: "(?im)^\\s*lsh\\s+.*,22" */
unsigned long f(unsigned long x)
{
    return (x & 0777777UL) << 18;
}

unsigned long g(unsigned long *p)
{
    return (*p & 0777777UL) << 18;
}
