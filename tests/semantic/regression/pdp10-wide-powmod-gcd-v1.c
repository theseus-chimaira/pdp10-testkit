/* Source-faithful arithmetic core of deferred 920501-2.c.
 * Exercises full 71-bit unsigned operators of gcd_ll/powmod_ll with
 * separately checked host-integer results, but not the long Pollard
 * factor-search loop or its production runtime helper installation.
 */
extern void abort(void);
volatile unsigned int fail_id;
static volatile unsigned long long a_v1;
static volatile unsigned long long b_v1;

static unsigned long
gcd_v1(unsigned long long x, unsigned long long y)
{
    for (;;) {
        if (y == 0ULL)
            return (unsigned long)x;
        x = x % y;
        if (x == 0ULL)
            return (unsigned long)y;
        y = y % x;
    }
}

static unsigned long long
powmod_v1(unsigned long long b, unsigned e, unsigned long long m)
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

int
main(void)
{
    a_v1 = 123456ULL;
    b_v1 = 7890ULL;
    if (gcd_v1(a_v1, b_v1) != 6UL) {
        fail_id = 1;
        abort();
    }
    a_v1 = 3ULL;
    if (powmod_v1(a_v1, 27U, 134217727ULL) != 17325482ULL) {
        fail_id = 2;
        abort();
    }
    a_v1 = 5ULL;
    if (powmod_v1(a_v1, 7U, 97ULL) != 40ULL) {
        fail_id = 3;
        abort();
    }
    return 0;
}
