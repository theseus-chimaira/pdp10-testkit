#include "daimos-language-v1.h"

typedef long long daimos_int71_t;
typedef unsigned long long daimos_uint71_t;

static int
check_word_to_wide(void)
{
    int s;
    unsigned int u;
    daimos_int71_t ws;
    daimos_uint71_t wu;

    s = -1;
    u = 0377777777777U;
    ws = (daimos_int71_t)s;
    wu = (daimos_uint71_t)u;
    if (ws != (daimos_int71_t)-1) return 0;
    return wu == (daimos_uint71_t)0377777777777U;
}

static int
check_narrow_to_wide(void)
{
    daimos_int6_t s6;
    daimos_uint6_t u6;
    daimos_int18_t s18;
    daimos_uint18_t u18;

    s6 = -040;
    u6 = 077;
    s18 = -0400000;
    u18 = 0777777;
    return (daimos_int71_t)s6 == (daimos_int71_t)-040 &&
           (daimos_uint71_t)u6 == (daimos_uint71_t)077 &&
           (daimos_int71_t)s18 == (daimos_int71_t)-0400000 &&
           (daimos_uint71_t)u18 == (daimos_uint71_t)0777777;
}

static int
check_wide_to_word_in_range(void)
{
    daimos_int71_t s;
    daimos_uint71_t u;

    s = (daimos_int71_t)-1234567;
    u = (daimos_uint71_t)07654321U;
    if ((int)s != -1234567) return 0;
    return (unsigned int)u == 07654321U;
}

static int
check_round_trip(void)
{
    daimos_int71_t a;
    daimos_uint71_t b;

    a = (daimos_int71_t)-1234567;
    b = (daimos_uint71_t)07654321U;
    return (daimos_int71_t)(int)a == a &&
           (daimos_uint71_t)(unsigned int)b == b;
}

int
main(void)
{
    if (!check_word_to_wide()) return 1;
    if (!check_narrow_to_wide()) return 2;
    if (!check_wide_to_word_in_range()) return 3;
    if (!check_round_trip()) return 4;
    return 0;
}
