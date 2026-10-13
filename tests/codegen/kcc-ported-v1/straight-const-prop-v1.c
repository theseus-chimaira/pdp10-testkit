/* Migrated original KCC instruction assertions. */
/* codegen-require-regex: "(?ims)^chain:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movei\\s+1,7)" "(?ims)^reassignment:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movei\\s+1,1)" "(?ims)^call_barrier:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam|jump|skip)" "(?ims)^pointer_barrier:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam|jump|skip)" "(?ims)^volatile_barrier:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam|jump|skip)" */
/* codegen-forbid-regex: "(?ims)^chain:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam|jrst\\s+%L)" "(?ims)^reassignment:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:cai|cam)" */
extern int side(void);
volatile int vg;

int chain(void)
{
    int a, b;
    a = -3;
    b = a + 5;
    if (b == 2)
        return 7;
    return 9;
}

int reassignment(void)
{
    int a;
    a = 1;
    a = 4;
    if (a == 4)
        return 1;
    return 0;
}

int call_barrier(void)
{
    int a;
    a = 3;
    side();
    if (a == 3)
        return 1;
    return 0;
}

int pointer_barrier(void)
{
    int a;
    int *p;
    p = &a;
    a = 3;
    *p = 4;
    if (a == 3)
        return 1;
    return 0;
}

int volatile_barrier(void)
{
    int a;
    a = 3;
    if (vg && a == 3)
        return 1;
    return 0;
}
