/* PDP-10 unsigned 36-bit division with compile-time constant divisors.
 *
 * Unlike the variable-divisor reducers, these calls exercise the backend's
 * constant-positive DIVI path, including the transfer of numerator bit 35
 * into the high AC of the 70-bit dividend pair.  Keep input volatile and
 * the division functions out of line so neither numerator nor divisor can
 * be constant-folded away at optimization levels O1, O2 and Os.
 *
 * All expected values are exact unsigned 36-bit integer results.  C89.
 */

extern void abort(void);

#if defined(__GNUC__)
#define NOINLINE __attribute__((noinline))
#else
#define NOINLINE
#endif

#define U36_SIGN 0400000000000UL
#define U36_MAX  0777777777777UL

static volatile unsigned int numerator;
volatile unsigned int constant_divmod_fail_id_v17;

NOINLINE static unsigned int
div_by_97_v17(unsigned int value)
{
    return value / 97U;
}

NOINLINE static unsigned int
mod_by_97_v17(unsigned int value)
{
    return value % 97U;
}

NOINLINE static unsigned int
div_by_0100_v17(unsigned int value)
{
    return value / 0100U;
}

NOINLINE static unsigned int
mod_by_0100_v17(unsigned int value)
{
    return value % 0100U;
}

NOINLINE static unsigned int
div_by_2_v17(unsigned int value)
{
    return value / 2U;
}

int
main(void)
{
    unsigned int value;

    constant_divmod_fail_id_v17 = 0;

    numerator = (unsigned int)(U36_SIGN + 012345UL);
    value = numerator;

    if (div_by_97_v17(value) != (unsigned int)02507204042UL) {
        constant_divmod_fail_id_v17 = 1;
        abort();
    }
    if (mod_by_97_v17(value) != (unsigned int)03UL) {
        constant_divmod_fail_id_v17 = 2;
        abort();
    }
    if (div_by_2_v17(value) != (unsigned int)0200000005162UL) {
        constant_divmod_fail_id_v17 = 3;
        abort();
    }

    numerator = (unsigned int)U36_MAX;
    value = numerator;

    if (div_by_0100_v17(value) != (unsigned int)0007777777777UL) {
        constant_divmod_fail_id_v17 = 4;
        abort();
    }
    if (mod_by_0100_v17(value) != (unsigned int)077UL) {
        constant_divmod_fail_id_v17 = 5;
        abort();
    }

    numerator = 12345U;
    value = numerator;

    if (div_by_97_v17(value) != 127U) {
        constant_divmod_fail_id_v17 = 6;
        abort();
    }
    if (mod_by_97_v17(value) != 26U) {
        constant_divmod_fail_id_v17 = 7;
        abort();
    }

    return 0;
}
