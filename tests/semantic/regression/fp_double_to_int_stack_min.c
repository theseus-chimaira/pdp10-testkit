volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;

double dneg = -7.0;
double dtwo = 2.0;

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
    return 0;
}
