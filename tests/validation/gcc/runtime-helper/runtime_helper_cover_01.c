volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int bump(cp, k)
char *cp;
int k;
{
    int old;
    old = *cp;
    *cp = (char)(old + k);
    return old;
}

static int sum(cp, n)
char *cp;
int n;
{
    int i;
    int r;
    r = 0;
    for (i = 0; i < n; ++i)
        r += cp[i];
    return r;
}

int main()
{
    char buf[12];
    char *p;
    int i;
    fail_id = 0;
    for (i = 0; i < 12; ++i)
        buf[i] = (char)(5 + i);
    p = buf + 9;
    p -= 2;
    got = bump(p, 10);
    if (got != 12) { fail_id = 1; return 1; }
    got1 = (int)(p - buf);
    if (got1 != 7) { fail_id = 2; return 1; }
    got2 = sum(buf, 12);
    if (got2 != 136) { fail_id = 3; return 1; }
    return 0;
}
