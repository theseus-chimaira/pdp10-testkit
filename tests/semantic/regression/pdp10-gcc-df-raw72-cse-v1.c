#include "insns.h"

/* CSE must preserve both 36-bit words when reinterpreting a constant
   PDP-10 D-format double as two integer words.  An incorrect 64-bit
   conversion loses high bits even when the DF runtime helper is correct.
   This is a freestanding C89 test with no substitute library helpers.  */

extern Dfloat __negdf2(Dfloat);

volatile uSint observed_hi_v1;
volatile uSint observed_lo_v1;

int
main(void)
{
    union {
        Dfloat d;
        uSint w[2];
    } actual, expected;

    actual.d = __negdf2((Dfloat)1.5);
    expected.d = (Dfloat)-1.5;
    observed_hi_v1 = actual.w[0];
    observed_lo_v1 = actual.w[1];

    if (actual.w[0] != expected.w[0]
        || actual.w[1] != expected.w[1])
        return 1;
    if (actual.w[0] != (uSint)0576200000000UL
        || actual.w[1] != (uSint)0400000000000UL)
        return 2;

    actual.d = (Dfloat)1.5;
    if (actual.w[0] != (uSint)0201600000000UL
        || actual.w[1] != (uSint)0)
        return 3;

    return 0;
}
