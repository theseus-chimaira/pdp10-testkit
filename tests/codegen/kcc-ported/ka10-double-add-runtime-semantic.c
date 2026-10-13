volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;

static double add2(a, b)
double a;
double b;
{
    return a + b;
}

static double mul2(a, b)
double a;
double b;
{
    return a * b;
}

static double div2(a, b)
double a;
double b;
{
    return a / b;
}

int main()
{
    double x;
    float f;

    fail_id = 0;
    x = add2(4.75, 2.5);
    got = (int)x;
    if (got != 7) { fail_id = 1; return 1; }

    f = x - 1.25;
    got1 = (int)f;
    if (got1 != 6) { fail_id = 2; return 1; }

    x = x + 3.0;
    got2 = (int)x;
    if (got2 != 10) { fail_id = 3; return 1; }

    f = mul2(2.0f, 3.0f);
    got3 = (int)f;
    if (got3 != 6) { fail_id = 4; return 1; }

    x = div2(40.0, 2.0);
    got4 = (int)x;
    if (got4 != 20) { fail_id = 5; return 1; }

    return 0;
}
