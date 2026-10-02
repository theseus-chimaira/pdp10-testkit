volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int near_int(x, want)
double x;
int want;
{
    double d;
    d = x - (double)want;
    if (d < 0.0) d = -d;
    return d < 0.01;
}

static double fd(a, b, c)
double a;
double b;
double c;
{
    return (a + b) * c / 2.0;
}

static float ff(a, b)
float a;
float b;
{
    return (a - b) * 3.0f;
}

int main()
{
    double d;
    float f;
    fail_id = 0;
    d = fd(10.0, 6.0, 5.0);
    got = near_int(d, 40);
    if (got != 1) { fail_id = 1; return 1; }
    f = ff(7.0f, 2.0f);
    got1 = near_int((double)f, 15);
    if (got1 != 1) { fail_id = 2; return 1; }
    got2 = (int)3.75;
    if (got2 != 3) { fail_id = 3; return 1; }
    got3 = (int)-3.75;
    if (got3 != -3) { fail_id = 4; return 1; }
    return 0;
}
