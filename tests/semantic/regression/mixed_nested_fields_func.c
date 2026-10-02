volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

struct inner {
    char c;
    unsigned char uc;
    short s;
    unsigned short us;
};

struct outer {
    int tag;
    struct inner v[3];
    char tail;
    short more[2];
};

static void init_outer(o, base)
struct outer *o;
int base;
{
    int i;
    o->tag = base;
    for (i = 0; i < 3; ++i) {
        o->v[i].c = (char)(base + i + 1);
        o->v[i].uc = (unsigned char)(base + i + 4);
        o->v[i].s = (short)(base - i - 2);
        o->v[i].us = (unsigned short)(base + i + 7);
    }
    o->tail = (char)(base + 12);
    o->more[0] = (short)(base + 20);
    o->more[1] = (short)(-base - 3);
}

static int sum_outer(o)
struct outer *o;
{
    int i;
    int sum;
    sum = o->tag + o->tail + o->more[0] + o->more[1];
    for (i = 0; i < 3; ++i) {
        sum += o->v[i].c;
        sum += o->v[i].uc;
        sum += o->v[i].s;
        sum += o->v[i].us;
    }
    return sum;
}

static void tweak(o, idx, delta)
struct outer *o;
int idx;
int delta;
{
    o->v[idx].c = (char)(o->v[idx].c + delta);
    o->v[idx].uc = (unsigned char)(o->v[idx].uc + delta + 1);
    o->v[idx].s = (short)(o->v[idx].s - delta);
    o->v[idx].us = (unsigned short)(o->v[idx].us + delta + 2);
    o->more[idx & 1] = (short)(o->more[idx & 1] + delta);
}

int main()
{
    struct outer a[2];
    init_outer(&a[0], 10);
    init_outer(&a[1], 20);
    got = sum_outer(&a[0]);
    if (got != 205) { fail_id = 1; return 1; }
    got1 = sum_outer(&a[1]);
    if (got1 != 345) { fail_id = 2; return 1; }
    tweak(&a[0], 1, 3);
    got2 = sum_outer(&a[0]);
    if (got2 != 217) { fail_id = 3; return 1; }
    tweak(&a[1], 2, -5);
    got3 = sum_outer(&a[1]);
    if (got3 != 333) { fail_id = 4; return 1; }
    return 0;
}
