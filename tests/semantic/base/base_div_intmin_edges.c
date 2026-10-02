volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

#if CPU_PDP6 || CPU_KA || CPU_KI || CPU_KS || CPU_KL0 || CPU_KLX || defined(__PDP10_BASE__) || defined(__PDP10_PDP10__) || defined(__PDP10_166__) || defined(__PDP10_KA10__) || defined(__PDP10_KI10__)
#define BASE_INT_MIN (-0400000000000)
#define BASE_DIV3_EXPECT (-11453246119)
#else
#define BASE_INT_MIN (-2147483647 - 1)
#define BASE_DIV3_EXPECT (-715827879)
#endif

static int divi(a, b)
int a;
int b;
{
    return a / b;
}

static int modi(a, b)
int a;
int b;
{
    return a % b;
}

int main()
{
    int a;
    fail_id = 0;
    a = BASE_INT_MIN;
    got = divi(a, 1);
    if (got != a) { fail_id = 1; return 1; }
    got1 = divi(a + 10, 3);
    if (got1 != BASE_DIV3_EXPECT) { fail_id = 2; return 1; }
    got2 = modi(a + 10, 3);
    if (got2 != -1) { fail_id = 3; return 1; }
    got3 = divi(-12345, 7);
    if (got3 != -1763) { fail_id = 4; return 1; }
    got4 = modi(-12345, 7);
    if (got4 != -4) { fail_id = 5; return 1; }
    return 0;
}
