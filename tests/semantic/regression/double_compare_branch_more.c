volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;

static int dcmp(a, b)
double a;
double b;
{
    int r;
    r = 0;
    if (a < b) r += 1;
    if (a <= b) r += 2;
    if (a == b) r += 4;
    if (a != b) r += 8;
    if (a >= b) r += 16;
    if (a > b) r += 32;
    return r;
}

int main()
{
    got = dcmp(1.5, 2.5);
    if (got != 11) { fail_id = 1; return 1; }
    got1 = dcmp(-2.0, -2.0);
    if (got1 != 22) { fail_id = 2; return 1; }
    got2 = dcmp(4.0, -1.0);
    if (got2 != 56) { fail_id = 3; return 1; }
    return 0;
}
