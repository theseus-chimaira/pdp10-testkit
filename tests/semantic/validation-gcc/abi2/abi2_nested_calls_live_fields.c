volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct a2rec {
    char c[4];
    short s;
};

static int f1(a, b, c)
int a;
int b;
int c;
{
    return a * 2 + b - c;
}

static int f2(rp, i, x)
struct a2rec *rp;
int i;
int x;
{
    rp->c[i] = (char)(rp->c[i] + x);
    return f1(rp->c[i], rp->s, rp->c[(i + 1) & 3]);
}

static int f3(rp)
struct a2rec *rp;
{
    return f2(rp, 1, 5) + f2(rp, 3, 7) + rp->c[0];
}

int main()
{
    struct a2rec r;
    fail_id = 0;
    r.c[0] = 3;
    r.c[1] = 4;
    r.c[2] = 5;
    r.c[3] = 6;
    r.s = 20;
    got = f3(&r);
    if (got != 79) { fail_id = 1; return 1; }
    got1 = r.c[1] + r.c[3];
    if (got1 != 22) { fail_id = 2; return 1; }
    return 0;
}
