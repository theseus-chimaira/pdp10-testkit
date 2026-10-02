volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct retpack {
    char c[8];
    short s[4];
    int x;
};

struct retpack gb;

static char ret_c(x)
int x;
{
    return (char)(x + 0400);
}

static unsigned char ret_uc(x)
int x;
{
    return (unsigned char)(x + 010);
}

static short ret_sneg(x)
int x;
{
    return (short)(x - 0200);
}

static short chain_c_to_s(x)
int x;
{
    char c;
    c = ret_c(x);
    return (short)c;
}

static int chain_s_to_i(x)
int x;
{
    short s;
    s = ret_sneg(x);
    return s;
}

static int choose_from_short(x)
int x;
{
    switch (ret_sneg(x)) {
    case -0175:
        return 11;
    case -0174:
        return 13;
    case -0173:
        return 17;
    default:
        return -99;
    }
}

static int choose_from_char(x)
int x;
{
    switch (ret_c(x)) {
    case 0402:
        return 19;
    case 0403:
        return 23;
    case 0404:
        return 29;
    default:
        return -77;
    }
}

static int store_all(bp, x)
struct retpack *bp;
int x;
{
    int ix;
    bp->c[0] = ret_c(x);
    bp->c[1] = ret_uc(x);
    bp->s[0] = ret_sneg(x);
    bp->s[1] = chain_c_to_s(x + 1);
    ix = ret_uc(x) & 7;
    bp->c[ix] = ret_c(x + 2);
    bp->x = chain_s_to_i(x + 2) + choose_from_char(x + 1);
    return ix;
}

int main()
{
    struct retpack lb;
    int ix;
    fail_id = 0;
    ix = store_all(&lb, 3);
    got = ix;
    if (got != 3) { fail_id = 1; return 1; }
    got1 = lb.c[0];
    if (got1 != 0403) { fail_id = 2; return 1; }
    got2 = lb.s[0];
    if (got2 != -0175) { fail_id = 3; return 1; }
    got3 = lb.s[1];
    if (got3 != 0404) { fail_id = 4; return 1; }
    got4 = lb.c[ix];
    if (got4 != 0405) { fail_id = 5; return 1; }
    got5 = lb.x;
    if (got5 != (-0173 + 29)) { fail_id = 6; return 1; }
    gb = lb;
    if (choose_from_short(4) != 13) { fail_id = 7; return 1; }
    if (choose_from_char(3) != 23) { fail_id = 8; return 1; }
    if (gb.c[0] + gb.s[0] + gb.s[1] != 0403 - 0175 + 0404) {
        fail_id = 9;
        return 1;
    }
    return 0;
}
