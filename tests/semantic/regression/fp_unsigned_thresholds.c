volatile int __test_exit;
volatile int fail_id;
volatile unsigned int got;
volatile unsigned int got1;
volatile unsigned int got2;
volatile int small;

static unsigned int fbits(u)
unsigned int u;
{
    float f;
    unsigned int *p;
    f = u;
    p = (unsigned int *)&f;
    return *p;
}

static int roundtrip_small(u)
unsigned int u;
{
    float f;
    f = u;
    return (int)f;
}

int main()
{
    small = roundtrip_small(0777777U);
    if (small != 0777777) { fail_id = 1; return 1; }
    got = fbits(01000000000U);
    if (got == 0) { fail_id = 2; return 1; }
    got1 = fbits(0400000000000U);
    if (got1 != 0244400000000U) { fail_id = 3; return 1; }
    got2 = fbits(0400000000001U);
    if (got2 != 0244400000000U) { fail_id = 4; return 1; }
    return 0;
}
