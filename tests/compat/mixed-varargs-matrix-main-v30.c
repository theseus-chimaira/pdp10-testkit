#include "mixed-varargs-matrix-v30.h"

static int marker_v30 = 5;

int
main(void)
{
    int9 q;
    int18 h;
    int71_t w;
    struct abi_va_pair_v30 pair;
    Sfloat f;
    static char bytes[2];

    q = 2;
    h = 3;
    w = 4;
    pair.a = 6;
    pair.b = 7;
    bytes[1] = 9;
    if (abi_va_matrix_v30(1, q, h, w, &marker_v30, pair, &bytes[1], 8) != 45)
        return 1;

    f = (Sfloat)2.0;
    if (abi_va_float_v30(1, f, 3) != 6)
        return 2;
    return 0;
}
