/*
 * PDP-10 native signed arithmetic conversion regression.
 *
 * Companion to the blocked historical conversion.c.  The original
 * exercises unsigned float-to-int and GCC-only long-long paths which
 * require additional target helpers.  This freestanding C89 program
 * isolates defined 36-bit signed int/float/double conversions.
 *
 * Expected floating values are independent numeric constants, not
 * computed by the very conversion being tested.  Input arrays are
 * volatile to require actual runtime conversions.  All values fit
 * the target signed integer range; no undefined out-of-range cast.
 */

extern void abort(void);

volatile unsigned int fail_id;

static volatile int integer_inputs_v1[5] =
    {-1024, -1, 0, 1, 1024};

static const float float_expected_v1[5] =
    {-1024.0F, -1.0F, 0.0F, 1.0F, 1024.0F};

static const double double_expected_v1[5] =
    {-1024.0, -1.0, 0.0, 1.0, 1024.0};

static volatile float float_inputs_v1[7] =
    {-1024.0F, -1.75F, -1.0F, 0.0F, 1.0F, 1.75F, 1024.0F};

static volatile double double_inputs_v1[7] =
    {-1024.0, -1.75, -1.0, 0.0, 1.0, 1.75, 1024.0};

static const int integer_expected_v1[7] =
    {-1024, -1, -1, 0, 1, 1, 1024};

/*
 * Evaluate all four conversion families on every run. A failure in
 * the first negative input must not hide the later FP-to-integer tests.
 * fail_id bit positions:
 *   1 signed int -> float; 2 signed int -> double
 *   4 float -> signed int; 8 double -> signed int
 *  16 target size assumption
 */
static void
check_v1(int ok, unsigned int group)
{
    if (!ok)
        fail_id |= group;
}

static float
int_to_float_v1(int value)
{
    return (float)value;
}

static double
int_to_double_v1(int value)
{
    return (double)value;
}

static int
float_to_int_v1(float value)
{
    return (int)value;
}

static int
double_to_int_v1(double value)
{
    return (int)value;
}

int
main(void)
{
    unsigned int i;
    int input;
    float f;
    double d;

    fail_id = 0;
    check_v1(sizeof(int) == 4, 16);
    check_v1(sizeof(float) == 4, 16);
    check_v1(sizeof(double) >= 8, 16);

    for (i = 0; i < 5; ++i) {
        input = integer_inputs_v1[i];
        f = int_to_float_v1(input);
        check_v1(f == float_expected_v1[i], 1);
        d = int_to_double_v1(input);
        check_v1(d == double_expected_v1[i], 2);
    }

    for (i = 0; i < 7; ++i) {
        f = float_inputs_v1[i];
        check_v1(float_to_int_v1(f) == integer_expected_v1[i], 4);
        d = double_inputs_v1[i];
        check_v1(double_to_int_v1(d) == integer_expected_v1[i], 8);
    }

    if (fail_id != 0)
        abort();
    return 0;
}
