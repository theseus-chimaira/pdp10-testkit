#include "mixed-layout-edge-v31.h"

struct abi_edge_v31 abi_edge_global_v31;
struct abi_outer_v31 abi_outer_global_v31;

int
main(void)
{
    static int pv = 23;
    static int qv = 29;
    struct abi_edge_v31 e;
    struct abi_outer_v31 o;

    e.a = 012345;
    e.b = -37;
    e.p = &pv;
    e.c = 054321;
    e.d = 023456;

    o.lead = 3;
    o.v[0].a = 5;
    o.v[0].b = 7;
    o.v[0].c = 9;
    o.v[1].a = 11;
    o.v[1].b = 13;
    o.v[1].c = 15;
    o.p = &qv;
    o.tail = 17;

    abi_edge_global_v31 = e;
    abi_outer_global_v31 = o;

    if (abi_check_layout_v31(e, o) != 0)
        return 1;
    if (abi_check_globals_v31() != 0)
        return 2;
    return 0;
}
