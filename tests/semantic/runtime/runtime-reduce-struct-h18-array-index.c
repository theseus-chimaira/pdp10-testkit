/*
 * DAIMOS PDP-10 GCC semantic reducer.
 * Focus: dynamic indexing of a short18 array field inside a mixed struct.
 * This isolates the broad struct BLT failure id 03310 / sink 06021:
 * h[0] is read back as h[1].
 * C89 / K&R style on purpose.
 */

#include "insns.h"

int __test_exit;
int semantic_fail_id;
int semantic_sink;

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

struct mixed {
        int tag;
        signed char c0;
        unsigned char c1;
        short h[4];
        int tail[10];
};

static struct mixed g;

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
init_h(p, base)
struct mixed *p;
int base;
{
        int i;

        p->tag = base;
        p->c0 = -1;
        p->c1 = 0123;
        for (i = 0; i < 4; i++)
                p->h[i] = base + 020 + i;
        for (i = 0; i < 10; i++)
                p->tail[i] = base + 0100 + i;
}

NOINLINE static int
check_h(p, base, idbase)
struct mixed *p;
int base;
int idbase;
{
        int i;

        for (i = 0; i < 4; i++) {
                if (!check_int(p->h[i], base + 020 + i, idbase + i))
                        return 0;
        }
        return 1;
}

int
main()
{
        semantic_fail_id = 0;
        semantic_sink = 042;

        init_h(&g, 06000);

        if (!check_h(&g, 06000, 03500))
                return semantic_fail_id;

        semantic_fail_id = 0;
        semantic_sink = 1;
        return 0;
}
