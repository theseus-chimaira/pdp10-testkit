/* Full 71-bit add/sub high-word arithmetic of GCC 961122-1.c.
 * The original 0xffff00000000 + (1<<32) == 0x1000000000000
 * follows directly from independent unbounded integer arithmetic.
 * Check both intermediate and restored values with volatile inputs.
 */

static volatile short shift_operand_v1;
static volatile signed long long accumulator_v1;
volatile unsigned int fail_id;
extern void abort(void);

static void
addhi_v1(short a)
{
    accumulator_v1 += (signed long long)a << 32;
}

static void
subhi_v1(short a)
{
    accumulator_v1 -= (signed long long)a << 32;
}

int
main(void)
{
    accumulator_v1 = 0xffff00000000LL;
    shift_operand_v1 = 1;
    addhi_v1(shift_operand_v1);
    if (accumulator_v1 != 0x1000000000000LL) {
        fail_id = 1;
        abort();
    }
    subhi_v1(shift_operand_v1);
    if (accumulator_v1 != 0xffff00000000LL) {
        fail_id = 2;
        abort();
    }
    return 0;
}
