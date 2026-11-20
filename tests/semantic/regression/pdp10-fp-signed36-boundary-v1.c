/*
 * PDP-10 36-bit signed integer / 27-bit SF boundary oracle, C89, v1.
 *
 * All expected results are independent numeric constants.  Integer
 * inputs are volatile, and no out-of-range floating-to-int cast is
 * performed.  Inputs exercise the signed minimum and maximum and
 * both halves of the IEEE-independent PDP-10 ties-to-even boundary.
 */

extern void abort(void);
volatile unsigned int fail_id;
volatile int back_observed_v1;
volatile int back_expected_word_v1;

static volatile int inputs_v1[] = {
    -34359738367 - 1, -34359738367, -134217731, -134217729,
    -134217728, -1, 0, 1, 134217728, 134217729, 134217731,
    34359738367
};

static const float expected_v1[] = {
    -34359738368.0F, -34359738368.0F,
    -134217732.0F, -134217728.0F,
    -134217728.0F, -1.0F, 0.0F, 1.0F,
    134217728.0F, 134217728.0F, 134217732.0F,
    34359738368.0F
};

static volatile float back_v1[] = {
    -34359738368.0F, -134217728.0F, -1024.0F, -1.75F,
    -1.0F, 0.0F, 1.0F, 1.75F, 1024.0F, 134217728.0F
};

static const int back_expected_v1[] = {
    -34359738367 - 1, -134217728, -1024, -1, -1, 0,
    1, 1, 1024, 134217728
};

static float
i2f_v1(int x)
{
    return (float)x;
}

static int
f2i_v1(float x)
{
    return (int)x;
}

int
main(void)
{
    unsigned int i;
    if (sizeof(int) != 4 || sizeof(float) != 4) {
        fail_id = 1;
        abort();
    }
    for (i = 0; i < 12; ++i) {
        if (i2f_v1(inputs_v1[i]) != expected_v1[i]) {
            fail_id = 16 + i + 1;
            abort();
        }
    }
    for (i = 0; i < 10; ++i) {
        back_observed_v1 = f2i_v1(back_v1[i]);
        back_expected_word_v1 = back_expected_v1[i];
        if (back_observed_v1 != back_expected_word_v1) {
            fail_id = 48 + i + 1;
            abort();
        }
    }
    return 0;
}
