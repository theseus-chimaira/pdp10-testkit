volatile int __test_exit;
volatile int fail_id;
volatile int got;
char a[6];
int main()
{
    char *p;
    fail_id = 0;
    a[0] = 1;
    a[1] = 2;
    a[2] = 3;
    a[3] = 4;
    p = &a[4];
    p--;
    --p;
    got = *p;
    if (got != 3) { fail_id = 1; return 1; }
    return 0;
}
