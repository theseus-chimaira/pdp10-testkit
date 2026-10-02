#include "insns.h"

/*
 * Signed/unsigned byte pointer conversion coverage.
 *
 * This is intentionally narrower than convert-pointer.c and
 * charp-conversion.c.  It stresses conversions that should keep the
 * same byte size while changing only signedness or the C pointed-to
 * type.  On the PDP-6/KA10 path this is especially interesting for
 * ordinary 9-bit char pointers and scalar-memory address forms.
 */

static int sink;

#define CONV_BAR(N, T, X) do { extern void bar(); bar ((T *)(X)); } while (0)

#define DECL_PAIR(N, T1, T2)                                            \
static T2 global_ ## N;                                                 \
static T2 array_ ## N[12];                                              \
static T2 *volatile volatile_from_ ## N;                                \
static T1 *volatile volatile_to_ ## N;                                  \
static T1 *init_ ## N = (T1 *)&global_ ## N

#define CALL_TESTS(N, T1, T2)                                           \
static void                                                            \
arg_ ## N (T2 *x)                                                       \
{                                                                       \
        CONV_BAR (N, T1, x);                                            \
}                                                                       \
                                                                        \
static void                                                            \
stack_ ## N (void)                                                      \
{                                                                       \
        T2 x;                                                           \
        CONV_BAR (N, T1, &x);                                           \
}                                                                       \
                                                                        \
static void                                                            \
global_call_ ## N (void)                                                \
{                                                                       \
        CONV_BAR (N, T1, &global_ ## N);                                \
}                                                                       \
                                                                        \
static void                                                            \
array_call_ ## N (int i)                                                \
{                                                                       \
        CONV_BAR (N, T1, &array_ ## N[i]);                              \
}

#define RETURN_TESTS(N, T1, T2)                                         \
static T1 *                                                            \
ret_arg_ ## N (T2 *x)                                                   \
{                                                                       \
        return (T1 *)x;                                                 \
}                                                                       \
                                                                        \
static T1 *                                                            \
ret_global_ ## N (void)                                                 \
{                                                                       \
        return (T1 *)&global_ ## N;                                     \
}                                                                       \
                                                                        \
static T1 *                                                            \
ret_array_ ## N (int i)                                                 \
{                                                                       \
        return (T1 *)&array_ ## N[i];                                   \
}                                                                       \
                                                                        \
static T2 *                                                            \
roundtrip_ ## N (T2 *x)                                                 \
{                                                                       \
        return (T2 *)(T1 *)x;                                           \
}                                                                       \
                                                                        \
static T1 *                                                            \
void_bridge_ ## N (T2 *x)                                               \
{                                                                       \
        void *v;                                                        \
        v = (void *)x;                                                  \
        return (T1 *)v;                                                 \
}

#define MEMORY_TESTS(N, T1, T2)                                         \
static int                                                             \
load_cast_ ## N (T2 *x)                                                 \
{                                                                       \
        T1 *p;                                                          \
        p = (T1 *)x;                                                    \
        return (int)*p;                                                 \
}                                                                       \
                                                                        \
static int                                                             \
load_global_ ## N (void)                                                \
{                                                                       \
        T1 *p;                                                          \
        p = (T1 *)&global_ ## N;                                        \
        return (int)*p;                                                 \
}                                                                       \
                                                                        \
static int                                                             \
load_index_ ## N (int i)                                                \
{                                                                       \
        T1 *p;                                                          \
        p = (T1 *)&array_ ## N[0];                                      \
        return (int)p[i];                                               \
}                                                                       \
                                                                        \
static void                                                            \
store_cast_ ## N (T2 *x, int y)                                         \
{                                                                       \
        T1 *p;                                                          \
        p = (T1 *)x;                                                    \
        *p = (T1)y;                                                     \
}                                                                       \
                                                                        \
static void                                                            \
store_index_ ## N (int i, int y)                                        \
{                                                                       \
        T1 *p;                                                          \
        p = (T1 *)&array_ ## N[0];                                      \
        p[i] = (T1)y;                                                   \
}

#define POINTER_TESTS(N, T1, T2)                                        \
static T1 *                                                            \
plus_one_ ## N (T2 *x)                                                  \
{                                                                       \
        return ((T1 *)x) + 1;                                           \
}                                                                       \
                                                                        \
static T1 *                                                            \
plus_index_ ## N (T2 *x, int i)                                         \
{                                                                       \
        return ((T1 *)x) + i;                                           \
}                                                                       \
                                                                        \
static int                                                             \
diff_const_ ## N (void)                                                 \
{                                                                       \
        T1 *a;                                                          \
        T1 *b;                                                          \
        a = (T1 *)&array_ ## N[9];                                      \
        b = (T1 *)&array_ ## N[2];                                      \
        return a - b;                                                   \
}                                                                       \
                                                                        \
static int                                                             \
diff_index_ ## N (int i, int j)                                         \
{                                                                       \
        T1 *a;                                                          \
        T1 *b;                                                          \
        a = (T1 *)&array_ ## N[i];                                      \
        b = (T1 *)&array_ ## N[j];                                      \
        return a - b;                                                   \
}                                                                       \
                                                                        \
static int                                                             \
compare_roundtrip_ ## N (T2 *x)                                         \
{                                                                       \
        return (T2 *)(T1 *)x == x;                                      \
}

#define VOLATILE_TESTS(N, T1, T2)                                       \
static T1 *                                                            \
volatile_reload_ ## N (T2 *x)                                           \
{                                                                       \
        volatile_from_ ## N = x;                                        \
        volatile_to_ ## N = (T1 *)volatile_from_ ## N;                  \
        return volatile_to_ ## N;                                       \
}                                                                       \
                                                                        \
static int                                                             \
use_all_ ## N (T2 *x, int i, int y)                                     \
{                                                                       \
        T1 *p;                                                          \
        T2 *q;                                                          \
        p = volatile_reload_ ## N (x);                                  \
        q = roundtrip_ ## N (x);                                        \
        store_cast_ ## N (q, y);                                        \
        store_index_ ## N (i, y + 1);                                   \
        sink += load_cast_ ## N (q);                                    \
        sink += load_global_ ## N ();                                   \
        sink += load_index_ ## N (i);                                   \
        sink += diff_const_ ## N ();                                    \
        sink += diff_index_ ## N (i, 1);                                \
        sink += compare_roundtrip_ ## N (x);                            \
        return (int)*p + sink;                                          \
}

#define TEST(N, T1, T2)                                                 \
DECL_PAIR(N, T1, T2);                                                   \
CALL_TESTS(N, T1, T2)                                                   \
RETURN_TESTS(N, T1, T2)                                                 \
MEMORY_TESTS(N, T1, T2)                                                 \
POINTER_TESTS(N, T1, T2)                                                \
VOLATILE_TESTS(N, T1, T2)

/* Original four ordinary-char signedness directions. */
TEST (cc,  char,          char)
TEST (uc,  unsigned char, char)
TEST (cu,  char,          unsigned char)
TEST (uu,  unsigned char, unsigned char)

/* Make signed-char explicit; plain char signedness is target policy. */
TEST (sc_c,  signed char,   char)
TEST (c_sc,  char,          signed char)
TEST (sc_uc, signed char,   unsigned char)
TEST (uc_sc, unsigned char, signed char)
TEST (sc_sc, signed char,   signed char)

/* Explicit PDP-10 9-bit byte typedefs: same size, different type. */
TEST (c9_u9,  char9,  uchar9)
TEST (u9_c9,  uchar9, char9)
TEST (c_c9,   char,   char9)
TEST (u_u9,   unsigned char, uchar9)
TEST (c9_c,   char9,  char)
TEST (u9_u,   uchar9, unsigned char)
