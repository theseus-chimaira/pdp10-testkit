/* codegen-kcc-policy-only: yes */
/* Original KCC regression checks. */
/* codegen-require-regex: "(?ims)^callit:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*move\\s+16,1(\\s|$))" "(?ims)^callit:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*pushj\\s+17,0\\(16\\)(\\s|$))" */
/* codegen-forbid-regex: "(?ims)^callit:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*pushj\\s+17,0\\([1-4]\\)(\\s|$))" */
static int add_at(p, i, v)
char *p;
int i;
int v;
{
    p[i] = (char)(p[i] + v);
    return p[i];
}

static int callit(fn, p, i, v)
int (*fn)();
char *p;
int i;
int v;
{
    return (*fn)(p, i, v) + p[0];
}

int main()
{
    char b[4];
    b[0] = 10;
    b[1] = 20;
    b[2] = 30;
    b[3] = 40;
    return callit(add_at, b, 2, 7) != 47;
}
