volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int add_at(cp, k)
char *cp;
int k;
{
    int old;
    old = *cp;
    *cp = (char)(old + k);
    return old;
}

static int read_mix(cp, a, b, c, d, e)
char *cp;
int a;
int b;
int c;
int d;
int e;
{
    return *cp + a + b + c + d + e;
}

static int sum_chars(cp, n)
char *cp;
int n;
{
    int i;
    int s;
    s = 0;
    for (i = 0; i < n; ++i)
        s += cp[i];
    return s;
}

int main()
{
    char la[9];
    char *p;
    int i;
    fail_id = 0;
    for (i = 0; i < 9; ++i)
        la[i] = (char)(i + 1);
    p = &la[2];
    got = add_at(p++, 10);
    if (got != 3) { fail_id = 1; return 1; }
    got1 = add_at(++p, 20);
    if (got1 != 5) { fail_id = 2; return 1; }
    got2 = read_mix(p--, 1, 2, 3, 4, 5);
    if (got2 != 40) { fail_id = 3; return 1; }
    got3 = add_at(--p, 30);
    if (got3 != 13) { fail_id = 4; return 1; }
    got4 = (int)(p - la);
    if (got4 != 2) { fail_id = 5; return 1; }
    got5 = sum_chars(la, 9);
    if (got5 != 105) { fail_id = 6; return 1; }
    return 0;
}
