volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;

struct mid {
    char q;
    short r;
    int z;
};

struct cell {
    char p[4];
    short h;
    struct mid m;
    int end;
};

struct cell gc[4];

static void fill_cell(cp, b)
struct cell *cp;
int b;
{
    cp->p[0] = (char)(b + 1);
    cp->p[1] = (char)(b + 2);
    cp->p[2] = (char)(b + 3);
    cp->p[3] = (char)(b + 4);
    cp->h = (short)(-(b + 5));
    cp->m.q = (char)(b + 6);
    cp->m.r = (short)(b + 7);
    cp->m.z = b + 8;
    cp->end = b + 9;
}

static int sum_cell(cp)
struct cell *cp;
{
    return cp->p[0] + cp->p[1] + cp->p[2] + cp->p[3] +
           cp->h + cp->m.q + cp->m.r + cp->m.z + cp->end;
}

static int sum_by_value(c)
struct cell c;
{
    return c.p[0] + c.p[1] + c.p[2] + c.p[3] +
           c.h + c.m.q + c.m.r + c.m.z + c.end;
}

static struct cell change_copy(c, k)
struct cell c;
int k;
{
    c.p[1] = (char)(c.p[1] + k);
    c.h = (short)(c.h - k);
    c.m.q = (char)(c.m.q + k);
    c.end = c.end + k;
    return c;
}

int main()
{
    struct cell lc[2];
    fail_id = 0;
    fill_cell(&gc[0], 3);
    fill_cell(&gc[1], 10);
    fill_cell(&gc[2], 30);
    lc[0] = gc[0];
    lc[1] = gc[2];
    got = sum_cell(&lc[0]);
    if (got != 56) { fail_id = 1; return 1; }
    got1 = sum_by_value(lc[1]);
    if (got1 != 245) { fail_id = 2; return 1; }
    gc[3] = lc[0];
    gc[1] = lc[1];
    gc[0] = gc[1];
    got2 = sum_cell(&gc[0]);
    if (got2 != 245) { fail_id = 3; return 1; }
    gc[0].p[2] = 44;
    gc[0].m.r = -12;
    got3 = sum_cell(&gc[0]);
    if (got3 != 207) { fail_id = 4; return 1; }
    gc[2] = change_copy(gc[3], 6);
    got4 = sum_cell(&gc[2]);
    if (got4 != 68) { fail_id = 5; return 1; }
    if (sum_cell(&gc[3]) != 56) { fail_id = 6; return 1; }
    return 0;
}
