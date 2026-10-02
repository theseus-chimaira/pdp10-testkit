volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
char a[9];
int main()
{
    char *p;
    fail_id = 0;
    p = &a[2];
    got = (int)(p - a);
    if (got != 2) { fail_id = 1; return 1; }
    p++;
    ++p;
    p--;
    --p;
    got1 = (int)(p - a);
    if (got1 != 2) { fail_id = 2; return 1; }
    return 0;
}
