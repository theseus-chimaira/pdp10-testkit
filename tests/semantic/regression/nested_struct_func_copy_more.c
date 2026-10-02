volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

struct inner {
    char c0;
    char c1;
    short s0;
    short s1;
};

struct outer {
    int tag;
    struct inner in[2];
    short tail;
};

static void init_outer(o, base)
struct outer *o;
int base;
{
    o->tag = base;
    o->in[0].c0 = (char)(base + 1);
    o->in[0].c1 = (char)(base + 2);
    o->in[0].s0 = (short)(base + 3);
    o->in[0].s1 = (short)(-base - 4);
    o->in[1].c0 = (char)(base + 5);
    o->in[1].c1 = (char)(base + 6);
    o->in[1].s0 = (short)(base + 7);
    o->in[1].s1 = (short)(-base - 8);
    o->tail = (short)(base + 9);
}

static int sum_outer(o)
struct outer *o;
{
    return o->tag + o->tail +
        o->in[0].c0 + o->in[0].c1 + o->in[0].s0 + o->in[0].s1 +
        o->in[1].c0 + o->in[1].c1 + o->in[1].s0 + o->in[1].s1;
}

static int copy_tweak(dst, src, idx, delta)
struct outer *dst;
struct outer *src;
int idx;
int delta;
{
    *dst = src[idx];
    dst->tag += delta;
    dst->in[1].c0 = (char)(dst->in[1].c0 - delta);
    dst->in[0].s1 = (short)(dst->in[0].s1 + delta * 2);
    dst->tail = (short)(dst->tail + dst->in[0].c0);
    return sum_outer(dst);
}

int main()
{
    struct outer a[2];
    struct outer b;
    fail_id = 0;
    init_outer(&a[0], 10);
    init_outer(&a[1], 20);
    got = sum_outer(&a[0]);
    if (got != 81) { fail_id = 1; return 1; }
    got1 = sum_outer(&a[1]);
    if (got1 != 141) { fail_id = 2; return 1; }
    got2 = copy_tweak(&b, a, 0, 3);
    if (got2 != 98) { fail_id = 3; return 1; }
    got3 = copy_tweak(&a[0], a, 1, -4);
    if (got3 != 154) { fail_id = 4; return 1; }
    return 0;
}
