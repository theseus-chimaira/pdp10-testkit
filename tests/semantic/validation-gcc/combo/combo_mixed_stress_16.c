volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct box {
    char c[8];
    short s;
    int x;
};

static int touch(cp, k)
char *cp;
int k;
{
    int v;
    v = *cp;
    *cp = (char)(v + k);
    return v + k;
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
    struct box bx;
    char *p;
    int i;
    fail_id = 0;
    for (i = 0; i < 8; ++i)
        bx.c[i] = (char)(18 + i);
    bx.s = (short)(49);
    bx.x = 882;
    p = bx.c;
    got = touch(++p, bx.s);
    if (got != 68) { fail_id = 1; return 1; }
    got1 = touch(p + 2, bx.s + 1);
    if (got1 != 71) { fail_id = 2; return 1; }
    got2 = sum(bx.c, 5);
    if (got2 != 199) { fail_id = 3; return 1; }
    got4 = (got + got1 + got2) % 5;
    if (got4 == 0)
        got3 = got2 + got;
    else if (got4 == 1)
        got3 = got2 + got1;
    else if (got4 == 2)
        got3 = got2 + got + got1;
    else if (got4 == 3)
        got3 = got2 - got;
    else
        got3 = got2 - got1;
    if (got3 != 131) { fail_id = 4; return 1; }
    return 0;
}
