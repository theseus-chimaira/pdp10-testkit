/* Original nestfunc-3.c three-level nested callback chain.
 * A 2x2x2 bounded loop avoids signed long overflow (the original
 * 10x10x10 loop overflows 36-bit long before its final comparison).
 * This tests the defined C arithmetic and captures across nested
 * trampolines without NO_TRAMPOLINES vacuous preprocessor guards.
 */
extern void abort(void);
volatile unsigned int fail_id;
static volatile unsigned long callbacks_v1;

static long
use_v1(long (*fn)(long, long), long a, long b)
{
    return fn(b, a);
}

static long
foo_v1(long a, long b, long (*fn)(long, long))
{
    return fn(a, b);
}

int
main(void)
{
    long sum = 0;
    long i, j, k;

    long nest_0(long a, long b)
    {
        callbacks_v1++;
        if (a > 2 * b)
            return a - b;
        return b - a;
    }
    long nest_1(long a, long b)
    {
        return use_v1(nest_0, b, a) + sum;
    }
    long nest_2(long a, long b)
    {
        return nest_1(b, a);
    }
    for (i = 0; i < 2; ++i)
        for (j = 0; j < 2; ++j)
            for (k = 0; k < 2; ++k)
                sum += foo_v1(i, j > k ? j - k : k - j, nest_2);

    if (sum != 105L) {
        fail_id = 1;
        abort();
    }
    if (callbacks_v1 != 8UL) {
        fail_id = 2;
        abort();
    }
    return 0;
}
