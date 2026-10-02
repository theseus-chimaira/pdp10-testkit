volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;

struct leaf {
    char c0;
    short s0;
    unsigned char c1;
};

struct node {
    int tag;
    struct leaf a[3];
    char tail;
};

struct node gn;

static int leafsum(x)
struct leaf *x;
{
    return x->c0 + x->s0 + x->c1;
}

static void copy_leaf(dst, src)
struct leaf *dst;
struct leaf *src;
{
    *dst = *src;
}

int main()
{
    struct node n;
    struct node m;
    fail_id = 0;
    n.tag = 5;
    n.a[0].c0 = 1; n.a[0].s0 = -2; n.a[0].c1 = 3;
    n.a[1].c0 = 4; n.a[1].s0 = 6; n.a[1].c1 = 8;
    n.a[2].c0 = 10; n.a[2].s0 = -12; n.a[2].c1 = 14;
    n.tail = 16;
    m = n;
    got = m.tag + leafsum(&m.a[0]) + leafsum(&m.a[1]) + leafsum(&m.a[2]) + m.tail;
    if (got != 53) { fail_id = 1; return 1; }
    copy_leaf(&m.a[0], &n.a[2]);
    got1 = leafsum(&m.a[0]);
    if (got1 != 12) { fail_id = 2; return 1; }
    gn = m;
    gn.a[1].s0 = -7;
    got2 = gn.tag + leafsum(&gn.a[0]) + leafsum(&gn.a[1]) + leafsum(&gn.a[2]) + gn.tail;
    if (got2 != 50) { fail_id = 3; return 1; }
    got3 = leafsum(&n.a[1]);
    if (got3 != 18) { fail_id = 4; return 1; }
    return 0;
}
