volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

static int cmp_cast(a, b)
double a;
double b;
{
    int r;
    r = 0;
    if (a < b) r += 1;
    if (a <= b) r += 2;
    if (a != b) r += 4;
    r += (int)(a + b);
    return r;
}

int main()
{
    double x;
    double y;
    fail_id = 0;
    x = 2.25;
    y = 5.75;
    got = cmp_cast(x, y);
    if (got != 15) { fail_id = 1; return 1; }
    got1 = cmp_cast(y, x);
    if (got1 != 12) { fail_id = 2; return 1; }
    got2 = cmp_cast(-3.5, -3.5);
    if (got2 != -5) { fail_id = 3; return 1; }
    got3 = cmp_cast(-8.25, 1.25);
    if (got3 != 0) { fail_id = 4; return 1; }
    return 0;
}
