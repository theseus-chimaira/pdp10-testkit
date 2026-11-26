/* Wide quotient/remainder under incoming ABI register pressure.
   Keep the first call after the arithmetic, as in upstream signext.c.
   The unsigned cases also exercise the top bit of the 71-bit value. */
typedef long long S;
typedef unsigned long long U;
static volatile S result;
static volatile U a, b;

static void save(S x) { result = x; }
static void quotient(int p, int q, int d)
{
    S x;
    x = (-((S)7 << 36) + p + q) / d;
    save(x);
}
static void remainder(int p, int q, int d)
{
    S x;
    x = (-((S)7 << 36) + p + q) % d;
    save(x);
}
static U uq(U x, U y) { return x / y; }
static U ur(U x, U y) { return x % y; }

int main(void)
{
    quotient(8, 1, 7);
    if (result != -((S)1 << 36) + 2) return 1;
    remainder(8, 1, 7);
    if (result != -5) return 2;
    a = ((U)1 << 70) + ((U)1 << 35) + 17;
    b = ((U)1 << 69) + 3;
    if (uq(a, b) != 2 || ur(a, b) != ((U)1 << 35) + 11)
        return 3;
    a = ((U)1 << 70) + 17;
    b = ((U)1 << 70) + 18;
    if (uq(a, b) != 0 || ur(a, b) != a) return 4;
    a = ((U)1 << 70) + 37;
    b = ((U)1 << 35) + 1;
    if (uq(a, b) != ((U)1 << 35) - 1 || ur(a, b) != 38)
        return 5;
    return 0;
}
