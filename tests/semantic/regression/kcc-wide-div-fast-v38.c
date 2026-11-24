/* Exercise small hardware division and full-range fallback at the boundary. */
typedef unsigned long long U;
typedef long long S;
static volatile U a,b;
static volatile S c,d;
static U uq(U x,U y) { return x/y; }
static U ur(U x,U y) { return x%y; }
static S sq(S x,S y) { return x/y; }
static S sr(S x,S y) { return x%y; }
int main(void)
{
    a=34359738367ULL; b=37ULL;
    if (uq(a,b)!=928641577ULL || ur(a,b)!=18ULL) return 1;
    a=34359738368ULL; b=37ULL;
    if (uq(a,b)!=928641577ULL || ur(a,b)!=19ULL) return 2;
    a=34359738367ULL; b=34359738368ULL;
    if (uq(a,b)!=0ULL || ur(a,b)!=a) return 3;
    a=1234111117ULL; b=35129ULL;
    if (uq(a,b)!=35130ULL || ur(a,b)!=29347ULL) return 4;
    c=-123LL; d=7LL;
    if (sq(c,d)!=-17LL || sr(c,d)!=-4LL) return 5;
    c=123LL; d=-7LL;
    if (sq(c,d)!=-17LL || sr(c,d)!=4LL) return 6;
    c=-123LL; d=-7LL;
    if (sq(c,d)!=17LL || sr(c,d)!=-4LL) return 7;
    c=-34359738368LL; d=37LL;
    if (sq(c,d)!=-928641577LL || sr(c,d)!=-19LL) return 8;
    a=0; b=1;
    if (uq(a,b)!=0 || ur(a,b)!=0) return 9;
    return 0;
}
