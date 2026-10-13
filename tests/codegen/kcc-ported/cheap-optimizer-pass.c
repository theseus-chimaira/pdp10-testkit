/* codegen-kcc-policy-only: yes */
/* codegen-kcc-check: "cheap-optimizer-pass" */
int glob;

int incp(p)
int *p;
{
    return ++*p;
}

int decp(p)
int *p;
{
    return --*p;
}

int same_load(x)
int x;
{
    int a;
    a = glob;
    x *= 3;
    return a + glob + x;
}

int copy_store(p, x)
int *p;
int x;
{
    x += *p;
    *p = x;
    return x;
}

long long pair_store(p, x)
long long *p;
long long x;
{
    *p = x;
    return *p;
}
