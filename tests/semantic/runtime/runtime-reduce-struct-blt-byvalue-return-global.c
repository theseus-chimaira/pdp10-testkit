/*
 * DAIMOS PDP-10 GCC semantic reducer.
 * Focus: large struct passed by value and returned by value, global objects.
 * This matches the broad struct-assignment pattern more closely than the
 * pointer-return reducer: id_large(struct large x) { return x; }.
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

static struct large g_a;
static struct large g_b;

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
        semantic_fail_id = 0;
        semantic_sink = 034;

        init_large(&g_a, 02000);
        init_large(&g_b, 07000);

        g_b = id_large(g_a);

        g_a.w[6] = -6;

        if (!check_large(&g_b, 02000, 02600))
                return semantic_fail_id;

        semantic_fail_id = 0;
        semantic_sink = 1;
        return 0;
}
