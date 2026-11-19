/* Test the dormant summation function from GCC inst-check.c.
 * The original main returns without calling f() or checking its value.
 * Expected triangular values are host-reviewed integer constants.
 */

static volatile int input_v1;
volatile unsigned int fail_id;
extern void abort(void);

static int
sum_v1(int limit)
{
    int i;
    int result;

    result = 0;
    for (i = 0; i < limit; i++)
        result += i;
    return result;
}

static void
check_v1(int count, int expected, unsigned int failure)
{
    input_v1 = count;
    if (sum_v1(input_v1) != expected) {
        fail_id = failure;
        abort();
    }
}

int
main(void)
{
    check_v1(-1, 0, 1);
    check_v1(0, 0, 2);
    check_v1(1, 0, 3);
    check_v1(2, 1, 4);
    check_v1(9, 36, 5);
    check_v1(37, 666, 6);
    check_v1(1000, 499500, 7);
    return 0;
}
