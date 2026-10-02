#include "insns.h"

/*
 * Scalar memory form coverage.
 *
 * This test checks the ordinary C shapes that should be recognized as
 * scalar memory accesses on PDP-6/KA10: direct globals, volatile
 * globals, struct fields, arrays, pointer loads/stores, and assignment
 * expressions.  It deliberately covers the non-word scalar sizes that
 * matter for PDP-10 C: packed bytes, 16/18-bit halfword-like objects,
 * 32-bit objects, and full 36-bit controls.
 *
 * This is not a byte-pointer arithmetic test.  The goal here is to make
 * sure scalar objects in memory keep the right representation and that
 * loads/stores do not require hand-written extraction code.
 */

typedef char native_char;
typedef signed char native_schar;
typedef unsigned char native_uchar;


#define TEST(T, N)                                                     \
static T s_##N;                                                   \
static volatile T vs_##N;                                         \
static struct st_##N { T x; T y; } st_##N;                     \
static volatile struct vst_##N { T x; T y; } vst_##N;          \
static T a_##N[8];                                                 \
static volatile T va_##N[8];                                       \
static T *ps_##N = &s_##N;                                \
static T *pa_##N = &a_##N[3];                               \
static volatile T *vps_##N = &vs_##N;                     \
static T                                                               \
ls_##N(void)                                                    \
{                                                                      \
        return s_##N;                                             \
}                                                                      \
static void                                                            \
ss_##N(x)                                                       \
T x;                                                                   \
{                                                                      \
        s_##N = x;                                                \
}                                                                      \
static T                                                               \
ssr_##N(x)                                                   \
T x;                                                                   \
{                                                                      \
        return s_##N = x;                                         \
}                                                                      \
static T                                                               \
lv_##N(void)                                                  \
{                                                                      \
        return vs_##N;                                            \
}                                                                      \
static void                                                            \
sv_##N(x)                                                     \
T x;                                                                   \
{                                                                      \
        vs_##N = x;                                               \
}                                                                      \
static T                                                               \
lst_##N(void)                                                    \
{                                                                      \
        return st_##N.x;                                           \
}                                                                      \
static T                                                               \
lsy_##N(void)                                                  \
{                                                                      \
        return st_##N.y;                                           \
}                                                                      \
static void                                                            \
sst_##N(x)                                                       \
T x;                                                                   \
{                                                                      \
        st_##N.x = x;                                              \
}                                                                      \
static T                                                               \
sstr_##N(x)                                                   \
T x;                                                                   \
{                                                                      \
        return st_##N.y = x;                                       \
}                                                                      \
static T                                                               \
lvs_##N(void)                                                   \
{                                                                      \
        return vst_##N.x;                                          \
}                                                                      \
static void                                                            \
svs_##N(x)                                                      \
T x;                                                                   \
{                                                                      \
        vst_##N.y = x;                                             \
}                                                                      \
static T                                                               \
la_##N(void)                                                     \
{                                                                      \
        return a_##N[0];                                           \
}                                                                      \
static void                                                            \
sa_##N(x)                                                        \
T x;                                                                   \
{                                                                      \
        a_##N[0] = x;                                              \
}                                                                      \
static T                                                               \
lai_##N(i)                                                  \
int i;                                                                 \
{                                                                      \
        return a_##N[i];                                           \
}                                                                      \
static void                                                            \
sai_##N(i, x)                                               \
int i;                                                                 \
T x;                                                                   \
{                                                                      \
        a_##N[i] = x;                                              \
}                                                                      \
static T                                                               \
lvi_##N(i)                                                 \
int i;                                                                 \
{                                                                      \
        return va_##N[i];                                          \
}                                                                      \
static void                                                            \
svi_##N(i, x)                                              \
int i;                                                                 \
T x;                                                                   \
{                                                                      \
        va_##N[i] = x;                                             \
}                                                                      \
static T                                                               \
lp_##N(x)                                                      \
T *x;                                                                  \
{                                                                      \
        return *x;                                                     \
}                                                                      \
static void                                                            \
sp_##N(x, y)                                                   \
T *x;                                                                  \
T y;                                                                   \
{                                                                      \
        *x = y;                                                        \
}                                                                      \
static T                                                               \
spr_##N(x, y)                                               \
T *x;                                                                  \
T y;                                                                   \
{                                                                      \
        return *x = y;                                                 \
}                                                                      \
static T                                                               \
lpi_##N(x, i)                                             \
T *x;                                                                  \
int i;                                                                 \
{                                                                      \
        return x[i];                                                   \
}                                                                      \
static void                                                            \
spi_##N(x, i, y)                                          \
T *x;                                                                  \
int i;                                                                 \
T y;                                                                   \
{                                                                      \
        x[i] = y;                                                      \
}                                                                      \
static T                                                               \
lgp_##N(void)                                            \
{                                                                      \
        return *ps_##N;                                        \
}                                                                      \
static T                                                               \
lgap_##N(void)                                      \
{                                                                      \
        return *pa_##N;                                         \
}                                                                      \
static T                                                               \
lgvp_##N(void)                                   \
{                                                                      \
        return *vps_##N;                                       \
}                                                                      \
static void                                                            \
sgp_##N(x)                                               \
T x;                                                                   \
{                                                                      \
        *ps_##N = x;                                           \
}                                                                      \
static T                                                               \
prp_##N(p)                                                  \
T *p;                                                                  \
{                                                                      \
        ++p;                                                           \
        return *p;                                                     \
}                                                                      \
static T                                                               \
pip_##N(p)                                                 \
T *p;                                                                  \
{                                                                      \
        T x;                                                           \
        x = *p++;                                                      \
        return (T)(x + *p);                                            \
}                                                                      \
static T                                                               \
us_##N(x)                                                   \
T x;                                                                   \
{                                                                      \
        s_##N = (T)(s_##N + x);                              \
        return s_##N;                                             \
}                                                                      \
static T                                                               \
ust_##N(x)                                                   \
T x;                                                                   \
{                                                                      \
        st_##N.x = (T)(st_##N.x + x);                          \
        st_##N.y = (T)(st_##N.y - x);                          \
        return (T)(st_##N.x + st_##N.y);                       \
}                                                                      \
static T                                                               \
use_##N(x, i)                                                   \
T x;                                                                   \
int i;                                                                 \
{                                                                      \
        T y;                                                           \
        i &= 7;                                                        \
        ss_##N(x);                                              \
        sv_##N((T)(x + 1));                                   \
        sst_##N((T)(x + 2));                                     \
        svs_##N((T)(x + 3));                                    \
        sa_##N((T)(x + 4));                                      \
        sai_##N(i, (T)(x + 5));                             \
        svi_##N(i, (T)(x + 6));                            \
        sp_##N(&a_##N[1], (T)(x + 7));                     \
        spi_##N(a_##N, i, (T)(x + 8));                \
        sgp_##N((T)(x + 9));                             \
        y = ssr_##N(x);                                      \
        y = (T)(y + sstr_##N((T)(x + 10)));                   \
        y = (T)(y + spr_##N(&a_##N[2], (T)(x + 11)));   \
        y = (T)(y + ls_##N());                                  \
        y = (T)(y + lv_##N());                                \
        y = (T)(y + lst_##N());                                  \
        y = (T)(y + lsy_##N());                                \
        y = (T)(y + lvs_##N());                                 \
        y = (T)(y + la_##N());                                   \
        y = (T)(y + lai_##N(i));                            \
        y = (T)(y + lvi_##N(i));                           \
        y = (T)(y + lp_##N(&a_##N[1]));                    \
        y = (T)(y + lpi_##N(a_##N, i));               \
        y = (T)(y + lgp_##N());                          \
        y = (T)(y + lgap_##N());                    \
        y = (T)(y + lgvp_##N());                 \
        y = (T)(y + prp_##N(a_##N));                    \
        y = (T)(y + pip_##N(a_##N));                   \
        y = (T)(y + us_##N(x));                             \
        y = (T)(y + ust_##N(x));                             \
        return y;                                                      \
}

TEST(native_char, native_char)
TEST(native_schar, native_schar)
TEST(native_uchar, native_uchar)
TEST(Qint, Qint)
TEST(sQint, sQint)
TEST(uQint, uQint)
TEST(Hint, Hint)
TEST(uHint, uHint)
TEST(Sint, Sint)
TEST(uSint, uSint)
TEST(char6, char6)
TEST(uchar6, uchar6)
TEST(char7, char7)
TEST(uchar7, uchar7)
TEST(char8, char8)
TEST(uchar8, uchar8)
TEST(char9, char9)
TEST(uchar9, uchar9)
TEST(short16, short16)
TEST(ushort16, ushort16)
TEST(short18, short18)
TEST(ushort18, ushort18)
TEST(int32, int32)
TEST(uint32, uint32)
TEST(int36, int36)
TEST(uint36, uint36)

Sint
use_memory_forms(x, i)
Sint x;
int i;
{
        Sint sum;

        sum = 0;
        sum += (Sint)use_native_char((native_char)x, i);
        sum += (Sint)use_native_schar((native_schar)x, i);
        sum += (Sint)use_native_uchar((native_uchar)x, i);
        sum += (Sint)use_Qint((Qint)x, i);
        sum += (Sint)use_sQint((sQint)x, i);
        sum += (Sint)use_uQint((uQint)x, i);
        sum += (Sint)use_Hint((Hint)x, i);
        sum += (Sint)use_uHint((uHint)x, i);
        sum += (Sint)use_Sint((Sint)x, i);
        sum += (Sint)use_uSint((uSint)x, i);
        sum += (Sint)use_char6((char6)x, i);
        sum += (Sint)use_uchar6((uchar6)x, i);
        sum += (Sint)use_char7((char7)x, i);
        sum += (Sint)use_uchar7((uchar7)x, i);
        sum += (Sint)use_char8((char8)x, i);
        sum += (Sint)use_uchar8((uchar8)x, i);
        sum += (Sint)use_char9((char9)x, i);
        sum += (Sint)use_uchar9((uchar9)x, i);
        sum += (Sint)use_short16((short16)x, i);
        sum += (Sint)use_ushort16((ushort16)x, i);
        sum += (Sint)use_short18((short18)x, i);
        sum += (Sint)use_ushort18((ushort18)x, i);
        sum += (Sint)use_int32((int32)x, i);
        sum += (Sint)use_uint32((uint32)x, i);
        sum += (Sint)use_int36((int36)x, i);
        sum += (Sint)use_uint36((uint36)x, i);
        return sum;
}
