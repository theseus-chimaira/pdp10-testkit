/*
 * DAIMOS PDP-10 GCC semantic reducer.
 * Focus: BLT / BLKmode / struct assignment.
 * C89 / K&R style on purpose.
 */

int __test_exit;
int semantic_fail_id;
int semantic_sink;

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

struct large {
        int w[16];
};

static void
init_large(p, base)
struct large *p;
int base;
{
        int i;

        for (i = 0; i < 16; i++)
                p->w[i] = base + i;
}

static int
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

static struct large g_a;
static struct large g_b;

static void
copy_large_store(dst, src)
struct large *dst;
struct large *src;
{
        *dst = *src;
}

int
main()
{
        semantic_fail_id = 0;
        semantic_sink = 030;

        init_large(&g_a, 01000);
        init_large(&g_b, 07000);

        copy_large_store(&g_b, &g_a);

        g_a.w[5] = -7;

        if (!check_large(&g_b, 01000, 02100))
                return semantic_fail_id;

        semantic_fail_id = 0;
        semantic_sink = 1;
        return 0;
}
