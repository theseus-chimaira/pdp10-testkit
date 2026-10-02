/* Base/pdp10 policy must not emit KI-only double FP instructions. */
volatile double da;
volatile double db;
volatile double dc;
static double f(a, b)
double a;
double b;
{
    return ((a + b) * (a - b)) / 2.0;
}
int main()
{
    da = 9.0;
    db = 4.0;
    dc = f(da, db);
    return dc > 0.0 ? 0 : 1;
}
