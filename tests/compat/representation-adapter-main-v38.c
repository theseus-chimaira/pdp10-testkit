#include "representation-adapter-v38.h"

int
main(void)
{
    raw72_t a;
    raw72_t r;

    if (ai16v38(0177777) != -1)
        return 1;
    if (au16v38(0200001U) != 1U)
        return 2;
    if (ai18v38(0777777) != -1)
        return 3;
    if (au18v38(01000001U) != 1U)
        return 4;

    a.hi = 0123456U;
    a.lo = 0654321U;
    r = ar72v38(a);
    if (r.hi != 0654321U || r.lo != 0123456U)
        return 5;

    return 0;
}
