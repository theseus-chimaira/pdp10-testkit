/* PDP-6 signed 36-bit SI -> D-format exact conversion, C89, version 1.
 * D-format has sufficient precision to preserve every signed int.
 * Keep volatile source values and separately encoded expectations;
 * test both the returned double and its signed integer roundtrip.
 */
extern void abort(void);
volatile unsigned int fail_id;
volatile double converted_v1;
volatile double expected_v1;
volatile int roundtrip_v1;

static volatile int values_v1[] = {
    -34359738367 - 1, -34359738367, -134217729, -1024,
    -1, 0, 1, 1024, 134217729, 34359738367
};
static const double expected_d_v1[] = {
    -34359738368.0, -34359738367.0, -134217729.0, -1024.0,
    -1.0, 0.0, 1.0, 1024.0, 134217729.0, 34359738367.0
};

static double
to_double_v1(int value)
{
    return (double)value;
}

static int
to_signed_v1(double value)
{
    return (int)value;
}

int
main(void)
{
    unsigned int i;
    for (i = 0; i < 10; ++i) {
        converted_v1 = to_double_v1(values_v1[i]);
        expected_v1 = expected_d_v1[i];
        if (converted_v1 != expected_v1) {
            fail_id = 16 + i + 1;
            abort();
        }
        roundtrip_v1 = to_signed_v1(converted_v1);
        if (roundtrip_v1 != values_v1[i]) {
            fail_id = 48 + i + 1;
            abort();
        }
    }
    return 0;
}
