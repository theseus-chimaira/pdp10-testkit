/*
 * PDP-10 compiler conversion failure locator (C89), version 1.
 *
 * This program runs each conversion independently with volatile
 * arguments and independent expected numeric constants.  Unlike a
 * combined failure mask, fail_id encodes the first failing family
 * and input index.  The exact input values are all representable
 * without integer overflow or implementation-defined FP-to-int casts.
 *
 * Family: 1 signed int to float, 2 signed int to double,
 *         3 float to signed int, 4 double to signed int.
 * fail_id = family * 16 + index + 1, where index is zero based.
 */

extern void abort(void);

volatile unsigned int fail_id;
/* Observed and expected bit patterns remain inspectable in p10run. */
volatile float sf_observed_v1;
volatile float sf_expected_v1;
volatile double df_observed_v1;
volatile double df_expected_v1;

static volatile int ints_v1[] = {-1024, -1, 0, 1, 1024};
static const float fs_v1[] = {-1024.0F, -1.0F, 0.0F, 1.0F, 1024.0F};
static const double ds_v1[] = {-1024.0, -1.0, 0.0, 1.0, 1024.0};
static volatile float f_inputs_v1[] = {
    -1024.0F, -1.75F, -1.0F, 0.0F, 1.0F, 1.75F, 1024.0F
};
static volatile double d_inputs_v1[] = {
    -1024.0, -1.75, -1.0, 0.0, 1.0, 1.75, 1024.0
};
static const int int_results_v1[] = {-1024, -1, -1, 0, 1, 1, 1024};

static float
s2f_v1(int value)
{
    return (float)value;
}

static double
s2d_v1(int value)
{
    return (double)value;
}

static int
f2s_v1(float value)
{
    return (int)value;
}

static int
d2s_v1(double value)
{
    return (int)value;
}

int
main(void)
{
    unsigned int i;
    for (i = 0; i < 5; ++i) {
        sf_observed_v1 = s2f_v1(ints_v1[i]);
        sf_expected_v1 = fs_v1[i];
        if (sf_observed_v1 != sf_expected_v1) {
            if (fail_id == 0)
                fail_id = 16 + i + 1;
        }
    }
    if (fail_id != 0)
        abort();
    for (i = 0; i < 5; ++i) {
        df_observed_v1 = s2d_v1(ints_v1[i]);
        df_expected_v1 = ds_v1[i];
        if (df_observed_v1 != df_expected_v1) {
            fail_id = 32 + i + 1;
            abort();
        }
    }
    for (i = 0; i < 7; ++i) {
        if (f2s_v1(f_inputs_v1[i]) != int_results_v1[i]) {
            fail_id = 48 + i + 1;
            abort();
        }
    }
    for (i = 0; i < 7; ++i) {
        if (d2s_v1(d_inputs_v1[i]) != int_results_v1[i]) {
            fail_id = 64 + i + 1;
            abort();
        }
    }
    return 0;
}
