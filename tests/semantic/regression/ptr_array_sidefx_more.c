volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

static int walk(p, n)
int *p;
int n;
{
    int i;
    int sum;
    sum = 0;
    for (i = 0; i < n; ++i) {
        sum += *p;
        *p = *p + i + 1;
        p = p + 2;
    }
    return sum;
}

static int stride_mix(base, idx)
int *base;
int idx;
{
    int *p;
    p = base + idx;
    p[-1] = p[-1] + p[1];
    p[2] = p[2] - p[-2];
    return p[-1] + p[0] + p[1] + p[2];
}

int main()
{
    int a[8];
    int i;
    fail_id = 0;
    for (i = 0; i < 8; ++i)
        a[i] = i + 1;
    got = walk(a, 4);
    if (got != 16) { fail_id = 1; return 1; }
    got1 = a[0] + a[2] + a[4] + a[6];
    if (got1 != 26) { fail_id = 2; return 1; }
    got2 = stride_mix(a, 3);
    if (got2 != 29) { fail_id = 3; return 1; }
    got3 = a[2] + a[3] + a[4] + a[5];
    if (got3 != 29) { fail_id = 4; return 1; }
    return 0;
}
