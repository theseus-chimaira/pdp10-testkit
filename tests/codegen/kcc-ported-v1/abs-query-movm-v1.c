/* codegen-kcc-policy-only: yes */
/* Original KCC assembly requirements. */
/* codegen-require-regex: "(?ims)^f:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^g:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" */
/* codegen-forbid-regex: "(?ims)^f:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:jumpge|jumpl|jrst)\\s+)" "(?ims)^g:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:jumpge|jumpl|jrst)\\s+)" "(?ims)^vf:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^uf:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" */
int f(x)
int x;
{
    return x < 0 ? -x : x;
}

int g(x)
int x;
{
    return 0 > x ? -x : x;
}

volatile int vv;
int vf()
{
    return vv < 0 ? -vv : vv;
}

unsigned int uf(x)
unsigned int x;
{
    return x < 0 ? -x : x;
}
