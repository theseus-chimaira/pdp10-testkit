/* PDP-10 wide-integer arithmetic companion to upstream 960416-1.c.
 * GNU 71-bit long long arithmetic over native 36-bit unsigned words.
 * Expected decimal values and 36-bit high/low limbs were generated
 * independently by Python arbitrary-precision arithmetic. No union
 * overlay, endianness assumption, or 32/32-bit conditional bypass.
 * The original union-layout test remains deferred separately.
 */

typedef unsigned long long wide_v1;
typedef unsigned long word_v1;

static volatile word_v1 lhs_v1;
static volatile word_v1 rhs_v1;
static volatile wide_v1 product_v1;
volatile unsigned int fail_id;
extern void abort(void);

static void
check_v1(word_v1 lhs, word_v1 rhs, wide_v1 result,
         word_v1 high, word_v1 low, unsigned int number)
{
    lhs_v1 = lhs;
    rhs_v1 = rhs;
    product_v1 = (wide_v1)lhs_v1 * (wide_v1)rhs_v1;
    if (product_v1 != result) {
        fail_id = number;
        abort();
    }
    if ((word_v1)(product_v1 >> 36) != high ||
        (word_v1)(product_v1 & 0777777777777ULL) != low) {
        fail_id = number + 010;
        abort();
    }
}

int
main(void)
{
    check_v1(012345670123UL, 023456701234UL,
             3687747394389383316ULL, 53663787UL, 32077224084UL, 1);
    check_v1(023456701234UL, 023456701234UL,
             6914450971456884496ULL, 100618504UL, 26617761552UL, 2);
    check_v1(012345670123UL, 012345670123UL,
             1966820055701437161ULL, 28620998UL, 49479334633UL, 3);
    check_v1(012345670123UL, 1UL,
             1402433619ULL, 0UL, 1402433619UL, 4);
    check_v1(0UL, 023456701234UL,
             0ULL, 0UL, 0UL, 5);
    return 0;
}
