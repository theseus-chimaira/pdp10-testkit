volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

#if CPU_PDP6 || CPU_KA || CPU_KI || CPU_KS || CPU_KL0 || CPU_KLX || defined(__PDP10_BASE__) || defined(__PDP10_PDP10__) || defined(__PDP10_166__) || defined(__PDP10_KA10__) || defined(__PDP10_KI10__)
#define TOP_UNSIGNED 0400000000000U
#define TOP_SHIFT 35
#define TOP_RESULT 0400000000000U
#else
#define TOP_UNSIGNED 020000000000U
#define TOP_SHIFT 31
#define TOP_RESULT 020000000000U
#endif

static int lsh(a, n)
unsigned int a;
int n;
{
    return (int)(a << n);
}

static int rsh(a, n)
unsigned int a;
int n;
{
    return (int)(a >> n);
}

static int ash(a, n)
int a;
int n;
{
    return a >> n;
}

int main()
{
    fail_id = 0;
    got = lsh(1U, 0) + lsh(1U, 1) + lsh(1U, 17);
    if (got != 131075) { fail_id = 1; return 1; }
    got1 = rsh(TOP_UNSIGNED, TOP_SHIFT);
    if (got1 != 1) { fail_id = 2; return 1; }
    got2 = ash(-8, 1);
    if (got2 != -4) { fail_id = 3; return 1; }
    got3 = ash((int)TOP_UNSIGNED, TOP_SHIFT);
    if (got3 != -1) { fail_id = 4; return 1; }
    got4 = lsh(3U, TOP_SHIFT);
    if (got4 != (int)TOP_RESULT) { fail_id = 5; return 1; }
    return 0;
}
