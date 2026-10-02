/*
 * DAIMOS PDP-10 GCC semantic reducer.
 * Focus: large local struct passed by value and returned by value.
 * This is the exact broad-test shape:
 *     local_b = id_large(local_a);
 * It exercises caller-side stack argument copy plus hidden return buffer.
 * C89 / K&R style on purpose.
 */

#include "insns.h"

int __test_exit;
int semantic_fail_id;
int semantic_sink;

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

struct large {
        int w[16];
};

static int
check_int(got, want, id)
int got;
int want;
int id;
{
        if (got != want) {
                semantic_fail_id = id;
                semantic_sink = got;
                return 0;
        }
        return 1;
}

NOINLINE static void
init_large(p, base)
struct large *p;
int base;
{
        int i;

        for (i = 0; i < 16; i++)
                p->w[i] = base + i;
}

NOINLINE static int
check_large(p, base, idbase)
struct large *p;
int base;
int idbase;
{
        int i;

        for (i = 0; i < 16; i++) {
                if (!check_int(p->w[i], base + i, idbase + i))
                        return 0;
        }
        return 1;
}

NOINLINE static struct large
id_large(x)
struct large x;
{
        return x;
}

int
main()
{
        struct large local_a;
        struct large local_b;

        semantic_fail_id = 0;
        semantic_sink = 035;

        init_large(&local_a, 02000);
        init_large(&local_b, 07000);

        local_b = id_large(local_a);

        local_a.w[7] = -7;

        if (!check_large(&local_b, 02000, 02700))
                return semantic_fail_id;

        semantic_fail_id = 0;
        semantic_sink = 1;
        return 0;
}
