volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

double gd[4] = { 1.5, -2.0, 3.25, 4.75 };
float gf[4] = { 2.0f, -1.5f, 6.5f, 0.5f };

static int fold_fp(dp, fp, n)
double *dp;
float *fp;
int n;
{
    int i;
    double dsum;
    float fsum;
    dsum = 0.0;
    fsum = 0.0f;
    for (i = 0; i < n; ++i) {
        dsum = dsum + dp[i];
        fsum = fsum + fp[i];
    }
    return (int)(dsum * 2.0) + (int)(fsum * 2.0f);
}

int main()
{
    double ld[2];
    float lf[2];
    fail_id = 0;
    got = fold_fp(gd, gf, 4);
    if (got != 30) { fail_id = 1; return 1; }
    ld[0] = gd[2] / 2.0;
    ld[1] = gd[3] - gd[0];
    lf[0] = gf[2] - 1.5f;
    lf[1] = gf[0] + gf[3];
    got1 = fold_fp(ld, lf, 2);
    if (got1 != 24) { fail_id = 2; return 1; }
    got2 = (int)(ld[0] * 4.0);
    if (got2 != 6) { fail_id = 3; return 1; }
    got3 = (int)(lf[0] + lf[1]);
    if (got3 != 7) { fail_id = 4; return 1; }
    return 0;
}
