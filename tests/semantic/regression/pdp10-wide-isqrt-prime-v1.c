/* Bounded semantic companion to deferred GCC 920501-6.c.
 * Independent checks of decimal parsing, 71-bit integer square root,
 * and original odd-trial-divisor prime listing on a small input range.
 * The original billion-scale prime search remains deferred because
 * it exhausts the current simulator step budget.
 */
extern void abort(void);
volatile unsigned int fail_id;
static volatile unsigned long long source_v1;

static unsigned long long
str2llu_v1(const char *s)
{
    unsigned long long acc;
    int d;
    acc = (unsigned long long)(*s++ - '0');
    for (;;) {
        d = *s++;
        if (d == '\0')
            break;
        acc = acc * 10ULL + (unsigned)(d - '0');
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
    unsigned long s;
    unsigned long d;
    unsigned long long *xp = tab;
    for (p = p0; p <= p1; p += 2ULL) {
        s = sqrtllu_v1(p);
        for (d = 3UL; d <= s; d += 2UL) {
            if (p % d == 0ULL)
                goto not_prime;
        }
        *xp++ = p;
not_prime: ;
    }
    *xp = 0ULL;
    return (int)(xp - tab);
}

static void
check_sqrt_v1(unsigned long long value, unsigned long expected,
              unsigned int id)
{
    source_v1 = value;
    fail_id = id;
    if (sqrtllu_v1(source_v1) != expected)
        abort();
    fail_id = 0;
}

int
main(void)
{
    unsigned long long primes_v1[10];
    static const unsigned long long expect_v1[8] = {
        11ULL, 13ULL, 17ULL, 19ULL, 23ULL, 29ULL, 31ULL, 0ULL
    };
    int i;
    check_sqrt_v1(0ULL, 0UL, 2);
    check_sqrt_v1(1ULL, 1UL, 3);
    check_sqrt_v1(2ULL, 1UL, 4);
    check_sqrt_v1(3ULL, 1UL, 5);
    check_sqrt_v1(4ULL, 2UL, 6);
    check_sqrt_v1(15ULL, 3UL, 7);
    check_sqrt_v1(16ULL, 4UL, 8);
    check_sqrt_v1(17ULL, 4UL, 9);
    check_sqrt_v1(1234111111ULL, 35129UL, 10);
    check_sqrt_v1(1234111127ULL, 35129UL, 11);
    check_sqrt_v1(0x123456789ABCDULL, 17895697UL, 12);
    if (str2llu_v1("1234111111") != 1234111111ULL ||
        str2llu_v1("1234111127") != 1234111127ULL) {
        fail_id = 1;
        abort();
    }
    if (plist_v1(11ULL, 31ULL, primes_v1) != 7) {
        fail_id = 13;
        abort();
    }
    for (i = 0; i < 8; i++) {
        if (primes_v1[i] != expect_v1[i]) {
            fail_id = 14U + (unsigned)i;
            abort();
        }
    }
    return 0;
}
