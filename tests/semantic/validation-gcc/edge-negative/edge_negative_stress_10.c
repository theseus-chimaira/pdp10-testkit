volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

int main()
{
    int x;
    fail_id = 0;
    x = (15 << 3) + (29 >> 1) - ((15 + 29) & 7);
    got = x;
    if (got != 130) { fail_id = 1; return 1; }
    got1 = (x & 31) | ((x >> 2) & 64);
    if (got1 != 2) { fail_id = 2; return 1; }
    return 0;
}
