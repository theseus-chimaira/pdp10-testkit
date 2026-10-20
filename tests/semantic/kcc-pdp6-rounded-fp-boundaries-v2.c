/* PDP-6 native rounded FADR/FSBR boundary regression, v2.
 *
 * Input values are exactly representable 36-bit PDP-6 floating values.
 * Expected 36-bit words come from independent integer/rational arithmetic
 * with the PDP-6 sign-dependent halfway rounding rule described in the
 * SAIL 10TO6.TED hardware compatibility notes (negative ties toward zero).
 * Compare word patterns, not host floating-point equality.  Volatile
 * operands force actual native-FP instruction execution rather than KCC
 * constant folding. This test does not establish later PDP-10 semantics.
 */
extern void abort(void);

union pdp6_fp_word_v2 {
    float value;
    unsigned int word;
};

struct pdp6_fp_case_v2 {
    float lhs;
    float rhs;
    unsigned int expected;
    unsigned int subtract;
};

static const struct pdp6_fp_case_v2 fp_cases_v2[] = {
    {-134217728.0F, -1.0F, 0543400000000UL, 0},
    {-134217728.0F,  1.0F, 0543400000000UL, 1},
    {-134217728.0F, -3.0F, 0543377777777UL, 0},
    {-134217728.0F,  3.0F, 0543377777777UL, 1},
    {-134217728.0F, -5.0F, 0543377777776UL, 0},
    {-134217728.0F,  5.0F, 0543377777776UL, 1},
    {-134217732.0F, -1.0F, 0543377777776UL, 0},
    {-134217732.0F,  1.0F, 0543377777776UL, 1},
    {-134217728.0F,  1.0F, 0544000000001UL, 0},
    {-134217728.0F, -1.0F, 0544000000001UL, 1},
    {-134217728.0F, -2.0F, 0543377777777UL, 0},
    {-134217728.0F,  2.0F, 0543377777777UL, 1},
    { 134217728.0F,  1.0F, 0234400000001UL, 0},
    { 134217728.0F,  1.0F, 0233777777777UL, 1},
    { 134217728.0F,  3.0F, 0234400000002UL, 0},
    { 134217728.0F,  3.0F, 0233777777775UL, 1},
    {-268435456.0F, -2.0F, 0542400000000UL, 0},
    {-268435456.0F,  2.0F, 0542400000000UL, 1},
    {-268435456.0F, -6.0F, 0542377777777UL, 0},
    {-268435456.0F,  6.0F, 0542377777777UL, 1},
    { -67108864.0F, -1.0F, 0544377777777UL, 0},
    { -67108864.0F,  1.0F, 0544377777777UL, 1},
    { -67108864.0F, -3.0F, 0544377777775UL, 0},
    { -67108864.0F,  3.0F, 0544377777775UL, 1}
};

volatile unsigned int pdp6_fp_case_index_v2;
volatile unsigned int pdp6_fp_actual_word_v2;
volatile float pdp6_fp_left_v2;
volatile float pdp6_fp_right_v2;
volatile float pdp6_fp_result_v2;

int
main(void)
{
    unsigned int i;
    union pdp6_fp_word_v2 w;

    for (i = 0; i < sizeof(fp_cases_v2) / sizeof(fp_cases_v2[0]); ++i) {
        pdp6_fp_case_index_v2 = i + 1;
        pdp6_fp_left_v2 = fp_cases_v2[i].lhs;
        pdp6_fp_right_v2 = fp_cases_v2[i].rhs;
        if (fp_cases_v2[i].subtract)
            pdp6_fp_result_v2 = pdp6_fp_left_v2 - pdp6_fp_right_v2;
        else
            pdp6_fp_result_v2 = pdp6_fp_left_v2 + pdp6_fp_right_v2;
        w.value = pdp6_fp_result_v2;
        pdp6_fp_actual_word_v2 = w.word;
        if (w.word != fp_cases_v2[i].expected)
            abort();
    }
    return 0;
}
