/* Executable wide-arithmetic oracle for deferred arith-ll.c.
 * Original uses printf solely to report mismatched arithmetic values.
 * This companion compares add/sub/mul/div directly, with independently
 * derived expected results and volatile source operands. No hosted I/O.
 * Signed long long is a 71-bit target type; test operands are bounded
 * to avoid overflow and signed minimum / -1 undefined division.
 */

typedef signed long long wide_v1;

static volatile wide_v1 lhs_v1;
static volatile wide_v1 rhs_v1;
volatile unsigned int fail_id;
extern void abort(void);

static wide_v1
add_v1(wide_v1 a, wide_v1 b)
{
    return a + b;
}

static wide_v1
sub_v1(wide_v1 a, wide_v1 b)
{
    return a - b;
}

static wide_v1
mul_v1(wide_v1 a, wide_v1 b)
{
    return a * b;
}

static wide_v1
div_v1(wide_v1 a, wide_v1 b)
{
    return a / b;
}

static void
check_v1(wide_v1 a, wide_v1 b, wide_v1 sum, wide_v1 diff,
         wide_v1 product, wide_v1 quotient, unsigned int id)
{
    lhs_v1 = a;
    rhs_v1 = b;
    if (add_v1(lhs_v1, rhs_v1) != sum) {
        fail_id = id * 8 + 1;
        abort();
    }
    if (sub_v1(lhs_v1, rhs_v1) != diff) {
        fail_id = id * 8 + 2;
        abort();
    }
    if (mul_v1(lhs_v1, rhs_v1) != product) {
        fail_id = id * 8 + 3;
        abort();
    }
    if (b != 0 && div_v1(lhs_v1, rhs_v1) != quotient) {
        fail_id = id * 8 + 4;
        abort();
    }
}

int
main(void)
{
    check_v1(-2LL, -1LL, -3LL, -1LL, 2LL, 2LL, 1);
    check_v1(-2LL, 0LL, -2LL, -2LL, 0LL, 0LL, 2);
    check_v1(-2LL, 1LL, -1LL, -3LL, -2LL, -2LL, 3);
    check_v1(-1LL, -1LL, -2LL, 0LL, 1LL, 1LL, 4);
    check_v1(-1LL, 0LL, -1LL, -1LL, 0LL, 0LL, 5);
    check_v1(-1LL, 1LL, 0LL, -2LL, -1LL, -1LL, 6);
    check_v1(0LL, -1LL, -1LL, 1LL, 0LL, 0LL, 7);
    check_v1(0LL, 0LL, 0LL, 0LL, 0LL, 0LL, 8);
    check_v1(0LL, 1LL, 1LL, -1LL, 0LL, 0LL, 9);
    check_v1(1LL, -1LL, 0LL, 2LL, -1LL, -1LL, 10);
    check_v1(1LL, 0LL, 1LL, 1LL, 0LL, 0LL, 11);
    check_v1(1LL, 1LL, 2LL, 0LL, 1LL, 1LL, 12);
    check_v1(2LL, -1LL, 1LL, 3LL, -2LL, -2LL, 13);
    check_v1(2LL, 0LL, 2LL, 2LL, 0LL, 0LL, 14);
    check_v1(2LL, 1LL, 3LL, 1LL, 2LL, 2LL, 15);
    return 0;
}
