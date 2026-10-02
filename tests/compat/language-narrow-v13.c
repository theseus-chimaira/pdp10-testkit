#include "daimos-language-v1.h"

static int
check6(void)
{
    daimos_int6_t s[2];
    daimos_uint6_t u[2];
    s[0] = 037;
    s[1] = 040;
    u[0] = 077;
    u[1] = 0100;
    return s[0] == 037 && s[1] == -040 &&
           u[0] == 077 && u[1] == 0 && s[0] + 1 == 040;
}

static int
check7(void)
{
    daimos_int7_t s;
    daimos_uint7_t u;
    s = 0100;
    u = 0200;
    return s == -0100 && u == 0;
}

static int
check8(void)
{
    daimos_int8_t s;
    daimos_uint8_t u;
    s = 0200;
    u = 0400;
    return s == -0200 && u == 0;
}

static int
check9(void)
{
    daimos_int9_t s[2];
    daimos_uint9_t u[2];
    s[0] = 0377;
    s[1] = 0400;
    u[0] = 0777;
    u[1] = 01000;
    return s[0] == 0377 && s[1] == -0400 &&
           u[0] == 0777 && u[1] == 0;
}

static int
check18(void)
{
    daimos_int18_t s[2];
    daimos_uint18_t u[2];
    s[0] = 0377777;
    s[1] = 0400000;
    u[0] = 0777777;
    u[1] = 01000000;
    return s[0] == 0377777 && s[1] == -0400000 &&
           u[0] == 0777777 && u[1] == 0;
}

static int
check16_32(void)
{
    daimos_int16_t s16;
    daimos_uint16_t u16;
    daimos_int32_t s32;
    daimos_uint32_t u32;

    s16 = 0100000;
    u16 = 0200000;
    s32 = 020000000000;
    u32 = 040000000000;
    return s16 == -0100000 && u16 == 0 &&
           s32 == -020000000000 && u32 == 0;
}

int
main(void)
{
    if (!check6()) return 1;
    if (!check7()) return 2;
    if (!check8()) return 3;
    if (!check9()) return 4;
    if (!check18()) return 5;
    if (!DAIMOS_HAVE_EXACT_INT6 || !DAIMOS_HAVE_EXACT_INT18) return 6;
    if (!DAIMOS_HAVE_EXACT_INT16 || !DAIMOS_HAVE_EXACT_INT32) return 7;
    if (!check16_32()) return 8;
    return 0;
}
