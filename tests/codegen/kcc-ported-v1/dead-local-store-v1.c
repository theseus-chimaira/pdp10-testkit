/* codegen-kcc-policy-only: yes */
/* Original KCC assembly requirements. */
/* codegen-require-regex: "(?ims)^live_wide:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movem)" "(?ims)^volatile_wide:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movem)" "(?ims)^addressed_wide:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movem)" "(?ims)^used_result:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:12345)" */
/* codegen-forbid-regex: "(?ims)^dead_scalar:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:12345|movem)" "(?ims)^dead_wide:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:12345670123|movem)" */
int dead_scalar(void)
{
    int x;
    x = 012345;
    return 7;
}

int dead_wide(void)
{
    long long x;
    x = 012345670123LL;
    return 7;
}

long long live_wide(void)
{
    long long x;
    x = 012345670123LL;
    return x;
}

void volatile_wide(void)
{
    volatile long long x;
    x = 012345670123LL;
}

int addressed_wide(void)
{
    long long x;
    long long *p;
    p = &x;
    x = 012345670123LL;
    return p != 0;
}

int used_result(void)
{
    int x;
    return (x = 012345) == 012345;
}
