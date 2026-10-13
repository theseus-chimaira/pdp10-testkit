/* Migrated KCC assembly assertions. */
/* codegen-require-regex: "(?ims)^low:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hrrz\\s+[0-7]+,0\\(1\\)" "(?ims)^high:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hlrz\\s+[0-7]+,0\\(1\\)" "(?ims)^shift18:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hlrz\\s+[0-7]+,0\\(1\\)" "(?ims)^lowreg:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hrrz\\s+[0-7]+,[0-7]+" "(?ims)^highreg:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*hlrz\\s+[0-7]+,[0-7]+" */
/* codegen-forbid-regex: "(?ims)^shift18:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*lsh\\s+[0-7]+,-22" "(?ims)^low:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*move\\s+[0-7]+,0\\(1\\)" "(?ims)^high:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*move\\s+[0-7]+,0\\(1\\)" "(?ims)^lowreg:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*move\\s+2,10\\s*$" "(?ims)^highreg:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*move\\s+2,10\\s*$" */
unsigned long low(unsigned long *p)
{
    return *p & 0777777UL;
}

unsigned long high(unsigned long *p)
{
    return (*p >> 18) & 0777777UL;
}

unsigned long shift18(unsigned long *p)
{
    return *p >> 18;
}

unsigned long sink;

void lowreg(unsigned long x)
{
    unsigned long y;

    y = x;
    sink = y & 0777777UL;
}

void highreg(unsigned long x)
{
    unsigned long y;

    y = x;
    sink = (y >> 18) & 0777777UL;
}
