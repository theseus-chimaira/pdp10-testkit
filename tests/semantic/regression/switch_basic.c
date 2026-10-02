volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int f(x) int x; {
    switch (x) {
    case -1: return 10;
    case 0: return 20;
    case 3: return 30;
    case 7: return 40;
    default: return 99;
    }
}
int main()
{
    fail_id = 0;
    got = f(-1);
    if (got != 10) { fail_id = 1; return 1; }
    got1 = f(3);
    if (got1 != 30) { fail_id = 2; return 1; }
    got2 = f(9);
    if (got2 != 99) { fail_id = 3; return 1; }
    got3 = f(7) + f(0);
    if (got3 != 60) { fail_id = 4; return 1; }
    return 0;
}
