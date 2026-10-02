volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;

static float fa[3];
static double da[2];

static int readf(p, i)
float *p;
int i;
{
    return (int)p[i];
}

static int readd(p, i)
double *p;
int i;
{
    return (int)p[i];
}

int main()
{
    fa[0] = 1.25f;
    fa[1] = 4.75f;
    fa[2] = fa[1] - fa[0];
    got = readf(fa, 2);
    if (got != 3) { fail_id = 1; return 1; }
    da[0] = -2.0;
    da[1] = 5.0;
    got1 = readd(da, 0);
    if (got1 != -2) { fail_id = 2; return 1; }
    got2 = readd(da, 1);
    if (got2 != 5) { fail_id = 3; return 1; }
    return 0;
}
