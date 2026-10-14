#include "insns.h"

/*
 * libgcc_helper_ownership_int.c - direct ownership probe for integer helpers.
 *
 * This test deliberately calls public helper symbols.  The GCC semantic
 * runtime must obtain them from gcc/config/pdp10/libgcc1.s via
 * p10run --libgcc1.  No testkit-local fallback is allowed to satisfy these
 * names.
 */

volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

extern void __main(void);
extern uSint __udivsi3(uSint, uSint);
extern uSint __umodsi3(uSint, uSint);

static int
check_u(g, e, id)
uSint g;
uSint e;
int id;
{
    if (g != e) {
        fail_id = id;
        got = (int)g;
        return 0;
    }
    return 1;
}

int
main()
{
    uSint q;
    uSint r;

    fail_id = 0;
    got = 0;
    got1 = 0;
    got2 = 0;
    got3 = 0;
    got4 = 0;
    got5 = 0;

    __main();

    q = __udivsi3((uSint)12345U, (uSint)10U);
    if (!check_u(q, (uSint)1234U, 1))
        return 1;
    got1 = (int)q;

    r = __umodsi3((uSint)12345U, (uSint)10U);
    if (!check_u(r, (uSint)5U, 2))
        return 1;
    got2 = (int)r;

    q = __udivsi3((uSint)0400000000001U, (uSint)3U);
    if (!check_u(q, (uSint)0125252525253U, 3))
        return 1;
    got3 = (int)q;

    r = __umodsi3((uSint)0777777777777U, (uSint)0100U);
    if (!check_u(r, (uSint)077U, 4))
        return 1;
    got4 = (int)r;

    q = __udivsi3((uSint)0500000000000U, (uSint)010U);
    if (!check_u(q, (uSint)0050000000000U, 5))
        return 1;
    got5 = (int)q;

    return 0;
}
