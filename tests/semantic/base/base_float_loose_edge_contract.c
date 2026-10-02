volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int near_double(x, y, e)
double x;
double y;
double e;
{
    double d;
    d = x - y;
    if (d < 0.0) d = -d;
    return d < e;
}

static double mix(a, b)
double a;
double b;
{
    double q;
    q = (a + b) - b;
    q = (q * 3.0) / 3.0;
    return q;
}

int main()
{
    double a;
    double b;
    int i;
    fail_id = 0;

    a = mix(123.0, 7.0);
    got = near_double(a, 123.0, 0.01);
    if (got != 1) { fail_id = 1; return 1; }

    b = 1.0;
    for (i = 0; i < 12; ++i)
        b = b / 2.0;
    got1 = (b > 0.0 && b < 0.001);
    if (got1 != 1) { fail_id = 2; return 1; }

    a = 1024.0;
    for (i = 0; i < 5; ++i)
        a = (a / 2.0) * 2.0;
    got2 = near_double(a, 1024.0, 0.01);
    if (got2 != 1) { fail_id = 3; return 1; }

    a = (1.0 / 3.0) * 3.0;
    got3 = near_double(a, 1.0, 0.05);
    if (got3 != 1) { fail_id = 4; return 1; }
    return 0;
}
