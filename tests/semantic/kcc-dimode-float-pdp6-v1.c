/* Software D-format ABI regression on the PDP-6, C99.
 *
 * The PDP-6's own floating-point hardware is NOT interchangeable with
 * the later PDP-10 D-format.  These helpers operate entirely with
 * PDP-6 integer instructions and explicitly build the two-word
 * portable C 'long double' representation.
 *
 * The expected bit patterns were derived independently with arbitrary
 * precision integer arithmetic, including nearest/even rounding.
 */
extern long double __kcc_floatdidf(long long);
extern long long __kcc_fixdfdi(long double);
extern void abort(void);

union df_words_v1 {
    long double d;
    unsigned int word[2];
};

struct df_case_v1 {
    long long source;
    unsigned int high;
    unsigned int low;
    long long truncated;
    int inverse_valid;
};

volatile int df_case_index_v1;
volatile int df_fraction_case_index_v1;
volatile int df_failure_stage_v1;
volatile unsigned int df_actual_high_v1;
volatile unsigned int df_actual_low_v1;
volatile long long df_actual_int_v1;
static volatile long long df_input_v1;

static struct df_case_v1 df_cases_v1[] = {
    { 0LL, 000000000000UL, 000000000000UL, 0LL, 1 },
    { 1LL, 0201400000000UL, 000000000000UL, 1LL, 1 },
    { -1LL, 0576400000000UL, 0400000000000UL, -1LL, 1 },
    { 10LL, 0204500000000UL, 000000000000UL, 10LL, 1 },
    { -10LL, 0573300000000UL, 0400000000000UL, -10LL, 1 },
    { 1LL << 35, 0244400000000UL, 000000000000UL, 1LL << 35, 1 },
    { -(1LL << 35), 0533400000000UL, 0400000000000UL, -(1LL << 35), 1 },
    { (1LL << 60) + 17LL, 0275400000000UL, 0000000000042UL,
      (1LL << 60) + 17LL, 1 },
    { -((1LL << 60) + 17LL), 0502377777777UL, 0777777777736UL,
      -((1LL << 60) + 17LL), 1 },
    { 1LL << 62, 0277400000000UL, 000000000000UL, 1LL << 62, 1 },
    { (1LL << 62) + 1LL, 0277400000000UL, 000000000000UL,
      1LL << 62, 1 },
    { (1LL << 62) + 2LL, 0277400000000UL, 0000000000001UL,
      (1LL << 62) + 2LL, 1 },
    { (1LL << 62) + 3LL, 0277400000000UL, 0000000000002UL,
      (1LL << 62) + 4LL, 1 },
    { -((1LL << 62) + 1LL), 0500400000000UL, 0400000000000UL,
      -(1LL << 62), 1 },
    { -((1LL << 62) + 3LL), 0500377777777UL, 0777777777776UL,
      -((1LL << 62) + 4LL), 1 },
    { 0LL,  /* Full-range source initialized at runtime. */
      0307400000000UL, 000000000000UL, 0LL, 0 },
    { 0LL,  /* Signed minimum initialized at runtime. */
      0470400000000UL, 0400000000000UL,
      0LL, 1 }
};

/* Separately derived exact D-format encodings for fractional inputs.
 * Integer conversion must truncate toward zero, never round to nearest.
 */
static struct {
    unsigned int high;
    unsigned int low;
    long long truncated;
} df_fraction_cases_v1[] = {
    { 0200400000000UL, 000000000000UL, 0LL },       /* +0.5 */
    { 0177400000000UL, 000000000000UL, 0LL },       /* +0.25 */
    { 0201600000000UL, 000000000000UL, 1LL },       /* +1.5 */
    { 0200600000000UL, 000000000000UL, 0LL },       /* +0.75 */
    { 0202740000000UL, 000000000000UL, 3LL },       /* +3.75 */
    { 0205422000000UL, 000000000000UL, 17LL },      /* +17.125 */
    { 0577400000000UL, 0400000000000UL, 0LL },      /* -0.5 */
    { 0576200000000UL, 0400000000000UL, -1LL },     /* -1.5 */
    { 0575040000000UL, 0400000000000UL, -3LL },     /* -3.75 */
    { 0572356000000UL, 0400000000000UL, -17LL }     /* -17.125 */
};

int
main(void)
{
    unsigned int i;
    union df_words_v1 actual;
    union df_words_v1 cast_result;
    long long back;
    long long cast_back;
    volatile long long half_range = 1LL << 69;

    df_cases_v1[15].source = (half_range - 1LL) * 2LL + 1LL;
    df_cases_v1[16].source = -half_range - half_range;
    df_cases_v1[16].truncated = df_cases_v1[16].source;

    for (i = 0; i < sizeof(df_cases_v1) / sizeof(df_cases_v1[0]); ++i) {
        df_case_index_v1 = (int)i + 1;
        df_input_v1 = df_cases_v1[i].source;
        df_failure_stage_v1 = 1;
        actual.d = __kcc_floatdidf(df_input_v1);
        df_actual_high_v1 = actual.word[0];
        df_actual_low_v1 = actual.word[1];
        if (df_actual_high_v1 != df_cases_v1[i].high ||
            df_actual_low_v1 != df_cases_v1[i].low)
            abort();
        /* Re-check through ordinary C casts, not just direct ABI calls. */
        df_failure_stage_v1 = 2;
        cast_result.d = (long double)df_input_v1;
        if (cast_result.word[0] != df_cases_v1[i].high ||
            cast_result.word[1] != df_cases_v1[i].low)
            abort();
        if (df_cases_v1[i].inverse_valid) {
            df_failure_stage_v1 = 3;
            back = __kcc_fixdfdi(actual.d);
            df_actual_int_v1 = back;
            if (back != df_cases_v1[i].truncated)
                abort();
            df_failure_stage_v1 = 4;
            cast_back = (long long)cast_result.d;
            if (cast_back != df_cases_v1[i].truncated)
                abort();
        }
    }
    for (i = 0; i < sizeof(df_fraction_cases_v1) /
                    sizeof(df_fraction_cases_v1[0]); ++i) {
        df_fraction_case_index_v1 = (int)i + 1;
        df_failure_stage_v1 = 5;
        actual.word[0] = df_fraction_cases_v1[i].high;
        actual.word[1] = df_fraction_cases_v1[i].low;
        back = __kcc_fixdfdi(actual.d);
        df_actual_int_v1 = back;
        if (back != df_fraction_cases_v1[i].truncated)
            abort();
        df_failure_stage_v1 = 6;
        cast_back = (long long)actual.d;
        if (cast_back != df_fraction_cases_v1[i].truncated)
            abort();
    }
    return 0;
}
