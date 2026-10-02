/*
 * DAIMOS PDP-10 GCC semantic reducer.
 * Focus: dynamic indexing of a plain short18 array.
 * C89 / K&R style on purpose.
 */

#include "insns.h"

int __test_exit;
int semantic_fail_id;
int semantic_sink;

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

static short h[4];

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
init_h(base)
int base;
{
        int i;

        for (i = 0; i < 4; i++)
                h[i] = base + 020 + i;
}

NOINLINE static int
check_h(base, idbase)
int base;
int idbase;
{
        int i;

        for (i = 0; i < 4; i++) {
                if (!check_int(h[i], base + 020 + i, idbase + i))
                        return 0;
        }
        return 1;
}

int
main()
{
        semantic_fail_id = 0;
        semantic_sink = 041;

        init_h(06000);

        if (!check_h(06000, 03400))
                return semantic_fail_id;

        semantic_fail_id = 0;
        semantic_sink = 1;
        return 0;
}
