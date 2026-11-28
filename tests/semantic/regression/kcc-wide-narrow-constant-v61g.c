/* The arithmetic low limb carries 35 independent bits. Conversion to a
** one-word integer must reconstruct the low word before truncation.
** Static and runtime conversion must agree for both high-limb parities.
*/
static volatile unsigned long constants[] = {
    (unsigned long)34359738368ULL,
    (unsigned long)68719476735ULL,
    (unsigned long)68719476736ULL,
    (unsigned long)-34359738368LL,
    (unsigned long)-68719476735LL,
    (unsigned long)-68719476736LL
};
static volatile long long values[] = {
    34359738368LL, 68719476735LL, 68719476736LL,
    -34359738368LL, -68719476735LL, -68719476736LL
};
static const unsigned long expected[] = {
    0400000000000UL, 0777777777777UL, 0UL,
    0400000000000UL, 1UL, 0UL
};
static volatile long signed_min = (long)34359738368ULL;
static volatile short small = (short)34359738369ULL;
volatile unsigned fail_id;

int main(void)
{
    int i;
    for (i = 0; i < 6; ++i) {
        fail_id = 1 + i;
        if (constants[i] != expected[i])
            return 1;
        fail_id = 7 + i;
        if ((unsigned long)values[i] != expected[i])
            return 2;
    }
    fail_id = 13;
    if (signed_min != -34359738368L || small != 1)
        return 3;
    fail_id = 0;
    return 0;
}
