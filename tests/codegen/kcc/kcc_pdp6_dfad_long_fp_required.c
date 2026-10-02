/* codegen-require: FADL */
/* codegen-forbid: DFAD */
volatile double da;
volatile double db;
volatile double dc;
static double f(a, b)
double a;
double b;
{
    return a + b;
}
int main()
{
    da = 9.0;
    db = 4.0;
    dc = f(da, db);
    return dc > 0.0 ? 0 : 1;
}
