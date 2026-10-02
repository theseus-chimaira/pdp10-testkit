/*
 * DAIMOS PDP-10 GCC semantic reducer.
 * Focus: BLT / BLKmode copy of a struct mixing word and subword fields.
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

struct mixed {
        int tag;
        signed char c0;
        unsigned char c1;
        short h[4];
        int tail[10];
};

static struct mixed g_a;
static struct mixed g_b;

static void
init_mixed(p, base)
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

static int
check_mixed(p, base, idbase)
struct mixed *p;
int base;
int idbase;
{
        int i;

        if (!check_int(p->tag, base, idbase))
                return 0;
        if (!check_int(p->c0, -1, idbase + 1))
                return 0;
        if (!check_int(p->c1, 0123, idbase + 2))
                return 0;
        for (i = 0; i < 4; i++) {
                if (!check_int(p->h[i], base + 020 + i, idbase + 010 + i))
                        return 0;
        }
        for (i = 0; i < 10; i++) {
                if (!check_int(p->tail[i], base + 0100 + i, idbase + 020 + i))
                        return 0;
        }
        return 1;
}

static void
copy_mixed_store(dst, src)
struct mixed *dst;
struct mixed *src;
{
        *dst = *src;
}

int
main()
{
        semantic_fail_id = 0;
        semantic_sink = 033;

        init_mixed(&g_a, 06000);
        init_mixed(&g_b, 07000);

        copy_mixed_store(&g_b, &g_a);

        g_a.tag = -011;
        g_a.c0 = 7;
        g_a.h[2] = -012;

        if (!check_mixed(&g_b, 06000, 02500))
                return semantic_fail_id;

        semantic_fail_id = 0;
        semantic_sink = 1;
        return 0;
}
