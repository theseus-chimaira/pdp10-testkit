volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

double gd;
float gf[3];
int gi[4];

struct fslot {
    double d[2];
    float f;
    unsigned int u;
};

struct fslot gs;

static double scale_int(x)
int x;
{
    return (double)x * 1.25;
}

static int threshold_store(sp, u, off)
struct fslot *sp;
unsigned int u;
int off;
{
    double x;
    int r;
    x = (double)u + scale_int(off);
    sp->d[0] = x;
    sp->d[1] = x / 2.0;
    sp->f = sp->d[1] - 0.5;
    gd = sp->d[0] - sp->f;
    r = (int)sp->f;
    if (sp->d[0] > 1000.0)
        r += 100;
    if (gd >= 500.5)
        r += 10;
    return r;
}

static int pass_global()
{
    int r;
    gf[0] = gs.f;
    gf[1] = gd;
    r = (int)gf[0] + (int)gf[1];
    if (gf[1] > gf[0])
        r += 7;
    return r;
}

int main()
{
    struct fslot ls;
    fail_id = 0;
    ls.u = 01000;
    got = threshold_store(&ls, ls.u, 4);
    if (got != 258) { fail_id = 1; return 1; }
    got1 = (int)ls.d[0];
    if (got1 != 517) { fail_id = 2; return 1; }
    got2 = (int)gd;
    if (got2 != 259) { fail_id = 3; return 1; }
    gs = ls;
    got3 = pass_global();
    if (got3 != 524) { fail_id = 4; return 1; }
    got4 = threshold_store(&gs, 02000, -4);
    if (got4 != 619) { fail_id = 5; return 1; }
    got5 = (int)gs.d[1];
    if (got5 != 509) { fail_id = 6; return 1; }
    return 0;
}
