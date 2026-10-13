/* codegen-kcc-policy-only: yes */
/* KCC source and original assembly policies. */
/* codegen-require-regex: "lsh" */
/* codegen-forbid-regex: "(?i)push\\s+17,16|move\\s+16,0\\(17\\)" */
unsigned long shl(unsigned long x, unsigned long n)
{
    return x << n;
}

unsigned long shr(unsigned long x, unsigned long n)
{
    return x >> n;
}

void setl(unsigned long *p, unsigned long x)
{
    *p = (*p & 0777777UL) | ((x & 0777777UL) << 18);
}
