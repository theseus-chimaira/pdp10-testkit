volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int close_to(x, y)
double x;
double y;
{
    double d;
    d = x - y;
    if (d < 0.0) d = -d;
    return d < 0.01;
}

static double calc(a, b, c)
double a;
double b;
double c;
{
    return ((a + b) * c - b) / 2.0;
}

int main()
{
    double d;
    fail_id = 0;
    d = calc(3.0, 5.0, 7.0);
    got = close_to(d, 25.5);
    if (got != 1) { fail_id = 1; return 1; }
    got1 = (calc(10.0, -2.0, 4.0) > 16.9);
    if (got1 != 1) { fail_id = 2; return 1; }
    got2 = (calc(10.0, -2.0, 4.0) < 17.1);
    if (got2 != 1) { fail_id = 3; return 1; }
    return 0;
}
