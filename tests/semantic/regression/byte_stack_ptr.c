volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int main()
{
    char a[10];
    char *p;
    fail_id = 0;
    a[0] = 1;
    a[1] = 2;
    a[2] = 3;
    a[3] = 4;
    p = a;
    got = *p;
    if (got != 1) { fail_id = 1; return 1; }
    ++p;
    got1 = *p;
    if (got1 != 2) { fail_id = 2; return 1; }
    p += 2;
    got2 = *p;
    if (got2 != 4) { fail_id = 3; return 1; }
    --p;
    *p = 9;
    got3 = a[2];
    if (got3 != 9) { fail_id = 4; return 1; }
    got4 = a[0] + a[1] + a[2] + a[3];
    if (got4 != 16) { fail_id = 5; return 1; }
    return 0;
}
