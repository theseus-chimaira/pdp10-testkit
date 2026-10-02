volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct dw {
    double a;
    double b;
};

struct dw gd[3];

static struct dw make_dw(a, b)
double a;
double b;
{
    struct dw r;
    r.a = a;
    r.b = b;
    return r;
}

static double sum_dw(p)
struct dw *p;
{
    return p->a + p->b;
}

static int close_to(x, y)
double x;
double y;
{
    double d;
    d = x - y;
    if (d < 0.0) d = -d;
    return d < 0.01;
}

int main()
{
    double s;
    fail_id = 0;
    gd[0] = make_dw(100000.0, -33.0);
    gd[1] = gd[0];
    gd[2] = make_dw(gd[1].b, gd[1].a);
    s = sum_dw(&gd[2]);
    got = close_to(s, 99967.0);
    if (got != 1) { fail_id = 1; return 1; }
    return 0;
}
