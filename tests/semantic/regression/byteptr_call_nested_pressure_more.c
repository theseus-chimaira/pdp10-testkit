volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct holder {
    char a[6];
    unsigned char b[6];
    int pad;
};

struct holder gh;
int sink;

static int poke(cp, a, b, c, d, e)
char *cp;
int a;
int b;
int c;
int d;
int e;
{
    int old;
    old = *cp;
    *cp = (char)(old + a + b - c + d - e);
    sink += *cp;
    return old + *cp;
}

static int upoke(cp, k)
unsigned char *cp;
int k;
{
    int old;
    old = *cp;
    *cp = (unsigned char)(old + k);
    sink += *cp;
    return *cp;
}

static int call2(p, q, k)
char *p;
char *q;
int k;
{
    int s;
    s = poke(p++, k, 1, 2, 3, 4);
    s += poke(++q, k + 1, 2, 3, 4, 5);
    s += poke(p, k + 2, 3, 4, 5, 6);
    s += *q--;
    s += *q;
    return s;
}

static int sum_c(cp, n)
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

static int sum_uc(cp, n)
unsigned char *cp;
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
    char la[6];
    unsigned char *uq;
    int i;
    fail_id = 0;
    sink = 0;
    for (i = 0; i < 6; ++i) {
        la[i] = (char)(10 + i);
        gh.a[i] = (char)(i + 1);
        gh.b[i] = (unsigned char)(20 + i);
    }
    gh.pad = 12345;
    got = call2(&la[1], &la[2], 5);
    if (got != 118) { fail_id = 1; return 1; }
    got1 = sum_c(la, 6);
    if (got1 != 87) { fail_id = 2; return 1; }
    got2 = call2(&gh.a[0], &gh.a[1], 2);
    if (got2 != 23) { fail_id = 3; return 1; }
    got3 = sum_c(gh.a, 6);
    if (got3 != 24) { fail_id = 4; return 1; }
    uq = &gh.b[1];
    got4 = upoke(uq++, 7) + upoke(++uq, 8) + *uq--;
    if (got4 != 90) { fail_id = 5; return 1; }
    if ((int)(uq - gh.b) != 2) { fail_id = 6; return 1; }
    got5 = sum_uc(gh.b, 6);
    if (got5 != 150) { fail_id = 7; return 1; }
    if (gh.pad != 12345) { fail_id = 8; return 1; }
    return 0;
}
