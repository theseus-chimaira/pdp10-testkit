/* PDP-10 9/18/36-bit left/right shift oracle, version 1.
 * Derived from the intent of GCC 20020108-1.c. The original
 * 8/16/32-bit guards do not execute on a 9-bit-char PDP-10.
 * Every expected word below comes from a host integer model.
 * The original source is preserved unchanged and deferred.
 */
#include <limits.h>
#if CHAR_BIT != 9
#error This is a PDP-10 9-bit-char target-only regression
#endif

extern void abort(void);
volatile unsigned int pdp10_shift_case_v1;
static volatile unsigned char input9_v1;
static volatile unsigned short input18_v1;
static volatile unsigned int input36_v1;
static volatile unsigned int shift_v1;

static const unsigned int expected_left_9_v1[9] = {
    0777UL, 0776UL, 0774UL, 0770UL, 0760UL, 0740UL,
    0700UL, 0600UL, 0400UL
};

static const unsigned int expected_right_9_v1[9] = {
    0777UL, 0377UL, 0177UL, 077UL, 037UL, 017UL,
    07UL, 03UL, 01UL
};

static unsigned char
shift_left_9_v1(unsigned char x, unsigned int n)
{
    return (unsigned char)(x << n);
}

static unsigned char
shift_right_9_v1(unsigned char x, unsigned int n)
{
    return (unsigned char)(x >> n);
}

static const unsigned int expected_left_18_v1[18] = {
    0777777UL, 0777776UL, 0777774UL, 0777770UL, 0777760UL, 0777740UL,
    0777700UL, 0777600UL, 0777400UL, 0777000UL, 0776000UL, 0774000UL,
    0770000UL, 0760000UL, 0740000UL, 0700000UL, 0600000UL, 0400000UL
};

static const unsigned int expected_right_18_v1[18] = {
    0777777UL, 0377777UL, 0177777UL, 077777UL, 037777UL, 017777UL,
    07777UL, 03777UL, 01777UL, 0777UL, 0377UL, 0177UL,
    077UL, 037UL, 017UL, 07UL, 03UL, 01UL
};

static unsigned short
shift_left_18_v1(unsigned short x, unsigned int n)
{
    return (unsigned short)(x << n);
}

static unsigned short
shift_right_18_v1(unsigned short x, unsigned int n)
{
    return (unsigned short)(x >> n);
}

static const unsigned int expected_left_36_v1[36] = {
    0777777777777UL, 0777777777776UL, 0777777777774UL, 0777777777770UL, 0777777777760UL, 0777777777740UL,
    0777777777700UL, 0777777777600UL, 0777777777400UL, 0777777777000UL, 0777777776000UL, 0777777774000UL,
    0777777770000UL, 0777777760000UL, 0777777740000UL, 0777777700000UL, 0777777600000UL, 0777777400000UL,
    0777777000000UL, 0777776000000UL, 0777774000000UL, 0777770000000UL, 0777760000000UL, 0777740000000UL,
    0777700000000UL, 0777600000000UL, 0777400000000UL, 0777000000000UL, 0776000000000UL, 0774000000000UL,
    0770000000000UL, 0760000000000UL, 0740000000000UL, 0700000000000UL, 0600000000000UL, 0400000000000UL
};

static const unsigned int expected_right_36_v1[36] = {
    0777777777777UL, 0377777777777UL, 0177777777777UL, 077777777777UL, 037777777777UL, 017777777777UL,
    07777777777UL, 03777777777UL, 01777777777UL, 0777777777UL, 0377777777UL, 0177777777UL,
    077777777UL, 037777777UL, 017777777UL, 07777777UL, 03777777UL, 01777777UL,
    0777777UL, 0377777UL, 0177777UL, 077777UL, 037777UL, 017777UL,
    07777UL, 03777UL, 01777UL, 0777UL, 0377UL, 0177UL,
    077UL, 037UL, 017UL, 07UL, 03UL, 01UL
};

static unsigned int
shift_left_36_v1(unsigned int x, unsigned int n)
{
    return (unsigned int)(x << n);
}

static unsigned int
shift_right_36_v1(unsigned int x, unsigned int n)
{
    return (unsigned int)(x >> n);
}

int
main(void)
{
    unsigned int i;

    input9_v1 = 0777UL;
    for (i = 0; i < 9; ++i) {
        shift_v1 = i;
        pdp10_shift_case_v1++;
        if ((unsigned int)shift_left_9_v1(input9_v1, shift_v1)
            != expected_left_9_v1[i])
            abort();
        if ((unsigned int)shift_right_9_v1(input9_v1, shift_v1)
            != expected_right_9_v1[i])
            abort();
    }

    input18_v1 = 0777777UL;
    for (i = 0; i < 18; ++i) {
        shift_v1 = i;
        pdp10_shift_case_v1++;
        if ((unsigned int)shift_left_18_v1(input18_v1, shift_v1)
            != expected_left_18_v1[i])
            abort();
        if ((unsigned int)shift_right_18_v1(input18_v1, shift_v1)
            != expected_right_18_v1[i])
            abort();
    }

    input36_v1 = 0777777777777UL;
    for (i = 0; i < 36; ++i) {
        shift_v1 = i;
        pdp10_shift_case_v1++;
        if ((unsigned int)shift_left_36_v1(input36_v1, shift_v1)
            != expected_left_36_v1[i])
            abort();
        if ((unsigned int)shift_right_36_v1(input36_v1, shift_v1)
            != expected_right_36_v1[i])
            abort();
    }

    if (pdp10_shift_case_v1 != 63)
        abort();
    return 0;
}
