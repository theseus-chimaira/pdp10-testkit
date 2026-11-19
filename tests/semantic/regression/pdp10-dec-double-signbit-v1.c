/* Nonvacuous DEC D-format signbit regression for 991228-1.c.
 * Two 36-bit words form the native double. Both high and continuation
 * words contain the sign bit in the DEC D-format representation.
 * This is architecture-specific; do not use host IEEE layout rules.
 */
extern void abort(void);
#define SIGN_V1 0400000000000UL
union double_words_v1 {
    double d;
    unsigned int words[2];
};
static volatile union double_words_v1 d_v1;
volatile unsigned int fail_id;

static void
check_v1(double d, int negative, unsigned int id)
{
    d_v1.d = d;
    if (sizeof(double) != 2U * sizeof(unsigned int)) {
        fail_id = id;
        abort();
    }
    if (((d_v1.words[0] & SIGN_V1) != 0UL) != negative) {
        fail_id = id + 1U;
        abort();
    }
    if (((d_v1.words[1] & SIGN_V1) != 0UL) != negative) {
        fail_id = id + 2U;
        abort();
    }
}

int
main(void)
{
    check_v1(-0.25, 1, 1U);
    check_v1(0.25, 0, 4U);
    check_v1(-1.0, 1, 7U);
    check_v1(1.0, 0, 10U);
    return 0;
}
