#include "mixed-layout-edge-v31.h"

static int
check_edge(struct abi_edge_v31 e)
{
    if (e.a != 012345)
        return 1;
    if (e.b != -37)
        return 2;
    if (*e.p != 23)
        return 3;
    if (e.c != 054321)
        return 4;
    if (e.d != 023456)
        return 5;
    return 0;
}

static int
check_outer(struct abi_outer_v31 o)
{
    if (o.lead != 3 || o.v[0].a != 5 || o.v[0].b != 7 || o.v[0].c != 9)
        return 10;
    if (o.v[1].a != 11 || o.v[1].b != 13 || o.v[1].c != 15)
        return 11;
    if (*o.p != 29 || o.tail != 17)
        return 12;
    return 0;
}

int
abi_check_layout_v31(struct abi_edge_v31 e, struct abi_outer_v31 o)
{
    int r;
    r = check_edge(e);
    if (r != 0)
        return r;
    return check_outer(o);
}

int
abi_check_globals_v31(void)
{
    int r;
    r = check_edge(abi_edge_global_v31);
    if (r != 0)
        return r + 20;
    r = check_outer(abi_outer_global_v31);
    if (r != 0)
        return r + 20;
    return 0;
}
