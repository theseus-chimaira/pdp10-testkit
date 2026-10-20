/* PDP-10 27-significant-bit single-float literal encoding (C99).
 * Host IEEE binary32 has only 24 significand bits.  Compiler parsing
 * must not round a PDP-10 float literal through host float first.
 * Expected 36-bit words are derived from the actual PDP-10 format.
 */
extern void abort(void);

union float_literal_bits_v1 {
    float f;
    unsigned int bits;
};

volatile int literal_case_v1;
static volatile float values_v1[] = {
    0.0F,
    1.0F,
    10.0F,
    134217728.0F,
    134217729.0F,  /* exactly halfway: ties to even */
    134217731.0F,  /* exactly halfway: round upward */
    134217732.0F,  /* representable, but lost by IEEE binary32 */
    -134217732.0F,
    1125899906842624.0F
};

static const unsigned int expected_v1[] = {
    0000000000000UL,
    0201400000000UL,
    0204500000000UL,
    0234400000000UL,
    0234400000000UL,
    0234400000002UL,
    0234400000002UL,
    0543377777776UL,
    0263400000000UL
};

int
main(void)
{
    unsigned int i;
    union float_literal_bits_v1 number;
    for (i = 0; i < sizeof(expected_v1)/sizeof(expected_v1[0]); ++i) {
        literal_case_v1 = (int)i+1;
        number.f = values_v1[i];
        if (number.bits != expected_v1[i])
            abort();
    }
    return 0;
}
