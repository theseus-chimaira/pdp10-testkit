volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct holder {
    char c[8];
    int x;
};

static struct holder gh;

static int calc(p, q, k)
char *p;
char *q;
int k;
{
    return (p - q) + k + *p;
}

int main()
{
    int i;
    char *p;
    char *q;
    fail_id = 0;
    for (i = 0; i < 8; ++i)
        gh.c[i] = (char)(20 + i);
    p = &gh.c[6];
    q = &gh.c[1];
    got = calc(p, q, 3);
    if (got != 34) { fail_id = 1; return 1; }
    got1 = (&gh.c[7] - &gh.c[2]) + gh.c[0];
    if (got1 != 25) { fail_id = 2; return 1; }
    gh.c[3] = (char)(calc(&gh.c[4], &gh.c[2], 5));
    got2 = gh.c[3];
    if (got2 != 31) { fail_id = 3; return 1; }
    return 0;
}
