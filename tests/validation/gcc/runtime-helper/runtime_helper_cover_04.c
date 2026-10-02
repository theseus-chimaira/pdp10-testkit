volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static double calc(a, b)
int a;
int b;
{
    double x;
    x = ((double)a + 0.5) * ((double)b + 0.25);
    x = x - ((double)a / 2.0);
    return x;
}

int main()
{
    double d;
    fail_id = 0;
    d = calc(8, 19);
    got = (int)d;
    if (got != 159) { fail_id = 1; return 1; }
    got1 = d > 159.125;
    if (got1 != 1) { fail_id = 2; return 1; }
    return 0;
}
