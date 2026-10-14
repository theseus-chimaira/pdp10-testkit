volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int rec(n)
int n;
{
    if (n < 2)
        return n + 9;
    return rec(n - 1) + rec(n - 2) + 1;
}

static int call2(x, y)
int x;
int y;
{
    return x + y;
}

int main()
{
    fail_id = 0;
    got = rec(4);
    if (got != 52) { fail_id = 1; return 1; }
    got1 = call2(got, 17);
    if (got1 != 69) { fail_id = 2; return 1; }
    return 0;
}
