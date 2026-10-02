volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
int main()
{
    unsigned char a[8];
    int i;
    fail_id = 0;
    for (i = 0; i < 8; ++i) a[i] = (unsigned char)(30 + i);
    got = a[3];
    got1 = a[4];
    got2 = a[5];
    got3 = a[6] + a[7];
    if (got != 33) { fail_id = 1; return 1; }
    if (got1 != 34) { fail_id = 2; return 1; }
    if (got2 != 35) { fail_id = 3; return 1; }
    if (got3 != 73) { fail_id = 4; return 1; }
    return 0;
}
