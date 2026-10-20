/* PDP-6 negative exact-halfway FADR/FSBR, independent AAP acceptance.
 * These eight cases were independently verified against SAIL 10TO6.TED
 * and the AAP PDP-6 pulse-level emulator.  They do not include the
 * independent AAP exact-normalization discrepancy at -2^27 + 1.
 */
extern void abort(void);

union pdp6_negative_half_word_v3 {
    float value;
    unsigned int word;
};

struct pdp6_negative_half_case_v3 {
    float a;
    float b;
    unsigned int expected;
    unsigned int subtract;
};

static const struct pdp6_negative_half_case_v3 cases_v3[] = {
    {-134217728.0F, -1.0F, 0543400000000UL, 0},
    {-134217728.0F,  1.0F, 0543400000000UL, 1},
    {-134217728.0F, -3.0F, 0543377777777UL, 0},
    {-134217728.0F,  3.0F, 0543377777777UL, 1},
    {-134217728.0F, -5.0F, 0543377777776UL, 0},
    {-134217728.0F,  5.0F, 0543377777776UL, 1},
    {-134217732.0F, -1.0F, 0543377777776UL, 0},
    {-134217732.0F,  1.0F, 0543377777776UL, 1}
};

volatile unsigned int pdp6_negative_half_index_v3;
volatile float pdp6_negative_half_a_v3;
volatile float pdp6_negative_half_b_v3;
volatile float pdp6_negative_half_result_v3;

int
main(void)
{
    unsigned int i;
    union pdp6_negative_half_word_v3 result;

    for (i = 0; i < sizeof(cases_v3) / sizeof(cases_v3[0]); ++i) {
        pdp6_negative_half_index_v3 = i + 1;
        pdp6_negative_half_a_v3 = cases_v3[i].a;
        pdp6_negative_half_b_v3 = cases_v3[i].b;
        if (cases_v3[i].subtract)
            pdp6_negative_half_result_v3 =
                pdp6_negative_half_a_v3 - pdp6_negative_half_b_v3;
        else
            pdp6_negative_half_result_v3 =
                pdp6_negative_half_a_v3 + pdp6_negative_half_b_v3;
        result.value = pdp6_negative_half_result_v3;
        if (result.word != cases_v3[i].expected)
            abort();
    }
    return 0;
}
