volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int tail_sum(cp)
char *cp;
{
    int i;
    int s;
    s = 0;
    for (i = 0; i < 9; ++i)
        s += cp[i];
    return s;
}

int main()
{
    char buf[18];
    char *p;
    int i;
    fail_id = 0;
    for (i = 0; i < 18; ++i)
        buf[i] = (char)(18 + i);
    p = buf + 14;
    got = *p;
    if (got != 32) { fail_id = 1; return 1; }
    *p = (char)(*p + 35);
    got1 = tail_sum(buf + 9);
    if (got1 != 314) { fail_id = 2; return 1; }
    return 0;
}
