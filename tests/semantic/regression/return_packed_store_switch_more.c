volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct inner {
    char b[5];
    short h[3];
};

struct outer {
    struct inner in[2];
    char tag;
    short code;
    int sum;
};

struct outer go;

static char plus_char(x)
int x;
{
    return (char)(x + 0300);
}

static short neg_short(x)
int x;
{
    return (short)(-040 - x);
}

static char pass_char(c)
char c;
{
    return c;
}

static short pass_short(s)
short s;
{
    return s;
}

static int ret_to_index(x)
int x;
{
    return pass_char(plus_char(x)) & 3;
}

static int ret_switch(x)
int x;
{
    switch (pass_short(neg_short(x))) {
    case -043:
        return 5;
    case -044:
        return 7;
    case -045:
        return 11;
    default:
        return -31;
    }
}

static void fill(op, base)
struct outer *op;
int base;
{
    int ix;
    ix = ret_to_index(base);
    op->in[0].b[0] = pass_char(plus_char(base));
    op->in[0].b[1] = pass_char(plus_char(base + 1));
    op->in[0].b[ix] = pass_char(plus_char(base + 2));
    op->in[0].h[0] = pass_short(neg_short(base));
    op->in[0].h[1] = pass_short(neg_short(base + 1));
    op->in[1].b[0] = pass_char(plus_char(base + 3));
    op->in[1].h[0] = pass_short(neg_short(base + 2));
    op->tag = pass_char(plus_char(base + 4));
    op->code = pass_short(neg_short(base + 3));
    op->sum = op->in[0].b[0] + op->in[0].b[1] + op->in[0].b[ix] +
              op->in[0].h[0] + op->in[0].h[1] + op->in[1].b[0] +
              op->in[1].h[0] + op->tag + op->code + ret_switch(base);
}

int main()
{
    struct outer lo;
    int ix;
    fail_id = 0;
    fill(&lo, 3);
    ix = ret_to_index(3);
    got = ix;
    if (got != 3) { fail_id = 1; return 1; }
    got1 = lo.in[0].b[0];
    if (got1 != 0303) { fail_id = 2; return 1; }
    got2 = lo.in[0].h[0];
    if (got2 != -043) { fail_id = 3; return 1; }
    got3 = lo.in[0].b[ix];
    if (got3 != 0305) { fail_id = 4; return 1; }
    got4 = ret_switch(4);
    if (got4 != 7) { fail_id = 5; return 1; }
    got5 = lo.sum;
    if (got5 != 844) { fail_id = 6; return 1; }
    go = lo;
    if (go.tag != 0307) { fail_id = 7; return 1; }
    if (go.code != -046) { fail_id = 8; return 1; }
    if (go.sum != lo.sum) { fail_id = 9; return 1; }
    return 0;
}
