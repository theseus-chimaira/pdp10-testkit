/* PDP-6 signed 71-bit integer <-> single-precision C float regression.
 *
 * PDP-6 has its own native 36-bit floating-point instructions.  A signed
 * DImode is instead 71 bits (high36:low35); the old scalar FLTR path
 * silently converted only the high half.  This file exercises ordinary
 * C casts, round-to-nearest-even narrowing and truncation toward zero.
 * It does not validate the later PDP-10 FP instruction set.
 */
extern void abort(void);

volatile int native_float_case_v1;
volatile long long native_float_source_v1;
volatile float native_float_result_v1;
volatile long long native_float_inverse_v1;

union native_float_bits_v1 {
    float number;
    unsigned int word;
};

static void
verify_native_float_v1(long long source, unsigned int expected_word,
                       long long inverse)
{
    union native_float_bits_v1 actual;
    native_float_case_v1++;
    native_float_source_v1 = source;
    native_float_result_v1 = (float)native_float_source_v1;
    actual.number = native_float_result_v1;
    if (actual.word != expected_word)
        abort();
    native_float_inverse_v1 = (long long)native_float_result_v1;
    if (native_float_inverse_v1 != inverse)
        abort();
}

int
main(void)
{
    long long power;
    native_float_case_v1 = 0;
    verify_native_float_v1(0LL, 0000000000000UL, 0LL);
    verify_native_float_v1(1LL, 0201400000000UL, 1LL);
    verify_native_float_v1(-1LL, 0576400000000UL, -1LL);
    verify_native_float_v1(10LL, 0204500000000UL, 10LL);
    verify_native_float_v1(-10LL, 0573300000000UL, -10LL);
    verify_native_float_v1(12345LL, 0216601620000UL, 12345LL);
    verify_native_float_v1(-12345LL, 0561176160000UL, -12345LL);

    power = 1LL << 26;
    verify_native_float_v1(power, 0233400000000UL, power);
    verify_native_float_v1(-power, 0544400000000UL, -power);

    power = 1LL << 27;
    verify_native_float_v1(power, 0234400000000UL, power);
    verify_native_float_v1(-power, 0543400000000UL, -power);
    /* At this exponent the 27-bit fraction has 2-unit spacing.  The
     * +1 tie rounds down to even, +3 rounds up to the next even value.
     */
    verify_native_float_v1(power + 1LL, 0234400000000UL, power);
    verify_native_float_v1(-power - 1LL, 0543400000000UL, -power);
    verify_native_float_v1(power + 3LL, 0234400000002UL, power + 4LL);
    verify_native_float_v1(-power - 3LL, 0543377777776UL, -power - 4LL);

    power = 1LL << 35;
    verify_native_float_v1(power, 0244400000000UL, power);
    verify_native_float_v1(-power, 0533400000000UL, -power);

    power = 1LL << 50;
    verify_native_float_v1(power, 0263400000000UL, power);
    verify_native_float_v1(-power, 0514400000000UL, -power);
    verify_native_float_v1(power + 1LL, 0263400000000UL, power);
    verify_native_float_v1(-power - 1LL, 0514400000000UL, -power);
    return 0;
}
