/* codegen-require-symbol: $KDFAD $KDFSB $KDFMP $KDFDV */
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
