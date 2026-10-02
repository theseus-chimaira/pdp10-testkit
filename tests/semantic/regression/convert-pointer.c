#include "insns.h"

/*
 * Generic pointer conversion coverage.
 *
 * This file is intentionally broader than charp-conversion.c.  It keeps
 * the old call-through forms, but also checks return values, global and
 * stack object addresses, void * bridges, round trips, stores, loads, and
 * pointer comparisons.
 */

extern void clobber (void);

static char g_char;
static signed char g_schar;
static unsigned char g_uchar;
static short g_short;
static unsigned short g_ushort;
static int g_int;
static unsigned int g_uint;
static Qint g_qint;
static uQint g_uqint;
static Hint g_hint;
static uHint g_uhint;
static Sint g_sint;
static uSint g_usint;
static char6 g_char6;
static uchar6 g_uchar6;
static char7 g_char7;
static uchar7 g_uchar7;
static char8 g_char8;
static uchar8 g_uchar8;
static char9 g_char9;
static uchar9 g_uchar9;
static short16 g_short16;
static ushort16 g_ushort16;
static short18 g_short18;
static ushort18 g_ushort18;
static int32 g_int32;
static uint32 g_uint32;

static void *vp_sink;
static int cmp_sink;

#define CONV_BAR(N, T, X) do { extern void bar(); bar ((T *)(X)); } while (0)

#define TEST(N, T1, T2)                         \
static void                                     \
arg##N (T2 *x)                                  \
{                                               \
        CONV_BAR (N, T1, x);                    \
}                                               \
static void                                     \
stack##N (void)                                 \
{                                               \
        T2 x;                                   \
        CONV_BAR (N, T1, &x);                   \
}                                               \
static void                                     \
global##N (void)                                \
{                                               \
        static T2 x;                            \
        CONV_BAR (N, T1, &x);                   \
}                                               \
static T1 *                                     \
ret##N (T2 *x)                                  \
{                                               \
        return (T1 *)x;                         \
}                                               \
static T2 *                                     \
round##N (T2 *x)                                \
{                                               \
        return (T2 *)(T1 *)x;                   \
}                                               \
static T1 *                                     \
voidret##N (T2 *x)                              \
{                                               \
        void *v;                                \
        v = (void *)x;                          \
        clobber ();                             \
        return (T1 *)v;                         \
}                                               \
static void                                     \
save##N (T2 *x)                                 \
{                                               \
        static T1 *p;                           \
        p = (T1 *)x;                            \
        vp_sink = (void *)p;                    \
}                                               \
static int                                      \
cmp##N (T2 *x, T1 *y)                           \
{                                               \
        return (T1 *)x == y;                    \
}                                               \
static int                                      \
diff##N (T2 *x, T1 *y)                          \
{                                               \
        return (T1 *)x - y;                     \
}                                               \
static T1                                       \
load##N (T2 *x)                                 \
{                                               \
        return *((T1 *)x);                      \
}                                               \
static void                                     \
store##N (T2 *x, T1 y)                          \
{                                               \
        *((T1 *)x) = y;                         \
}

#define TEST9(N, T1, T2)                        \
        TEST (N##__, T1, T2)                    \
        TEST (N##s_, signed T1, T2)             \
        TEST (N##u_, unsigned T1, T2)           \
        TEST (N##_s, T1, signed T2)             \
        TEST (N##ss, signed T1, signed T2)      \
        TEST (N##us, unsigned T1, signed T2)    \
        TEST (N##_u, T1, unsigned T2)           \
        TEST (N##su, signed T1, unsigned T2)    \
        TEST (N##uu, unsigned T1, unsigned T2)

/* Original built-in scalar families. */
TEST9 (1, char, char)
TEST9 (2, short, short)
TEST9 (3, int, int)

/* Cross-size built-in scalar pointer conversions. */
TEST (char_short, char, short)
TEST (char_int, char, int)
TEST (short_char, short, char)
TEST (short_int, short, int)
TEST (int_char, int, char)
TEST (int_short, int, short)
TEST (uchar_uint, unsigned char, unsigned int)
TEST (uint_uchar, unsigned int, unsigned char)
TEST (schar_sint, signed char, int)
TEST (sint_schar, int, signed char)

/* GCC machine-mode scalar typedefs. */
TEST (qint_hint, Qint, Hint)
TEST (qint_sint, Qint, Sint)
TEST (hint_qint, Hint, Qint)
TEST (hint_sint, Hint, Sint)
TEST (sint_qint, Sint, Qint)
TEST (sint_hint, Sint, Hint)
TEST (uqint_uhint, uQint, uHint)
TEST (uqint_usint, uQint, uSint)
TEST (uhint_uqint, uHint, uQint)
TEST (uhint_usint, uHint, uSint)
TEST (usint_uqint, uSint, uQint)
TEST (usint_uhint, uSint, uHint)

/* Packed byte-size typedefs. */
TEST (c6_c7, char6, char7)
TEST (c6_c8, char6, char8)
TEST (c6_c9, char6, char9)
TEST (c6_ch, char6, char)
TEST (c7_c6, char7, char6)
TEST (c7_c8, char7, char8)
TEST (c7_c9, char7, char9)
TEST (c7_ch, char7, char)
TEST (c8_c6, char8, char6)
TEST (c8_c7, char8, char7)
TEST (c8_c9, char8, char9)
TEST (c8_ch, char8, char)
TEST (c9_c6, char9, char6)
TEST (c9_c7, char9, char7)
TEST (c9_c8, char9, char8)
TEST (c9_ch, char9, char)
TEST (ch_c6, char, char6)
TEST (ch_c7, char, char7)
TEST (ch_c8, char, char8)
TEST (ch_c9, char, char9)

/* Unsigned packed byte-size typedefs. */
TEST (uc6_uc7, uchar6, uchar7)
TEST (uc6_uc8, uchar6, uchar8)
TEST (uc6_uc9, uchar6, uchar9)
TEST (uc6_uch, uchar6, unsigned char)
TEST (uc7_uc6, uchar7, uchar6)
TEST (uc7_uc8, uchar7, uchar8)
TEST (uc7_uc9, uchar7, uchar9)
TEST (uc7_uch, uchar7, unsigned char)
TEST (uc8_uc6, uchar8, uchar6)
TEST (uc8_uc7, uchar8, uchar7)
TEST (uc8_uc9, uchar8, uchar9)
TEST (uc8_uch, uchar8, unsigned char)
TEST (uc9_uc6, uchar9, uchar6)
TEST (uc9_uc7, uchar9, uchar7)
TEST (uc9_uc8, uchar9, uchar8)
TEST (uc9_uch, uchar9, unsigned char)
TEST (uch_uc6, unsigned char, uchar6)
TEST (uch_uc7, unsigned char, uchar7)
TEST (uch_uc8, unsigned char, uchar8)
TEST (uch_uc9, unsigned char, uchar9)

/* Halfword-ish and 32-bit scalar pointer conversions. */
TEST (s16_s18, short16, short18)
TEST (s18_s16, short18, short16)
TEST (s16_hint, short16, Hint)
TEST (hint_s16, Hint, short16)
TEST (s18_hint, short18, Hint)
TEST (hint_s18, Hint, short18)
TEST (us16_us18, ushort16, ushort18)
TEST (us18_us16, ushort18, ushort16)
TEST (i32_sint, int32, Sint)
TEST (sint_i32, Sint, int32)
TEST (ui32_usint, uint32, uSint)
TEST (usint_ui32, uSint, uint32)

static void
use_globals (void)
{
        arg1__ (&g_char);
        arg1s_ (&g_char);
        arg1u_ (&g_char);
        arg1_s (&g_schar);
        arg1_u (&g_uchar);
        arg2__ (&g_short);
        arg2_u (&g_ushort);
        arg3__ (&g_int);
        arg3_u (&g_uint);
        argqint_hint (&g_hint);
        arguqint_uhint (&g_uhint);
        argc6_c7 (&g_char7);
        argc8_c9 (&g_char9);
        arguc6_uc7 (&g_uchar7);
        arguc8_uc9 (&g_uchar9);
        args16_s18 (&g_short18);
        argus16_us18 (&g_ushort18);
        argi32_sint (&g_sint);
        argui32_usint (&g_usint);
}

static int
use_returns (int n)
{
        char *cp;
        short *sp;
        int *ip;
        char6 *c6p;
        char7 *c7p;
        char8 *c8p;
        char9 *c9p;
        short18 *h18p;
        int32 *i32p;

        cp = retch_c9 (&g_char9);
        sp = retshort_char (&g_char);
        ip = retint_short (&g_short);
        c6p = retc6_c9 (&g_char9);
        c7p = retc7_c6 (&g_char6);
        c8p = retc8_c9 (&g_char9);
        c9p = retc9_c8 (&g_char8);
        h18p = rets18_s16 (&g_short16);
        i32p = reti32_sint (&g_sint);

        cmp_sink = cmpch_c9 (&g_char9, cp)
            + cmpshort_char (&g_char, sp)
            + cmpint_short (&g_short, ip)
            + cmpc6_c9 (&g_char9, c6p)
            + cmpc7_c6 (&g_char6, c7p)
            + cmpc8_c9 (&g_char9, c8p)
            + cmpc9_c8 (&g_char8, c9p)
            + cmps18_s16 (&g_short16, h18p)
            + cmpi32_sint (&g_sint, i32p);

        return cmp_sink + n;
}

static int
use_load_store (int n)
{
        store1__ (&g_char, (char)n);
        store2__ (&g_short, (short)n);
        store3__ (&g_int, n);
        storeqint_hint (&g_hint, (Qint)n);
        storehint_sint (&g_sint, (Hint)n);
        storesint_hint (&g_hint, (Sint)n);
        storec6_c9 (&g_char9, (char6)n);
        storec7_c6 (&g_char6, (char7)n);
        storec8_c9 (&g_char9, (char8)n);
        storec9_c8 (&g_char8, (char9)n);
        storeuc6_uc9 (&g_uchar9, (uchar6)n);
        storeuc8_uc7 (&g_uchar7, (uchar8)n);
        stores16_s18 (&g_short18, (short16)n);
        storeus16_us18 (&g_ushort18, (ushort16)n);
        storei32_sint (&g_sint, (int32)n);

        return (int)load1__ (&g_char)
            + (int)load2__ (&g_short)
            + (int)load3__ (&g_int)
            + (int)loadqint_hint (&g_hint)
            + (int)loadhint_sint (&g_sint)
            + (int)loadsint_hint (&g_hint)
            + (int)loadc6_c9 (&g_char9)
            + (int)loadc7_c6 (&g_char6)
            + (int)loadc8_c9 (&g_char9)
            + (int)loadc9_c8 (&g_char8)
            + (int)loaduc6_uc9 (&g_uchar9)
            + (int)loaduc8_uc7 (&g_uchar7)
            + (int)loads16_s18 (&g_short18)
            + (int)loadus16_us18 (&g_ushort18)
            + (int)loadi32_sint (&g_sint);
}

static int
use_diffs (void)
{
        return diff1__ (&g_char, &g_char)
            + diff2__ (&g_short, &g_short)
            + diff3__ (&g_int, &g_int)
            + diffc6_c9 (&g_char9, (char6 *)&g_char9)
            + diffc7_c6 (&g_char6, (char7 *)&g_char6)
            + diffc8_c9 (&g_char9, (char8 *)&g_char9)
            + diffc9_c8 (&g_char8, (char9 *)&g_char8)
            + diffs16_s18 (&g_short18, (short16 *)&g_short18)
            + diffi32_sint (&g_sint, (int32 *)&g_sint);
}

static int
use_convert_pointer (int n)
{
        use_globals ();
        save1__ (&g_char);
        save2__ (&g_short);
        save3__ (&g_int);
        savec6_c9 (&g_char9);
        savec7_c6 (&g_char6);
        savec8_c9 (&g_char9);
        savec9_c8 (&g_char8);
        saves16_s18 (&g_short18);
        savei32_sint (&g_sint);
        return use_returns (n) + use_load_store (n) + use_diffs ();
}
