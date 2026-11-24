#include "pdp10-types.h"

static int
check_signed(void)
{
    pdp10_int6_t a;
    pdp10_int9_t b;
    pdp10_int18_t c;

    a = PDP10_INT6_MAX;
    b = PDP10_INT9_MIN;
    c = PDP10_INT18_MAX;
    return a + 1 == 040 && b - 1 == -0401 && c + 1 == 0400000;
}

static int
check_unsigned(void)
{
    pdp10_uint6_t a;
    pdp10_uint9_t b;
    pdp10_uint18_t c;

    a = PDP10_UINT6_MAX;
    b = PDP10_UINT9_MAX;
    c = PDP10_UINT18_MAX;
    return a + 1 == 0100 && b + 1 == 01000 && c + 1 == 01000000;
}

static int
check_mixed(void)
{
    pdp10_int9_t s;
    pdp10_uint9_t u;
    int word;

    s = -1;
    u = 1;
    word = 2;
    return s + word == 1 && u + word == 3 && s < u;
}

static int
check_constants(void)
{
    return PDP10_INT6_C(037) == PDP10_INT6_MAX &&
           PDP10_UINT9_C(0777) == PDP10_UINT9_MAX &&
           PDP10_INT18_MIN == -0400000;
}

int
main(void)
{
    if (!check_signed()) return 1;
    if (!check_unsigned()) return 2;
    if (!check_mixed()) return 3;
    if (!check_constants()) return 4;
    return 0;
}
