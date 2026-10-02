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

static struct large
copy_large_return(src)
struct large *src;
{
        return *src;
}

int
main()
{
        semantic_fail_id = 0;
        semantic_sink = 031;

        init_large(&g_a, 02000);
        init_large(&g_b, 07000);

        g_b = copy_large_return(&g_a);

        g_a.w[6] = -6;

        if (!check_large(&g_b, 02000, 02200))
                return semantic_fail_id;

        semantic_fail_id = 0;
        semantic_sink = 1;
        return 0;
}
