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
#define BASE_NEG_HALF (-0200000000000)
#define BASE_POS_HALF (0200000000000)
#define BASE_NEG_HALF_PLUS1 (-0177777777777)
#else
#define BASE_INT_MIN (-2147483647 - 1)
#define BASE_NEG_HALF (-1073741824)
#define BASE_POS_HALF (1073741824)
#define BASE_NEG_HALF_PLUS1 (-1073741823)
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
    got = divi(a, 2);
    if (got != BASE_NEG_HALF) { fail_id = 1; return 1; }
    got1 = divi(a, -2);
    if (got1 != BASE_POS_HALF) { fail_id = 2; return 1; }
    got2 = divi(a + 1, 2);
    if (got2 != BASE_NEG_HALF_PLUS1) { fail_id = 3; return 1; }
    got3 = modi(a + 1, 2);
    if (got3 != -1) { fail_id = 4; return 1; }
    got4 = divi(BASE_POS_HALF, -2);
    if (got4 != -0100000000000) { fail_id = 5; return 1; }
    got5 = modi(BASE_POS_HALF + 1, 2);
    if (got5 != 1) { fail_id = 6; return 1; }
    return 0;
}
