#include "mixed-varargs-matrix-v30.h"

int
abi_va_matrix_v30(int tag, ...)
{
    __builtin_va_list ap;
    int q;
    int h;
    int71_t w;
    int *p;
    struct abi_va_pair_v30 pair;
    char *bp;
    int tail;

    ABI_VA_START_V30(ap, tag);
    q = ABI_VA_ARG_V30(ap, int);
    h = ABI_VA_ARG_V30(ap, int);
    w = ABI_VA_ARG_V30(ap, int71_t);
    p = ABI_VA_ARG_V30(ap, int *);
    pair = ABI_VA_ARG_V30(ap, struct abi_va_pair_v30);
    bp = ABI_VA_ARG_V30(ap, char *);
    tail = ABI_VA_ARG_V30(ap, int);
    ABI_VA_END_V30(ap);
    return tag + q + h + (int)w + *p + pair.a + pair.b + (int)*bp + tail;
}

int
abi_va_float_v30(int tag, ...)
{
    __builtin_va_list ap;
    Dfloat d;
    int tail;

    ABI_VA_START_V30(ap, tag);
    d = ABI_VA_ARG_V30(ap, Dfloat);
    tail = ABI_VA_ARG_V30(ap, int);
    ABI_VA_END_V30(ap);
    if (d != (Dfloat)2.0)
        return 100;
    return tag + 2 + tail;
}
