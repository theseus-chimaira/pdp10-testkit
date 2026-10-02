volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static double dfun(a, b)
int a;
int b;
{
    double x;
    x = (double)a * 1.5 + (double)b * 0.5;
    return x;
}

static int ifun(x, k)
double x;
int k;
{
    return (int)x + k;
}

int main()
{
    double d;
    fail_id = 0;
    d = dfun(6, 11);
    got = ifun(d, 3);
    if (got != 17) { fail_id = 1; return 1; }
    if (d > 14.25 && d < 14.75)
        got1 = got + 3;
    else
        got1 = 0;
    if (got1 != 20) { fail_id = 2; return 1; }
    return 0;
}
