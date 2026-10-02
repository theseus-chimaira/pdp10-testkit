volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int setf(p,x) float *p; float x; { *p = x + 1.0f; return (int)*p; }
int setd(p,x) double *p; double x; { *p = x + 2.0; return (int)*p; }
int sumfd(fp,dp) float *fp; double *dp; { return (int)*fp + (int)*dp; }
int main()
{
    float f[2];
    double d[2];
    fail_id = 0;
    got = setf(&f[0], 2.0f);
    if (got != 3) { fail_id = 1; return 1; }
    got1 = setd(&d[0], 3.0);
    if (got1 != 5) { fail_id = 2; return 1; }
    f[1] = f[0] * 2.0f;
    d[1] = d[0] + 4.0;
    got2 = sumfd(&f[1], &d[1]);
    if (got2 != 15) { fail_id = 3; return 1; }
    return 0;
}
