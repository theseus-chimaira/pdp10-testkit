/* KCC codegen assertion migrated from legacy shell. */
/* codegen-require-regex: "(?im)^\\s*pushj\\s+17,h\\s*$" */
/* codegen-forbid-regex: "(?im)^\\s*jrst\\s+(%L[0-9]+)\\s*\\n\\1:" */
extern int h(int);
int f(int x)
{
    int y;
    y = h(x);
    if (y)
        return x;
    else
        return y;
}
