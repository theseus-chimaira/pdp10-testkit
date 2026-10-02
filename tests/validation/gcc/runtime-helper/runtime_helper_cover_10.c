volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int divmix(x, y)
int x;
int y;
{
    return (x / y) * 10 + (x % y);
}

int main()
{
    fail_id = 0;
    got = divmix(555, 12);
    if (got != 463) { fail_id = 1; return 1; }
    return 0;
}
