/* codegen-kcc-policy-only: yes */
/* Original KCC assembly requirements. */
/* codegen-require-regex: "(?ims)^write_barrier:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam|jump|skip)" "(?ims)^pointer_barrier:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam|jump|skip)" "(?ims)^call_barrier:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam|jump|skip)" "(?ims)^escape_barrier:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam|jump|skip)" */
/* codegen-forbid-regex: "(?ims)^signed_chain:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam|jump|skip)" "(?ims)^unsigned_chain:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam|jump|skip)" */
extern int side(void);
volatile int sink;

int signed_chain(void)
{
    int a;
    a = -3;
    if (a < 0) sink += 1; else return 11;
    if (a <= -3) sink += 2; else return 12;
    if (a != 3) sink += 4; else return 13;
    if (3 >= a) sink += 8; else return 14;
    return 0;
}

int unsigned_chain(void)
{
    unsigned int u;
    u = 0400000000000U;
    if (u > 1U) sink += 1; else return 21;
    if (u >= 0400000000000U) sink += 2; else return 22;
    if (u != 1U) sink += 4; else return 23;
    return 0;
}

int write_barrier(void)
{
    int a;
    a = 3;
    if (a == 3) a = 4;
    if (a == 3) return 1;
    return 0;
}

int pointer_barrier(void)
{
    int a, *p;
    p = &a;
    a = 3;
    if (a == 3) *p = 4;
    if (a == 3) return 1;
    return 0;
}

int call_barrier(void)
{
    int a;
    a = 3;
    if (a == 3) side();
    if (a == 3) return 1;
    return 0;
}

int escape_barrier(void)
{
    int a, *p;
    a = 3;
    if (a == 3) p = &a;
    if (a == 3) return p != 0;
    return 0;
}
