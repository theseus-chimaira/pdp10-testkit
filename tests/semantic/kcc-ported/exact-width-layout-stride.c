/* Preserved regression source from exact-width-layout-stride.sh. */
volatile int __test_exit;
#include "pdp10-types.h"
typedef pdp10_int16_t s16;
typedef pdp10_int32_t s32;
struct p16 { s16 a, b; };
struct p32 { s32 a, b; };
int main(void)
{
    s16 a16[3];
    s32 a32[3];
    struct p16 q16;
    struct p32 q32;
    /* Exact value width is shared; C address-unit size is not. */
#if defined(__COMPILER_KCC__)
    if (sizeof(s16) != 1) return 1;
    if (sizeof(a16) != 3) return 2;
#elif defined(__GNUC__) && defined(__pdp10__)
    if (sizeof(s16) != 2) return 1;
    if (sizeof(a16) != 6) return 2;
#else
#error Unsupported PDP-10 compiler
#endif
    if (&a16[1] - &a16[0] != 1) return 3;
    if (&a16[2] - &a16[0] != 2) return 4;
    if (sizeof(s32) != 4) return 5;
    if (sizeof(a32) != 014) return 6;
    if (&a32[1] - &a32[0] != 1) return 7;
    if (&a32[2] - &a32[0] != 2) return 8;
    if (sizeof(q16) != 4) return 9;
    if (sizeof(q32) != 010) return 10;
    return 0;
}
