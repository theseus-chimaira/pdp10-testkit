volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int ga[8];
int main()
{
    int *p;
    int *q;
    int i;
    fail_id = 0;
    for (i = 0; i < 8; ++i) ga[i] = i * 3;
    p = ga;
    got = *p;
    if (got != 0) { fail_id = 1; return 1; }
    p += 3;
    got1 = *p;
    if (got1 != 9) { fail_id = 2; return 1; }
    q = p + 2;
    got2 = *q;
    if (got2 != 15) { fail_id = 3; return 1; }
    got3 = q - ga;
    if (got3 != 5) { fail_id = 4; return 1; }
    *(ga + 6) = 77;
    got4 = ga[6];
    if (got4 != 77) { fail_id = 5; return 1; }
    return 0;
}
