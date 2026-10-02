volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
double dadd(a,b) double a; double b; { return a + b; }
double dscale(a,b,c) double a; double b; int c; { return (a * b) + c; }
float fmul(a,b) float a; float b; { return a * b; }
int main()
{
    double d;
    float f;
    fail_id = 0;
    d = dadd(2.0, 3.5);
    got = (int)d;
    if (got != 5) { fail_id = 1; return 1; }
    d = dscale(2.0, 4.0, 3);
    got1 = (int)d;
    if (got1 != 11) { fail_id = 2; return 1; }
    f = fmul(2.0f, 3.0f);
    got2 = (int)f;
    if (got2 != 6) { fail_id = 3; return 1; }
    got3 = (int)dadd(f, 4.0);
    if (got3 != 10) { fail_id = 4; return 1; }
    return 0;
}
