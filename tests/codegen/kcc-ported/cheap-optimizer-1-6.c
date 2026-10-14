/* codegen-kcc-extra: "-D__PDP10__" */
/* codegen-kcc-check: "cheap-optimizer-1-6" */
/* codegen-kcc-policy-only: yes */
int addarg(p, x)
int *p;
int x;
{
    return *p + x;
}

int andarg(p, x)
int *p;
int x;
{
    return *p & x;
}

int addone(p)
int *p;
{
    return *p + 1;
}

int bitzero(x)
int x;
{
    return (x & 0777) == 0;
}

int bithigh(x)
int x;
{
    return (x & 0777000000000) != 0;
}

int storezero(p)
int *p;
{
    *p = 0;
    return 0;
}

int storeones(p)
int *p;
{
    *p = -1;
    return -1;
}

int complement(p)
int *p;
{
    return ~*p;
}

int twice(p)
int *p;
{
    return *p + *p;
}
