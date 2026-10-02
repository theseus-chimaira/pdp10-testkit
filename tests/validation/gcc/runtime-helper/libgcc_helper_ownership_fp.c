#include "insns.h"

/*
 * libgcc_helper_ownership_fp.c - direct ownership probe for FP helpers.
 *
 * These symbols must be supplied by gcc/config/pdp10/libgcc1.s in the bare
 * GCC semantic runtime.  The testkit must not carry duplicate helper bodies.
 */

volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

extern Sfloat __floatsisf(Sint);
extern Dfloat __floatsidf(Sint);
extern Sint __fixsfsi(Sfloat);
extern Sint __fixdfsi(Dfloat);
extern Sfloat __floatunssisf(uSint);
extern Sint __cmpdf2(Dfloat, Dfloat);
extern Dfloat __adddf3(Dfloat, Dfloat);
extern Dfloat __subdf3(Dfloat, Dfloat);
extern Dfloat __muldf3(Dfloat, Dfloat);
extern Dfloat __divdf3(Dfloat, Dfloat);
extern Dfloat __negdf2(Dfloat);

/* Exercise GCC's initialized-DF constant emission independently of libgcc. */
static Dfloat const_df_max = 34359738367.0;
static Dfloat const_df_min = -34359738368.0;
static Dfloat const_add_lo = 1.0 + (1.0 / 1073741824.0);
static Dfloat const_sub_lo = 1.0 - (1.0 / 1073741824.0);
static Dfloat const_mul = 1.5 * 1.25;
static Dfloat const_div = 1.5 / 1.25;

static int
check_i(g, e, id)
Sint g;
Sint e;
int id;
{
    if (g != e) {
        fail_id = id;
        got = (int)g;
        return 0;
    }
    return 1;
}

int
main()
{
    Sfloat sf;
    Dfloat df1;
    Dfloat df2;
    Sint v;
    union {
        Sfloat f;
        uSint w;
    } su;
    union {
        Dfloat d;
        uSint w[2];
    } du;

    fail_id = 0;
    got = 0;
    got1 = 0;
    got2 = 0;
    got3 = 0;
    got4 = 0;
    got5 = 0;

    sf = __floatsisf((Sint)-37);
    v = __fixsfsi(sf);
    if (!check_i(v, (Sint)-37, 1))
        return 1;
    got1 = (int)v;

    df1 = __floatsidf((Sint)123);
    v = __fixdfsi(df1);
    if (!check_i(v, (Sint)123, 2))
        return 1;
    got2 = (int)v;

    sf = __floatunssisf((uSint)07777U);
    v = __fixsfsi(sf);
    if (!check_i(v, (Sint)07777, 3))
        return 1;
    got3 = (int)v;

    su.f = __floatunssisf((uSint)0400000000000UL);
    if (su.w != (uSint)0244400000000UL) {
        fail_id = 7;
        got = (int)su.w;
        return 1;
    }

    df1 = __floatsidf((Sint)0377777777777L);
    v = __fixdfsi(df1);
    if (!check_i(v, (Sint)0377777777777L, 8))
        return 1;
    du.d = df1;
    if (du.w[0] != (uSint)0243777777777UL
        || du.w[1] != (uSint)0377000000000UL) {
        fail_id = 11;
        got = (int)du.w[0];
        got1 = (int)du.w[1];
        return 1;
    }

    df1 = __floatsidf((Sint)-0400000000000L);
    v = __fixdfsi(df1);
    if (!check_i(v, (Sint)-0400000000000L, 9))
        return 1;
    du.d = df1;
    if (du.w[0] != (uSint)0533400000000UL
        || du.w[1] != (uSint)0400000000000UL) {
        fail_id = 12;
        got = (int)du.w[0];
        got1 = (int)du.w[1];
        return 1;
    }

    du.d = __floatsidf((Sint)123);
    if (du.w[0] != (uSint)0207754000000UL || du.w[1] != (uSint)0) {
        fail_id = 10;
        got = (int)du.w[0];
        got1 = (int)du.w[1];
        return 1;
    }

    du.d = const_df_max;
    if (du.w[0] != (uSint)0243777777777UL
        || du.w[1] != (uSint)0377000000000UL) {
        fail_id = 13;
        got = (int)du.w[0];
        got1 = (int)du.w[1];
        return 1;
    }
    du.d = const_df_min;
    if (du.w[0] != (uSint)0533400000000UL
        || du.w[1] != (uSint)0400000000000UL) {
        fail_id = 14;
        got = (int)du.w[0];
        got1 = (int)du.w[1];
        return 1;
    }

    df1 = __floatsidf((Sint)4);
    df2 = __floatsidf((Sint)7);
    v = __cmpdf2(df1, df2);
    if (!check_i(v, (Sint)-1, 4))
        return 1;
    got4 = (int)v;

    v = __cmpdf2(df2, df1);
    if (!check_i(v, (Sint)1, 5))
        return 1;
    got5 = (int)v;

    v = __cmpdf2(df1, df1);
    if (!check_i(v, (Sint)0, 6))
        return 1;

    df1 = __adddf3((Dfloat)1.0, (Dfloat)(1.0 / 1073741824.0));
    du.d = df1;
    {
        union { Dfloat d; uSint w[2]; } eu;
        eu.d = const_add_lo;
        if (du.w[0] != eu.w[0] || du.w[1] != eu.w[1]) {
            fail_id = 15;
            got = (int)du.w[0];
            got1 = (int)du.w[1];
            return 1;
        }
    }

    df1 = __subdf3((Dfloat)1.0, (Dfloat)(1.0 / 1073741824.0));
    du.d = df1;
    {
        union { Dfloat d; uSint w[2]; } eu;
        eu.d = const_sub_lo;
        if (du.w[0] != eu.w[0] || du.w[1] != eu.w[1]) {
            fail_id = 16;
            got = (int)du.w[0];
            got1 = (int)du.w[1];
            return 1;
        }
    }

    df1 = __muldf3((Dfloat)1.5, (Dfloat)1.25);
    du.d = df1;
    {
        union { Dfloat d; uSint w[2]; } eu;
        eu.d = const_mul;
        if (du.w[0] != eu.w[0] || du.w[1] != eu.w[1]) {
            fail_id = 17;
            got = (int)du.w[0];
            got1 = (int)du.w[1];
            return 1;
        }
    }

    df1 = __divdf3((Dfloat)1.5, (Dfloat)1.25);
    du.d = df1;
    {
        union { Dfloat d; uSint w[2]; } eu;
        eu.d = const_div;
        if (du.w[0] != eu.w[0] || du.w[1] != eu.w[1]) {
            fail_id = 18;
            got = (int)du.w[0];
            got1 = (int)du.w[1];
            return 1;
        }
    }

    df1 = __negdf2((Dfloat)1.5);
    du.d = df1;
    {
        union { Dfloat d; uSint w[2]; } eu;
        eu.d = (Dfloat)-1.5;
        if (du.w[0] != eu.w[0] || du.w[1] != eu.w[1]) {
            fail_id = 19;
            got = (int)du.w[0];
            got1 = (int)du.w[1];
            return 1;
        }
    }

    return 0;
}
