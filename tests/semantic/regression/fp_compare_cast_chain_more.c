volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct fpack {
    float f;
    double d;
    int tag;
};

double gd[5];
float gf;
struct fpack gb;

static double add2(a, b)
double a;
double b;
{
    return a + b;
}

static int compare_cast_store(p, k)
struct fpack *p;
int k;
{
    double x;
    int r;
    x = add2(p->d, gd[k]);
    if (x > 6.0)
        p->f = x - 1.25;
    else
        p->f = x + 2.25;
    gf = p->f;
    r = (int)p->f;
    if (p->f < x)
        r += 10;
    if (x > (double)r)
        r += 20;
    p->d = x + (double)p->tag;
    return r + (int)p->d;
}

static int sum_ptr(dp, n)
double *dp;
int n;
{
    double acc;
    int r;
    acc = 0.0;
    while (n > 0) {
        acc = acc + *dp++;
        --n;
    }
    gb.d = acc;
    gb.f = acc - 1.0;
    r = (int)gb.d;
    if (gb.d > gb.f)
        r += 10;
    if (gb.f == 6.0)
        r += 20;
    return r;
}

int main()
{
    struct fpack lb;
    fail_id = 0;
    gd[0] = 1.5;
    gd[1] = 2.5;
    gd[2] = 2.25;
    gd[3] = 3.25;
    lb.f = 0.0;
    lb.d = 4.75;
    lb.tag = 3;
    got = compare_cast_store(&lb, 1);
    if (got != 26) { fail_id = 1; return 1; }
    got1 = (int)lb.f;
    if (got1 != 6) { fail_id = 2; return 1; }
    got2 = (int)lb.d;
    if (got2 != 10) { fail_id = 3; return 1; }
    got3 = sum_ptr(&gd[0], 4);
    if (got3 != 19) { fail_id = 4; return 1; }
    got4 = (int)gb.f;
    if (got4 != 8) { fail_id = 5; return 1; }
    lb.d = -2.5;
    lb.tag = 8;
    got5 = compare_cast_store(&lb, 0);
    if (got5 != 8) { fail_id = 6; return 1; }
    return 0;
}
