/* codegen-kcc-policy-only: yes */
/* Migrated original KCC instruction assertions. */
/* codegen-require-regex: "(?ims)^rotv:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*rot\\s+).)*^\\s*rot\\s+[^\\n]*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*rot\\s+).)*(?=^[A-Za-z_][A-Za-z0-9_]*:|\\Z)" "(?ims)^rot5:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*rot\\s+[0-7]+,5)" "(?ims)^rotrv:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*rot\\s+).)*^\\s*rot\\s+[^\\n]*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*rot\\s+).)*(?=^[A-Za-z_][A-Za-z0-9_]*:|\\Z)" "(?ims)^rotrv:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*movn\\s+).)*^\\s*movn\\s+[^\\n]*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*movn\\s+).)*(?=^[A-Za-z_][A-Za-z0-9_]*:|\\Z)" "(?ims)^rotr5:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*rot\\s+[0-7]+,0?37)" */
/* codegen-forbid-regex: "(?ims)^rotvol:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:rot\\s+)" "(?ims)^rotsigned:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:rot\\s+)" */
unsigned long rotv(x, n)
unsigned long x;
int n;
{
    return (x << n) | (x >> (36 - n));
}

unsigned long rot5(x)
unsigned long x;
{
    return (x << 5) | (x >> 31);
}

unsigned long rotrv(x, n)
unsigned long x;
int n;
{
    return (x >> n) | (x << (36 - n));
}

unsigned long rotr5(x)
unsigned long x;
{
    return (x >> 5) | (x << 31);
}

volatile unsigned long vx;

unsigned long rotvol(n)
int n;
{
    return (vx << n) | (vx >> (36 - n));
}

long rotsigned(x, n)
long x;
int n;
{
    return (x << n) | (x >> (36 - n));
}
