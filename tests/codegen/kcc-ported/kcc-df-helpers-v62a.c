/* codegen-require-symbol: __kcc_dfadd_rt_v62a __kcc_dfsub_rt_v62a __kcc_dfmul_rt_v62a __kcc_dfdiv_rt_v62a */
/* codegen-forbid: FADL FSBL FMPL FDVL DFAD DFSB DFMP DFDV */
volatile double da;
volatile double db;
volatile double dc;
static double f(a, b)
double a;
double b;
{
    return (a + b) + (a - b) + (a * b) + (a / b);
}
int main()
{
    da = 9.0;
    db = 3.0;
    dc = f(da, db);
    return dc > 0.0 ? 0 : 1;
}
