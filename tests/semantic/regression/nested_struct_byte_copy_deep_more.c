volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

struct inner {
    char a[3];
    short s;
    unsigned char b[2];
};

struct outer {
    int tag;
    struct inner in[2];
    char tail;
};

struct outer go;

static int sum_outer(p)
struct outer *p;
{
    return p->tag + p->in[0].a[0] + p->in[0].a[2] +
           p->in[0].s + p->in[0].b[1] + p->in[1].a[1] +
           p->in[1].s + p->tail;
}

int main()
{
    struct outer x;
    struct outer y;
    fail_id = 0;
    x.tag = 10;
    x.in[0].a[0] = 1;
    x.in[0].a[1] = 2;
    x.in[0].a[2] = 3;
    x.in[0].s = -4;
    x.in[0].b[0] = 5;
    x.in[0].b[1] = 6;
    x.in[1].a[0] = 7;
    x.in[1].a[1] = 8;
    x.in[1].a[2] = 9;
    x.in[1].s = 11;
    x.in[1].b[0] = 12;
    x.in[1].b[1] = 13;
    x.tail = 14;
    y = x;
    got = sum_outer(&y);
    if (got != 49) { fail_id = 1; return 1; }
    go = y;
    go.in[0].a[2] = 20;
    go.in[1].s = -5;
    got1 = sum_outer(&go);
    if (got1 != 50) { fail_id = 2; return 1; }
    got2 = sum_outer(&x);
    if (got2 != 49) { fail_id = 3; return 1; }
    y.in[1] = go.in[0];
    got3 = y.in[1].a[0] + y.in[1].a[2] + y.in[1].s + y.in[1].b[1];
    if (got3 != 23) { fail_id = 4; return 1; }
    return 0;
}
