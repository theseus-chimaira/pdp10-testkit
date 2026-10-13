/* Original KCC source and codegen assertions. */
long highmul_add(x, y, q)
long x;
long y;
long q;
{
    long long p;

    p = (long long)x * (long long)y;
    return (long)(p >> 35) + q;
}

long highmul_assign(x, y, q)
long x;
long y;
long q;
{
    long long p;

    p = (long long)x * (long long)y;
    x = (long)(p >> 35);
    return x + q;
}
