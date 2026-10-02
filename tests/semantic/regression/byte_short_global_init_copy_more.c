volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

struct cell {
    char c;
    unsigned char u;
    short s;
    unsigned short us;
};

static struct cell g[3] = {
    { 3, 4, -10, 20 },
    { 5, 6, 7, 8 },
    { 1, 9, 10, 11 }
};

static int sum_cell(p)
struct cell *p;
{
    return p->c + p->u + p->s + p->us;
}

static int sum_all(p, n)
struct cell *p;
int n;
{
    int i;
    int sum;
    sum = 0;
    for (i = 0; i < n; ++i)
        sum += sum_cell(&p[i]);
    return sum;
}

static void tweak_copy(dst, src)
struct cell *dst;
struct cell *src;
{
    struct cell t;
    t = *src;
    t.c = (char)(t.c - 2);
    t.u = (unsigned char)(t.u + 3);
    t.s = (short)(-t.s);
    t.us = (unsigned short)(t.us + 10);
    *dst = t;
}

int main()
{
    struct cell local[2];
    fail_id = 0;
    got = sum_all(g, 3);
    if (got != 74) { fail_id = 1; return 1; }
    local[0] = g[0];
    local[1] = g[1];
    got1 = sum_all(local, 2);
    if (got1 != 43) { fail_id = 2; return 1; }
    tweak_copy(&g[2], &local[1]);
    got2 = sum_cell(&g[2]);
    if (got2 != 23) { fail_id = 3; return 1; }
    got3 = sum_all(g, 3);
    if (got3 != 66) { fail_id = 4; return 1; }
    return 0;
}
