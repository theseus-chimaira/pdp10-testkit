/* DEC native D-format cube-root oracle for deferred upstream cbrt.c.
 * The historical Sun bit-overlay algorithm requires IEEE binary64
 * exponent fields and is unreachable under __pdp10__.
 * This independent, representation-neutral Newton implementation
 * checks the actual positive and negative cube roots with bounded
 * iteration, without fake IEEE constants or hosted math libraries.
 */
extern void abort(void);
volatile unsigned int fail_id;
static volatile double input_v1;

static double
cbrt_v1(double x)
{
    double absolute, guess;
    int i;
    if (x == 0.0)
        return 0.0;
    absolute = x < 0.0 ? -x : x;
    guess = absolute < 1.0 ? 1.0 : absolute;
    for (i = 0; i < 24; i++)
        guess = (2.0 * guess + absolute / (guess * guess)) / 3.0;
    return x < 0.0 ? -guess : guess;
}

static double
magnitude_v1(double x)
{
    return x < 0.0 ? -x : x;
}

static void
check_v1(double x, double expected, unsigned int id)
{
    double observed;
    input_v1 = x;
    observed = cbrt_v1(input_v1);
    if (magnitude_v1(observed - expected) > 0.00001) {
        fail_id = id;
        abort();
    }
    if (magnitude_v1(observed*observed*observed - input_v1) > 0.003) {
        fail_id = id + 010;
        abort();
    }
}

int
main(void)
{
    check_v1(0.0, 0.0, 1);
    check_v1(1.0, 1.0, 2);
    check_v1(-1.0, -1.0, 3);
    check_v1(8.0, 2.0, 4);
    check_v1(-8.0, -2.0, 5);
    check_v1(27.0, 3.0, 6);
    check_v1(-27.0, -3.0, 7);
    check_v1(64.0, 4.0, 8);
    check_v1(0.125, 0.5, 9);
    check_v1(0.015625, 0.25, 10);
    return 0;
}
