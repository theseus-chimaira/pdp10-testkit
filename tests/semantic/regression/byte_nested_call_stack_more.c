volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;

char gbuf[12];

static int inner(p, q, n)
char *p;
char *q;
int n;
{
    char tmp[4];
    tmp[0] = (char)(n + 1);
    tmp[1] = (char)(n + 2);
    q[-1] = (char)(p[-2] + tmp[0]);
    p[1] = (char)(q[-1] + tmp[1]);
    return p[-2] + p[-1] + p[0] + p[1] + q[-1] + q[0];
}

static int outer(base, n)
char *base;
int n;
{
    char local[8];
    int i;
    int r;
    for (i = 0; i < 8; ++i) local[i] = (char)(20 + i);
    r = inner(base + n, &local[4], n);
    return r + local[3] + local[4];
}

int main()
{
    int i;
    fail_id = 0;
    for (i = 0; i < 12; ++i) gbuf[i] = (char)(i + 1);
    got = outer(gbuf, 5);
    if (got != 100) { fail_id = 1; return 1; }
    got1 = gbuf[6];
    if (got1 != 17) { fail_id = 2; return 1; }
    got2 = outer(gbuf + 2, 3);
    if (got2 != 92) { fail_id = 3; return 1; }
    got3 = gbuf[6];
    if (got3 != 13) { fail_id = 4; return 1; }
    return 0;
}
