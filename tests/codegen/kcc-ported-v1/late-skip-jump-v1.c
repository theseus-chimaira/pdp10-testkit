/* Preserved late skip/jump folding regression. */
/* codegen-require-regex: "(?im)^\\s*jumpe\\s+[0-9]+," */
/* codegen-forbid-regex: "(?im)^\\s*skipn\\s+([0-7]+),\\1\\s*\\n\\s*jrst\\s+" */
int f(p, q, a, b, c, d, e, fv)
volatile int *p;
volatile int *q;
int a, b, c, d, e, fv;
{
    int s0, s1, s2, x;

    s0 = a + b;
    s1 = c + d;
    s2 = e + fv;
    x = *p;
    if (x != 0)
        return x + s0 + s2;
    return *q + s1 + s2;
}
