/* Complete 920501-2.c Pollard factor-search semantic companion.
 * The original uses powmod, unsigned 71-bit arithmetic and 36-bit
 * gcd/factor output. Only the hosted exit() dependency is removed.
 * The real target modulo helper must be linked, never replaced here.
 * Python unlimited-integer reference with modulo-2**71 multiplication
 * confirms factors 7, 73, 262657 at iterations 1, 4, 277.
 */

volatile unsigned int fail_id;
extern void abort(void);

static unsigned long factab_v1[10];

static unsigned long
gcd_ll_v1(unsigned long long x, unsigned long long y)
{
    for (;;) {
        if (y == 0ULL)
            return (unsigned long)x;
        x %= y;
        if (x == 0ULL)
            return (unsigned long)y;
        y %= x;
    }
}

static unsigned long long
powmod_ll_v1(unsigned long long b, unsigned e, unsigned long long m)
{
    unsigned t;
    unsigned long long power;
    int i;

    if (e == 0U)
        return 1ULL;
    t = e;
    for (i = 0; t != 0U; i++)
        t >>= 1;
    power = b;
    i -= 2;
    for (; i >= 0; i--) {
        power = power * power % m;
        if ((1U << i) & e)
            power = power * b % m;
    }
    return power;
}

static void
facts_v1(unsigned long long t, int a_int, int x0, unsigned p)
{
    unsigned long *xp = factab_v1;
    unsigned long long x, y;
    unsigned long q = 1UL;
    unsigned long long a = a_int;
    int i;
    unsigned long d;
    int j = 1;
    unsigned long tmp;
    int jj = 0;

    x = x0;
    y = x0;
    for (i = 1; i < 10000; i++) {
        x = powmod_ll_v1(x, p, t) + a;
        y = powmod_ll_v1(y, p, t) + a;
        y = powmod_ll_v1(y, p, t) + a;
        if (x > y)
            tmp = x - y;
        else
            tmp = y - x;
        q = (unsigned long long)q * tmp % t;
        if (i == j) {
            jj += 1;
            j += jj;
            d = gcd_ll_v1(q, t);
            if (d != 1UL) {
                *xp++ = d;
                t /= d;
                if (t == 1ULL)
                    return;
            }
        }
    }
    fail_id = 1;
    abort();
}

int
main(void)
{
    facts_v1((1ULL << 27) - 1ULL, -1, 3, 27U);
    if (factab_v1[0] != 7UL) {
        fail_id = 2;
        abort();
    }
    if (factab_v1[1] != 73UL) {
        fail_id = 3;
        abort();
    }
    if (factab_v1[2] != 262657UL) {
        fail_id = 4;
        abort();
    }
    return 0;
}
