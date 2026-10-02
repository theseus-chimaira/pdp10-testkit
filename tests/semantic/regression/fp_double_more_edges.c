volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
double dneg = -7.0;
double dtwo = 2.0;
double dhalf = 0.5;
int main()
{
    double x;
    fail_id = 0;
    x = dneg / dtwo;
    got = (int)x;
    if (got != -3) { fail_id = 1; return 1; }
    x = 7.0 / dtwo;
    got1 = (int)x;
    if (got1 != 3) { fail_id = 2; return 1; }
    x = dhalf + dhalf + dhalf + dhalf;
    got2 = (int)x;
    if (got2 != 2) { fail_id = 3; return 1; }
    x = -3.0 * 3.0;
    got3 = (int)x;
    if (got3 != -9) { fail_id = 4; return 1; }
    return 0;
}
