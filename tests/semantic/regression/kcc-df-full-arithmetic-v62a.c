/* Canonical double arithmetic must use both words of each operand.
 * All expected results are exactly representable, so this also tests
 * KI10/KS10 hardware paths without choosing a halfway rounding policy. */
typedef unsigned long W;
typedef union { double d; W w[2]; } D;
static volatile D x, y, z;
static volatile W sentinel = 0765432101234UL;
volatile unsigned fail_id;

static double calc(int op, double a, double b, W live)
{
    double r;
    switch (op) {
    case 0: r = a+b; break;
    case 1: r = a-b; break;
    case 2: r = a*b; break;
    default: r = a/b; break;
    }
    if (live != sentinel) return 0.0;
    return r;
}
static int check(int op, W h, W l)
{
    z.d=calc(op,x.d,y.d,sentinel);
    return z.w[0] == h && (z.w[1]&0377777777777UL) == l;
}
int main(void)
{
    /* 1 + 2^-60 and 1, with exact cancellation. */
    x.w[0]=0201400000000UL; x.w[1]=2;
    y.w[0]=0201400000000UL; y.w[1]=0;
    fail_id=1;
    if (!check(0,0202400000000UL,1)) return 1;
    fail_id=2;
    if (!check(1,0105400000000UL,0)) return 2;
    /* Multiply and divide by two, retaining the continuation. */
    x.w[1]=1;
    y.w[0]=0202400000000UL; y.w[1]=0;
    fail_id=3;
    if (!check(2,0202400000000UL,1)) return 3;
    fail_id=4;
    if (!check(3,0200400000000UL,1)) return 4;
    /* The low word of the RIGHT operand is equally significant. */
    x.w[0]=0202400000000UL; x.w[1]=0;
    y.w[0]=0201400000000UL; y.w[1]=1;
    fail_id=5;
    if (!check(2,0202400000000UL,1)) return 5;
    /* Exact addition below the next exponent boundary. */
    x.w[0]=0201400000000UL; x.w[1]=3;
    y.w[0]=0104400000000UL; y.w[1]=0;
    fail_id=6;
    if (!check(0,0201400000000UL,4)) return 6;
    /* Compound assignments and live address across the private call. */
    fail_id=7; x.d += y.d;
    if (x.w[0]!=0201400000000UL || x.w[1]!=4) return 7;
    y.w[0]=0202400000000UL; y.w[1]=0;
    x.d *= y.d;
    fail_id=8;
    if (x.w[0]!=0202400000000UL || x.w[1]!=4) return 8;
    fail_id=0;
    return 0;
}
