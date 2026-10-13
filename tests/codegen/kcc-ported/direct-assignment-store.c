/* codegen-kcc-policy-only: yes */
/* Original KCC assembly policies. */
/* codegen-kcc-check: direct-assignment-store */
/* codegen-require-regex: "(?ims)^put:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movem\\s+1,g)" */
/* codegen-forbid-regex: "(?ims)^put:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+[2-7],1)" "(?im)^\\s*movei\\s+[1-7],gd$" */
extern int g;
typedef long long D;
D gd;
static D sd;

int put(int a)
{
    g = a;
    return 0;
}

D global_store(D x, D m)
{
    return (gd = x & m);
}

D static_store(D x)
{
    return (sd = x);
}

D auto_store(D x)
{
    D a;
    return (a = x);
}

D arg_store(D x, D y)
{
    return (y = x);
}
