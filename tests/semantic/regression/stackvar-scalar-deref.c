#include "insns.h"

/*
 * Stack scalar dereference coverage.
 *
 * This is deliberately narrower than stackvar-pointers.c.  It checks
 * the forms where the compiler first takes the address of a stack
 * scalar, then immediately or indirectly dereferences that address.
 * These are easy to miscompile on PDP-10 because subword stack locals
 * need the correct byte-pointer or halfword address form even when the
 * expression looks like a no-op in C.
 */

typedef signed char schar;
typedef unsigned char uchar;


extern void svsesc();
extern void svsuse();


#define DECL_STACK_SCALAR_DEREF(T)                                      \
static T sk_##T;                                                       \
static volatile T vsk_##T;                                             \
struct svst_##T {                                             \
        T a;                                                             \
        T b;                                                             \
};                                                                       \
static T                                                                 \
dd_##T(x)                                                      \
int x;                                                                   \
{                                                                        \
        T a;                                                             \
                                                                         \
        a = (T)x;                                                        \
        sk_##T = *&a;                                                  \
        return sk_##T;                                                 \
}                                                                        \
static T                                                                 \
dvl_##T(x)                                              \
int x;                                                                   \
{                                                                        \
        volatile T a;                                                    \
                                                                         \
        a = (T)x;                                                        \
        sk_##T = *&a;                                                  \
        return sk_##T;                                                 \
}                                                                        \
static T                                                                 \
dp_##T(x)                                                     \
int x;                                                                   \
{                                                                        \
        T a;                                                             \
        T *p;                                                            \
                                                                         \
        a = (T)x;                                                        \
        p = &a;                                                          \
        sk_##T = *p;                                                   \
        return sk_##T;                                                 \
}                                                                        \
static T                                                                 \
dvps_##T(x)                                       \
int x;                                                                   \
{                                                                        \
        T a;                                                             \
        T * volatile p;                                                  \
                                                                         \
        a = (T)x;                                                        \
        p = &a;                                                          \
        sk_##T = *p;                                                   \
        return sk_##T;                                                 \
}                                                                        \
static T                                                                 \
dae_##T(x)                                                \
int x;                                                                   \
{                                                                        \
        T a;                                                             \
        T *p;                                                            \
                                                                         \
        a = (T)x;                                                        \
        p = &a;                                                          \
        svsesc(&p);                                      \
        sk_##T = *p;                                                   \
        return sk_##T;                                                 \
}                                                                        \
static T                                                                 \
sta_##T(x)                                                \
int x;                                                                   \
{                                                                        \
        T a;                                                             \
        T *p;                                                            \
                                                                         \
        p = &a;                                                          \
        *p = (T)x;                                                       \
        sk_##T = a;                                                    \
        return sk_##T;                                                 \
}                                                                        \
static T                                                                 \
aed_##T(x)                                                  \
int x;                                                                   \
{                                                                        \
        T a[3];                                                          \
        T *p;                                                            \
                                                                         \
        a[0] = (T)x;                                                     \
        a[1] = (T)(x + 1);                                               \
        a[2] = (T)(x + 2);                                               \
        p = &a[1];                                                       \
        sk_##T = *p;                                                   \
        return sk_##T;                                                 \
}                                                                        \
static T                                                                 \
sfd_##T(x)                                                \
int x;                                                                   \
{                                                                        \
        struct svst_##T s;                                    \
        T *p;                                                            \
                                                                         \
        s.a = (T)x;                                                      \
        s.b = (T)(x + 1);                                                \
        p = &s.b;                                                        \
        sk_##T = *p;                                                   \
        return sk_##T;                                                 \
}                                                                        \
static void                                                              \
psa_##T(x)                                            \
int x;                                                                   \
{                                                                        \
        T a;                                                             \
                                                                         \
        a = (T)x;                                                        \
        svsuse(&a);                                         \
        vsk_##T = a;                                                   \
}                                                                        \
static int                                                               \
usd_##T(x)                                            \
int x;                                                                   \
{                                                                        \
        psa_##T(x);                                   \
        return (int)dd_##T(x)                                  \
             + (int)dvl_##T(x)                          \
             + (int)dp_##T(x)                                 \
             + (int)dvps_##T(x)                   \
             + (int)dae_##T(x)                            \
             + (int)sta_##T(x)                            \
             + (int)aed_##T(x)                              \
             + (int)sfd_##T(x);                           \
}

DECL_STACK_SCALAR_DEREF(char)
DECL_STACK_SCALAR_DEREF(schar)
DECL_STACK_SCALAR_DEREF(uchar)
DECL_STACK_SCALAR_DEREF(Qint)
DECL_STACK_SCALAR_DEREF(sQint)
DECL_STACK_SCALAR_DEREF(uQint)
DECL_STACK_SCALAR_DEREF(Hint)
DECL_STACK_SCALAR_DEREF(uHint)
DECL_STACK_SCALAR_DEREF(char6)
DECL_STACK_SCALAR_DEREF(uchar6)
DECL_STACK_SCALAR_DEREF(char7)
DECL_STACK_SCALAR_DEREF(uchar7)
DECL_STACK_SCALAR_DEREF(char8)
DECL_STACK_SCALAR_DEREF(uchar8)
DECL_STACK_SCALAR_DEREF(char9)
DECL_STACK_SCALAR_DEREF(uchar9)
DECL_STACK_SCALAR_DEREF(short16)
DECL_STACK_SCALAR_DEREF(ushort16)
DECL_STACK_SCALAR_DEREF(short18)
DECL_STACK_SCALAR_DEREF(ushort18)
DECL_STACK_SCALAR_DEREF(int32)
DECL_STACK_SCALAR_DEREF(uint32)

int
use_svst_deref(x)
int x;
{
        return usd_char(x)
             + usd_schar(x)
             + usd_uchar(x)
             + usd_Qint(x)
             + usd_sQint(x)
             + usd_uQint(x)
             + usd_Hint(x)
             + usd_uHint(x)
             + usd_char6(x)
             + usd_uchar6(x)
             + usd_char7(x)
             + usd_uchar7(x)
             + usd_char8(x)
             + usd_uchar8(x)
             + usd_char9(x)
             + usd_uchar9(x)
             + usd_short16(x)
             + usd_ushort16(x)
             + usd_short18(x)
             + usd_ushort18(x)
             + usd_int32(x)
             + usd_uint32(x);
}
