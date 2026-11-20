/*
 * PDP-10 36-bit unsigned / floating conversion locator, C89, v1.
 *
 * The original conversion.c includes both signed and unsigned casts.
 * This standalone oracle uses volatile values and independent numeric
 * expectations to isolate the unsigned families without any 71-bit
 * GNU-C extension or out-of-range float-to-integer conversion.
 *
 * fail_id encodes the first failed family and zero-based input index:
 *   1 unsigned -> float, 2 unsigned -> double,
 *   3 float -> unsigned, 4 double -> unsigned.
 * Each family uses 16 * family + index + 1.
 */

extern void abort(void);

volatile unsigned int fail_id;
volatile float uf_observed_v1;
volatile float uf_expected_v1;
volatile double ud_observed_v1;
volatile double ud_expected_v1;

static volatile unsigned int u_inputs_v1[5] = {
    0U, 1U, (~0U) >> 1, ~((~0U) >> 1), ~0U
};

static const float f_expected_v1[5] = {
    0.0F, 1.0F, 34359738368.0F, 34359738368.0F, 68719476736.0F
};

static const double d_expected_v1[5] = {
    0.0, 1.0, 34359738367.0, 34359738368.0, 68719476735.0
};

static volatile float f_inputs_v1[6] = {
    0.0F, 0.999F, 1.0F, 1.99F, 1024.0F, 34359738368.0F
};

static const unsigned int f_results_v1[6] = {
    0U, 0U, 1U, 1U, 1024U, ~((~0U) >> 1)
};

static volatile double d_inputs_v1[7] = {
    0.0, 0.999, 1.0, 1.99, 1024.0, 34359738368.0,
    68719476735.0
};

static const unsigned int d_results_v1[7] = {
    0U, 0U, 1U, 1U, 1024U, ~((~0U) >> 1), ~0U
};

static float
u2f_v1(unsigned int value)
{
    return (float)value;
}

static double
u2d_v1(unsigned int value)
{
    return (double)value;
}

static unsigned int
f2u_v1(float value)
{
    return (unsigned int)value;
}

static unsigned int
d2u_v1(double value)
{
    return (unsigned int)value;
}

int
main(void)
{
    unsigned int i;
    for (i = 0; i < 5; ++i) {
        uf_observed_v1 = u2f_v1(u_inputs_v1[i]);
        uf_expected_v1 = f_expected_v1[i];
        if (uf_observed_v1 != uf_expected_v1) {
            fail_id = 16 + i + 1;
            abort();
        }
    }
    for (i = 0; i < 5; ++i) {
        ud_observed_v1 = u2d_v1(u_inputs_v1[i]);
        ud_expected_v1 = d_expected_v1[i];
        if (ud_observed_v1 != ud_expected_v1) {
            fail_id = 32 + i + 1;
            abort();
        }
    }
    for (i = 0; i < 6; ++i) {
        if (f2u_v1(f_inputs_v1[i]) != f_results_v1[i]) {
            fail_id = 48 + i + 1;
            abort();
        }
    }
    for (i = 0; i < 7; ++i) {
        if (d2u_v1(d_inputs_v1[i]) != d_results_v1[i]) {
            fail_id = 64 + i + 1;
            abort();
        }
    }
    return 0;
}
