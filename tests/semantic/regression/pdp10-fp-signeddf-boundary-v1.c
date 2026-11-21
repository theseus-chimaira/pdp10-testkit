/* PDP-10 signed D-format -> signed 36-bit integer, C89, v1.
 * All test operands are valid in-range C89 conversions.  The
 * independent constants distinguish a truncation error from an
 * ABI/representation error, including the negative signed minimum.
 */
extern void abort(void);
volatile unsigned int fail_id;
volatile int observed_v1;
volatile int expected_v1;

static volatile double inputs_v1[] = {
    -34359738368.0, -34359738367.0, -134217729.0,
    -1024.0, -1.99, -1.0, -0.999, 0.0, 0.999,
    1.0, 1.99, 1024.0, 134217729.0, 34359738367.0
};
static const int results_v1[] = {
    -34359738367 - 1, -34359738367, -134217729,
    -1024, -1, -1, 0, 0, 0,
    1, 1, 1024, 134217729, 34359738367
};

static int
convert_v1(double x)
{
    return (int)x;
}

int
main(void)
{
    unsigned int i;
    for (i = 0; i < 14; ++i) {
        observed_v1 = convert_v1(inputs_v1[i]);
        expected_v1 = results_v1[i];
        if (observed_v1 != expected_v1) {
            fail_id = i + 1;
            abort();
        }
    }
    return 0;
}
