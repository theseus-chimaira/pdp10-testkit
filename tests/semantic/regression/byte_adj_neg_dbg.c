volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int main()
{
    char a[4];
    char *p;
    fail_id = 0;
    a[0] = 1; a[1] = 2; a[2] = 3; a[3] = 4;
    p = a;
    got = (int)p;
    ++p;
    got1 = (int)p;
    p += 2;
    got2 = (int)p;
    --p;
    got3 = (int)p;
    *p = 9;
    got4 = a[2];
    if (got4 != 9) { fail_id = 1; return 1; }
    return 0;
}
