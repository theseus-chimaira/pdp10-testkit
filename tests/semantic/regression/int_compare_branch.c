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
    unsigned int u;
    fail_id = 0;
    got = 0;
    a = -3;
    if (a < 0) got += 1; else { fail_id = 1; return 1; }
    if (a <= -3) got += 2; else { fail_id = 2; return 1; }
    if (a != 3) got += 4; else { fail_id = 3; return 1; }
    if (3 >= a) got += 8; else { fail_id = 4; return 1; }
    u = 0400000000000U;
    if (u > 1U) got += 16; else { fail_id = 5; return 1; }
    if (got != 31) { fail_id = 6; return 1; }
    return 0;
}
