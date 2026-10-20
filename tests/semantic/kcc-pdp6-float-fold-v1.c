/* Host-compiler target-precision constant folding, C99.
 *
 * The PDP-10's 36-bit single-precision format retains 27 significant
 * bits.  An IEEE binary32 host compiler retains only 24: evaluating
 * expressions or casts with host float drops values such as 2^27+4.
 * Check result *words*, not host-side expectations or printf strings.
 */
extern void abort(void);

union kff_bits_v1 {
    float f;
    unsigned int word;
};

static volatile float kff_values_v1[] = {
    134217728.0F + 4.0F,
    134217732.0F - 4.0F,
    134217732.0F * 2.0F,
    268435464.0F / 2.0F,
    (float)134217732.0,
    (float)134217732,
    (float)134217732UL,
    -134217732.0F + 4.0F,
    (float)(134217728.0 + 4.0),
    (float)((double)134217732.0F),
    (float)(134217728.0F + 4.0F),
    (float)134217729.0,  /* double-to-float halfway: to even */
    (float)134217731.0,  /* halfway: next even fraction */
    (float)134217729,    /* signed integer-to-float tie */
    (float)134217731UL,  /* unsigned integer-to-float tie */
    -134217732.0F * 2.0F,
    -268435464.0F / 2.0F,
    -134217732.0F + 4.0F,
    -134217728.0F - 1.0F,
    -134217728.0F + -1.0F
};

static const unsigned int kff_expected_v1[] = {
    0234400000002UL,
    0234400000000UL,
    0235400000002UL,
    0234400000002UL,
    0234400000002UL,
    0234400000002UL,
    0234400000002UL,
    0543400000000UL,
    0234400000002UL,
    0234400000002UL,
    0234400000002UL,
    0234400000000UL,
    0234400000002UL,
    0234400000000UL,
    0234400000002UL,
    0542377777776UL,
    0543377777776UL,
    0543400000000UL,
    0543400000000UL,
    0543400000000UL
};

volatile int kff_case_v1;
volatile int kff_cmp_v1;
volatile float kff_associative_v1;
volatile float kff_base_v1;
volatile float kff_folded_tie_v1;
volatile float kff_runtime_tie_v1;
volatile float kff_runtime_operand_v1;

int
main(void)
{
    unsigned int i;
    union kff_bits_v1 u;

    for (i = 0; i < sizeof(kff_expected_v1) /
                    sizeof(kff_expected_v1[0]); ++i) {
        kff_case_v1 = (int)i + 1;
        u.f = kff_values_v1[i];
        if (u.word != kff_expected_v1[i])
            abort();
    }
    kff_cmp_v1 = (134217732.0F > 134217728.0F);
    if (kff_cmp_v1 != 1)
        abort();

    /* Do not reassociate floating additions unless semantics allow it.
     * (x + 2^27) + 4 differs from x + (2^27 + 4) in general.
     */
    kff_base_v1 = 1.0F;
    kff_associative_v1 = (kff_base_v1 + 134217728.0F) + 2.0F;
    u.f = kff_associative_v1;
    /* PDP-6 rounded FADR arithmetic rounds halfway cases differently
     * from the integer-to-float conversion.  Keep source ordering.
     */
    if (u.word != 0234400000002UL)
        abort();

    /* Compare folding with a real PDP-6 FADR on a half-ULP boundary.
     * Volatile blocks folding of the right-hand computation only.
     */
    kff_folded_tie_v1 = 134217728.0F + 1.0F;
    kff_runtime_operand_v1 = 134217728.0F;
    kff_runtime_tie_v1 = kff_runtime_operand_v1 + 1.0F;
    if (kff_folded_tie_v1 != kff_runtime_tie_v1)
        abort();
    /* Negative halfway arithmetic is checked in the static initializers
     * above.  An unoptimized automatic expression must execute FADR/FSBR,
     * whose SIMH and AAP negative rounding currently disagree.  Keep that
     * runtime discrepancy as a separate manual regression; do not let
     * -n turn this compile-time folding test into a simulator oracle.
     */
    return 0;
}
