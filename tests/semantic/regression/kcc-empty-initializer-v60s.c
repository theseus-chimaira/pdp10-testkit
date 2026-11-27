/* Empty braces use the same zero initialization as omitted members. */
struct S { int a; char b[5]; double c; int *p; };
union U { long long w; int i; };
static struct S s = {};
static union U u = {};
static int a[3] = {};
static char c[7] = {};
static double d = {};
static int *p = {};
static int i = {};
static struct { struct S s; int i; } nested = {{}, 19};
static int check(struct S *v)
{
    return v->a || v->b[0] || v->b[4] || v->c != 0.0 || v->p;
}
int main(void)
{
    volatile int seed = 41;
    struct S x = {};
    union U y = {};
    int b[3] = {};
    int z = {};
    double f = {};
    int *q = {};
    struct { struct S s; int i; } runtime = {{}, seed};
    if (check(&s) || check(&x) || check(&nested.s) || check(&runtime.s))
        return 1;
    if (u.w || y.w || i || z || p || q || d != 0.0 || f != 0.0)
        return 2;
    if (a[0] || a[2] || b[0] || b[2] || c[0] || c[6])
        return 3;
    if (nested.i != 19 || runtime.i != 41)
        return 4;
    x.a = 99;
    x = (struct S){};
    return check(&x);
}
