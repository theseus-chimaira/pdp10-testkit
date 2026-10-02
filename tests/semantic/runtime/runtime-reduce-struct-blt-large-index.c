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

static struct large g_arr[3];

static void
copy_large_index(base, dst, src)
struct large *base;
int dst;
int src;
{
        base[dst] = base[src];
}

int
main()
{
        semantic_fail_id = 0;
        semantic_sink = 032;

        init_large(&g_arr[0], 03000);
        init_large(&g_arr[1], 04000);
        init_large(&g_arr[2], 05000);

        copy_large_index(g_arr, 2, 0);

        g_arr[0].w[0] = -010;

        if (!check_large(&g_arr[2], 03000, 02300))
                return semantic_fail_id;
        if (!check_large(&g_arr[1], 04000, 02400))
                return semantic_fail_id;

        semantic_fail_id = 0;
        semantic_sink = 1;
        return 0;
}
