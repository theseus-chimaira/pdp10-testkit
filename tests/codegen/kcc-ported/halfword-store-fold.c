/* codegen-kcc-policy-only: yes */
/* Migrated KCC assembly assertions. */
/* codegen-require-regex: "(?ims)^setr:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hrrm\\s+[0-7]+,0\\(1\\)" "(?ims)^setl:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hrlm\\s+[0-7]+,0\\(1\\)" "(?ims)^setrmem:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hrrz\\s+[0-7]+,0\\(2\\)" "(?ims)^setrmem:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hrrm\\s+[0-7]+,0\\(1\\)" "(?ims)^setlmem:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hlrz\\s+[0-7]+,0\\(2\\)" "(?ims)^setlmem:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hrlm\\s+[0-7]+,0\\(1\\)" "(?ims)^setlraw:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hrlm\\s+[0-7]+,0\\(1\\)" */
/* codegen-forbid-regex: "(?ims)^setlmem:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*lsh\\s+" "(?ims)^setlraw:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*lsh\\s+" "(?ims)^setr:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*movem\\s+[0-7]+,0\\(1\\)" "(?ims)^setl:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*movem\\s+[0-7]+,0\\(1\\)" "(?ims)^setrmem:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*movem\\s+[0-7]+,0\\(1\\)" "(?ims)^setlmem:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*movem\\s+[0-7]+,0\\(1\\)" "(?ims)^setlraw:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*movem\\s+[0-7]+,0\\(1\\)" */
void setr(unsigned long *p, unsigned long x)
{
    *p = (*p & 0777777000000UL) | (x & 0777777UL);
}

void setl(unsigned long *p, unsigned long x)
{
    *p = (*p & 0777777UL) | ((x & 0777777UL) << 18);
}

void setrmem(unsigned long *p, const unsigned long *q)
{
    *p = (*p & 0777777000000UL) | (*q & 0777777UL);
}

void setlmem(unsigned long *p, const unsigned long *q)
{
    *p = (*p & 0777777UL) | (((*q >> 18) & 0777777UL) << 18);
}

void setlraw(unsigned long *p, unsigned long x)
{
    *p = (*p & 0777777UL) | (x << 18);
}
