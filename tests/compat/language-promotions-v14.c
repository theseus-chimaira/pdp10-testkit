#include "daimos-language-v1.h"

static int
check_signed(void)
{
    daimos_int6_t a;
    daimos_int9_t b;
    daimos_int18_t c;

    a = DAIMOS_INT6_MAX;
    b = DAIMOS_INT9_MIN;
    c = DAIMOS_INT18_MAX;
    return a + 1 == 040 && b - 1 == -0401 && c + 1 == 0400000;
}

static int
check_unsigned(void)
{
    daimos_uint6_t a;
    daimos_uint9_t b;
    daimos_uint18_t c;

    a = DAIMOS_UINT6_MAX;
    b = DAIMOS_UINT9_MAX;
    c = DAIMOS_UINT18_MAX;
    return a + 1 == 0100 && b + 1 == 01000 && c + 1 == 01000000;
}

static int
check_mixed(void)
{
    daimos_int9_t s;
    daimos_uint9_t u;
    int word;

    s = -1;
    u = 1;
    word = 2;
    return s + word == 1 && u + word == 3 && s < u;
}

static int
check_constants(void)
{
    return DAIMOS_INT6_C(037) == DAIMOS_INT6_MAX &&
           DAIMOS_UINT9_C(0777) == DAIMOS_UINT9_MAX &&
           DAIMOS_INT18_MIN == -0400000;
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
