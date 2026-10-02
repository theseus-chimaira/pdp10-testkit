volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int read3(cp)
char *cp;
{
    return cp[0] + cp[1] + cp[2];
}

static int pass_call(cp, add)
char *cp;
int add;
{
    cp[1] = (char)(cp[1] + add);
    return read3(cp);
}

int main()
{
    char buf[10];
    char *p;
    int i;
    fail_id = 0;
    for (i = 0; i < 10; ++i)
        buf[i] = (char)(12 + i);
    p = buf + 1;
    got = read3(++p);
    if (got != 45) { fail_id = 1; return 1; }
    p += 3;
    got1 = pass_call(p, 31);
    if (got1 != 85) { fail_id = 2; return 1; }
    got2 = (int)(p - buf);
    if (got2 != 5) { fail_id = 3; return 1; }
    got3 = got * 2 + got1;
    if (got3 != 175) { fail_id = 4; return 1; }
    return 0;
}
