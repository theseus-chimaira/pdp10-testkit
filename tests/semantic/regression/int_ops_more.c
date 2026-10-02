volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int main()
{
    int a;
    int b;
    fail_id = 0;
    a = 7;
    b = 3;
    got = a * b;
    if (got != 21) { fail_id = 1; return 1; }
    got1 = 22 / b;
    if (got1 != 7) { fail_id = 2; return 1; }
    got2 = 22 % b;
    if (got2 != 1) { fail_id = 3; return 1; }
    got3 = -a;
    if (got3 != -7) { fail_id = 4; return 1; }
    got4 = (1 << 5) + (0100 >> 3);
    if (got4 != 050) { fail_id = 5; return 1; }
    return 0;
}
