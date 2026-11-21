/*
 * GCC PDP-10 signed 71-bit DImode -> SF/DF conversion ABI, C89.
 *
 * The 71-bit integer is passed as two explicit target 36-bit words:
 * a high 36-bit word and 35 low payload bits with copied sign in
 * the low word's top bit.  This tests the true compiler libgcc entry
 * points without depending on a host C long long extension.
 *
 * Each input pair is kept volatile and every expected floating value
 * is an independent decimal constant.  No fake conversion routine
 * or operating-system libc is linked.
 */

extern void abort(void);
extern float __floatdisf(unsigned int, unsigned int);
extern double __floatdidf(unsigned int, unsigned int);

volatile unsigned int fail_id;
volatile unsigned int high_v1;
volatile unsigned int low_v1;
volatile float observed_sf_v1;
volatile double observed_df_v1;
volatile unsigned int sf_fail_mask_v1;
volatile unsigned int df_fail_mask_v1;

struct sample_v1 {
    unsigned int high;
    unsigned int low;
    float sf;
    double df;
};

static const struct sample_v1 cases_v1[] = {
    {0U, 0U, 0.0F, 0.0},
    {0U, 1U, 1.0F, 1.0},
    {0U, 0377777777777U, 34359738368.0F, 34359738367.0},
    {1U, 0U, 34359738368.0F, 34359738368.0},
    {0377777777777U, 0377777777777U,
     1180591620717411303424.0F, 1180591620717411303424.0},
    /* At 2^69 the SF ULP is 2^43.  The exact half-ULP rounds
     * to even, while the half-ULP plus one must round upward.
     * The D-format ULP is only 256, so both have the same DF value.
     */
    {0200000000200U, 0U,
     590295810358705651712.0F, 590295814756752162816.0},
    {0200000000200U, 1U,
     590295819154798673920.0F, 590295814756752162816.0},
    {0777777777777U, 0777777777777U, -1.0F, -1.0},
    {0400000000000U, 0400000000000U,
     -1180591620717411303424.0F, -1180591620717411303424.0}
};

int
main(void)
{
    unsigned int i;
    for (i = 0; i < sizeof(cases_v1) / sizeof(cases_v1[0]); ++i) {
        high_v1 = cases_v1[i].high;
        low_v1 = cases_v1[i].low;
        observed_sf_v1 = __floatdisf(high_v1, low_v1);
        if (observed_sf_v1 != cases_v1[i].sf)
            sf_fail_mask_v1 |= 1U << i;
        observed_df_v1 = __floatdidf(high_v1, low_v1);
        if (observed_df_v1 != cases_v1[i].df)
            df_fail_mask_v1 |= 1U << i;
    }
    if (sf_fail_mask_v1 != 0 || df_fail_mask_v1 != 0) {
        fail_id = sf_fail_mask_v1 | (df_fail_mask_v1 << 12);
        abort();
    }
    return 0;
}
