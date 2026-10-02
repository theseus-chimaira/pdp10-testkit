volatile int __test_exit;
volatile int fail_id;
volatile int q1;
volatile int q2;
volatile int q3;
volatile int q4;
volatile int r4;
volatile int q5;
volatile int r5;
#define KCC_INT_MIN (-0400000000000)
#define KCC_NEG_HALF (-0200000000000)
#define KCC_POS_HALF (0200000000000)
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
    a = KCC_INT_MIN;
    fail_id = 0;
    q1 = divi(a, 1);
    if (q1 != a) { fail_id = 1; return 1; }
    q2 = divi(a, 2);
    if (q2 != KCC_NEG_HALF) { fail_id = 2; return 1; }
    q3 = divi(a, -2);
    if (q3 != KCC_POS_HALF) { fail_id = 3; return 1; }
    q4 = divi(a, 3);
    r4 = modi(a, 3);
    if (q4 * 3 + r4 != a) { fail_id = 4; return 1; }
    if (r4 > 0 || r4 <= -3) { fail_id = 5; return 1; }
    q5 = divi(a, -3);
    r5 = modi(a, -3);
    if (q5 * -3 + r5 != a) { fail_id = 6; return 1; }
    if (r5 > 0 || r5 <= -3) { fail_id = 7; return 1; }
    return 0;
}
