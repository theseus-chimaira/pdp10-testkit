volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct rpack {
    char b[5];
    short s[4];
    int x;
};

struct rpack gp;
int table[9];

static short ret_short(v)
int v;
{
    short s;
    s = (short)v;
    return s;
}

static short neg_chain(v)
int v;
{
    return ret_short(-v);
}

static char ret_char(v)
int v;
{
    return (char)v;
}

static int use_short(v)
int v;
{
    short s;
    int r;
    s = neg_chain(v);
    r = 0;
    if (s < 0)
        r += 100;
    if (s == -v)
        r += 20;
    r += s;
    return r;
}

static int choose(v)
int v;
{
    switch (ret_short(v)) {
    case -3:
        return 30;
    case 2:
        return 20;
    case 7:
        return 70;
    default:
        return 5;
    }
}

int main()
{
    int i;
    fail_id = 0;
    for (i = 0; i < 9; ++i)
        table[i] = 1000 + i * 3;
    got = use_short(17);
    if (got != 103) { fail_id = 1; return 1; }
    gp.s[0] = neg_chain(9);
    gp.s[1] = ret_short(12);
    gp.b[0] = ret_char(6);
    gp.b[1] = ret_char(260);
    got1 = gp.s[0] + gp.s[1] + gp.b[0] + gp.b[1];
    if (got1 != 269) { fail_id = 2; return 1; }
    got2 = choose(-3) + choose(2) + choose(5);
    if (got2 != 55) { fail_id = 3; return 1; }
    got3 = table[ret_char(4)] + table[ret_short(6)];
    if (got3 != 2030) { fail_id = 4; return 1; }
    gp.x = table[(int)(ret_short(-2) + 4)];
    if (gp.x != 1006) { fail_id = 5; return 1; }
    got4 = (ret_short(-12) < ret_short(3)) ? 44 : 55;
    if (got4 != 44) { fail_id = 6; return 1; }
    got5 = (ret_short(300) > ret_char(255)) ? 77 : 88;
    if (got5 != 77) { fail_id = 7; return 1; }
    return 0;
}
