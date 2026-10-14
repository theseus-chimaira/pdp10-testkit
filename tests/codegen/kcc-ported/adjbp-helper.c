/* codegen-kcc-check: "adjbp-helper" */
/* codegen-kcc-policy-only: yes */
char *addvar(char *p, int n)
{
    return p + n;
}

char *subone(char *p)
{
    return p - 1;
}

char *addone(char *p)
{
    return p + 1;
}

typedef signed _KCCtype_char6 c6;
typedef signed _KCCtype_char7 c7;
static c7 castsrc[2];

c6 *castaddone(void)
{
    c7 *p = castsrc;
    c6 *q;

    q = (c6 *)p;
    return q + 1;
}
