/* Independent PDP-10 signed 52/53-bit field boundary readback.
 * Retains both pad/field orders from the deferred upstream 991118-1.c
 * and bf64-1.c without relying on a 64-bit sizeof(long long) guard.
 * Expected values are decimal signed constants derived from powers
 * of two, not evaluated from the same target shift expression.
 */

struct signed52_leading_v1 {
    signed long long pad : 12;
    signed long long field : 52;
};

struct signed52_trailing_v1 {
    signed long long field : 52;
    signed long long pad : 12;
};

struct signed53_leading_v1 {
    signed long long pad : 11;
    signed long long field : 53;
};

struct signed53_trailing_v1 {
    signed long long field : 53;
    signed long long pad : 11;
};

static struct signed52_leading_v1 first52_v1;
static struct signed52_trailing_v1 last52_v1;
static struct signed53_leading_v1 first53_v1;
static struct signed53_trailing_v1 last53_v1;
static volatile signed long long input_v1;
volatile unsigned int fail_id;
extern void abort(void);

static void
check52_v1(signed long long expected)
{
    first52_v1.pad = 0x123;
    last52_v1.pad = 0x123;
    first52_v1.field = input_v1;
    last52_v1.field = input_v1;
    if (first52_v1.pad != 0x123 || last52_v1.pad != 0x123) {
        fail_id = 1;
        abort();
    }
    if (first52_v1.field != expected) {
        fail_id = 2;
        abort();
    }
    if (last52_v1.field != expected) {
        fail_id = 3;
        abort();
    }
}

static void
check53_v1(signed long long expected)
{
    first53_v1.pad = 0x123;
    last53_v1.pad = 0x123;
    first53_v1.field = input_v1;
    last53_v1.field = input_v1;
    if (first53_v1.pad != 0x123 || last53_v1.pad != 0x123) {
        fail_id = 4;
        abort();
    }
    if (first53_v1.field != expected) {
        fail_id = 5;
        abort();
    }
    if (last53_v1.field != expected) {
        fail_id = 6;
        abort();
    }
}

int
main(void)
{
    input_v1 = 0LL;
    check52_v1(0LL);
    check53_v1(0LL);
    input_v1 = -1LL;
    check52_v1(-1LL);
    check53_v1(-1LL);
    input_v1 = 2251799813685247LL;
    check52_v1(2251799813685247LL);
    input_v1 = -2251799813685248LL;
    check52_v1(-2251799813685248LL);
    input_v1 = 4503599627370495LL;
    check53_v1(4503599627370495LL);
    input_v1 = -4503599627370496LL;
    check53_v1(-4503599627370496LL);
    return 0;
}
