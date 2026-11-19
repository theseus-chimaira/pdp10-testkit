/* Exact primality interval from deferred original GCC 920501-6.c.
 * Preserve str2llu, integer Newton sqrt, odd trial divisors, and
 * original three prime expectations. Only hosted stdio/exit removed.
 * Python independent trial division confirms the expected interval.
 * The full iteration may exceed the PDP-6 guest instruction budget.
 */

extern void abort(void);
volatile unsigned int fail_id;
static unsigned long long prime_results_v1[10];

static unsigned long long
str2llu_v1(const char *str)
{
    unsigned long long acc;
    int d;
    acc = (unsigned long long)(*str++ - '0');
    for (;;) {
        d = *str++;
        if (d == '\0')
            break;
        d -= '0';
        acc = acc * 10ULL + d;
    }
    return acc;
}

static unsigned long
sqrtllu_v1(unsigned long long t)
{
    unsigned long long s;
    unsigned long long b;

    for (b = 0ULL, s = t; b++, (s >>= 1) != 0ULL; )
        ;
    s = 1ULL << (b >> 1);
    if (b & 1ULL)
        s += s >> 1;
    do {
        b = t / s;
        s = (s + b) >> 1;
    } while (b < s);
    return (unsigned long)s;
}

static int
plist_v1(unsigned long long p0, unsigned long long p1,
         unsigned long long *tab)
{
    unsigned long long p;
    unsigned long d;
    unsigned long s;
    unsigned long long *xp = tab;

    for (p = p0; p <= p1; p += 2ULL) {
        s = sqrtllu_v1(p);
        for (d = 3UL; d <= s; d += 2UL) {
            if (p % d == 0ULL)
                goto not_prime;
        }
        *xp++ = p;
not_prime:
        ;
    }
    *xp = 0ULL;
    return (int)(xp - tab);
}

int
main(void)
{
    int count;

    count = plist_v1(str2llu_v1("1234111111"),
                     str2llu_v1("1234111127"), prime_results_v1);
    if (count != 3) {
        fail_id = 1;
        abort();
    }
    if (prime_results_v1[0] != 1234111117ULL) {
        fail_id = 2;
        abort();
    }
    if (prime_results_v1[1] != 1234111121ULL) {
        fail_id = 3;
        abort();
    }
    if (prime_results_v1[2] != 1234111127ULL ||
        prime_results_v1[3] != 0ULL) {
        fail_id = 4;
        abort();
    }
    return 0;
}
