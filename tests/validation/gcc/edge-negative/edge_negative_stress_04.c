volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int e1(a, b, c, d)
int a;
int b;
int c;
int d;
{
    return ((((a + b) * c) - a) + ((b - a) * d)) / 2;
}

int main()
{
    fail_id = 0;
    got = e1(9, 17, 3, 2);
    if (got != 42) { fail_id = 1; return 1; }
    got1 = got + e1(2, 5, 4, 1);
    if (got1 != 56) { fail_id = 2; return 1; }
    return 0;
}
