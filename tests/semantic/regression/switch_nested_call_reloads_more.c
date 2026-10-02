volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct swp {
    char op;
    unsigned char ix;
    short count;
    char data[5];
};

struct swp ga[4];
int sink;

static int bump(pp, k)
struct swp *pp;
int k;
{
    pp->ix = (unsigned char)(pp->ix + k);
    pp->count = (short)(pp->count + pp->ix);
    pp->data[pp->ix & 3] = (char)(pp->data[pp->ix & 3] + k);
    sink += pp->count;
    return pp->ix;
}

static int runone(pp)
struct swp *pp;
{
    int r;
    r = 0;
    switch (pp->op) {
    case 1:
        r += bump(pp, 1);
        /* fall through */
    case 2:
        r += pp->count;
        pp->op = (char)(pp->op + 3);
        break;
    case 3:
        r += bump(pp, 2);
        switch (pp->ix) {
        case 4:
            r += 40;
            break;
        default:
            r += 50;
            break;
        }
        break;
    default:
        r += bump(pp, 3);
        r += pp->data[pp->ix & 3];
        break;
    }
    r += pp->op + pp->ix + pp->count;
    return r;
}

int main()
{
    int i;
    fail_id = 0;
    sink = 0;
    for (i = 0; i < 4; ++i) {
        ga[i].op = (char)(i + 1);
        ga[i].ix = (unsigned char)(i + 1);
        ga[i].count = (short)(10 + i);
        ga[i].data[0] = (char)(20 + i);
        ga[i].data[1] = (char)(30 + i);
        ga[i].data[2] = (char)(40 + i);
        ga[i].data[3] = (char)(50 + i);
        ga[i].data[4] = (char)(60 + i);
    }
    got = runone(&ga[0]);
    if (got != 32) { fail_id = 1; return 1; }
    got1 = runone(&ga[1]);
    if (got1 != 29) { fail_id = 2; return 1; }
    got2 = runone(&ga[2]);
    if (got2 != 80) { fail_id = 3; return 1; }
    got3 = runone(&ga[3]);
    if (got3 != 94) { fail_id = 4; return 1; }
    got4 = ga[0].op + ga[1].op + ga[2].op + ga[3].op;
    if (got4 != 16) { fail_id = 5; return 1; }
    got5 = sink;
    if (got5 != 49) { fail_id = 6; return 1; }
    return 0;
}
