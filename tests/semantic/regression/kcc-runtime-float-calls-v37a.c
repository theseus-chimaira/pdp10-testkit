/* A floating left constant must not discard a nonconstant RHS.
 * Compiler-generated conversions must preserve live incoming pointers. */
static volatile double source = 3.0;
static double plus(double x) { return 1.0 + x; }
static double minus(double x) { return 1.0 - x; }
static int convert(float *p, int x) { return (int)*p + x + (int)*p; }
static float assign(float *p, int n) { *p += (float)n; return *p; }
int main(void)
{
    float f = 3.5f;
    if (plus(source) != 4.0 || minus(source) != -2.0) return 1;
    if (convert(&f,5)!=11) return 2;
    if (assign(&f,2)!=5.5f || f!=5.5f) return 3;
    return 0;
}
