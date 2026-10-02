volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct ptrbox {
    char *p;
    unsigned char *u;
    char tag;
    short delta;
};

struct arrbox {
    char c[9];
    unsigned char u[9];
    int guard;
};

struct arrbox gh;
struct ptrbox gp;

static int stepbox(b, k)
struct ptrbox b;
int k;
{
    int s;
    s = *b.p++;
    s += *++b.p;
    *b.p = (char)(*b.p + k);
    s += (int)(b.p - gh.c);
    s += *b.u++;
    s += *++b.u;
    *b.u = (unsigned char)(*b.u + k + 1);
    s += (int)(b.u - gh.u);
    s += b.tag + b.delta;
    return s;
}

static int mutate(bp)
struct ptrbox *bp;
{
    int s;
    s = *bp->p++;
    s += *bp->p;
    *bp->p = (char)(*bp->p + 4);
    s += *--bp->u;
    *bp->u = (unsigned char)(*bp->u + 5);
    bp->delta = (short)(bp->delta + (bp->p - gh.c) + (bp->u - gh.u));
    return s + bp->delta;
}

static int sum_c(cp, n)
char *cp;
int n;
{
    int i;
    int s;
    s = 0;
    for (i = 0; i < n; ++i)
        s += cp[i];
    return s;
}

static int sum_uc(cp, n)
unsigned char *cp;
int n;
{
    int i;
    int s;
    s = 0;
    for (i = 0; i < n; ++i)
        s += cp[i];
    return s;
}

int main()
{
    int i;
    fail_id = 0;
    for (i = 0; i < 9; ++i) {
        gh.c[i] = (char)(10 + i);
        gh.u[i] = (unsigned char)(40 + i);
    }
    gh.guard = 4242;
    gp.p = &gh.c[2];
    gp.u = &gh.u[3];
    gp.tag = 7;
    gp.delta = 11;
    got = stepbox(gp, 6);
    if (got != 141) { fail_id = 1; return 1; }
    if ((int)(gp.p - gh.c) != 2) { fail_id = 2; return 1; }
    if ((int)(gp.u - gh.u) != 3) { fail_id = 3; return 1; }
    got1 = mutate(&gp);
    if (got1 != 83) { fail_id = 4; return 1; }
    got2 = (int)(gp.p - gh.c) + (int)(gp.u - gh.u) + gp.delta;
    if (got2 != 21) { fail_id = 5; return 1; }
    got3 = sum_c(gh.c, 9);
    if (got3 != 136) { fail_id = 6; return 1; }
    got4 = sum_uc(gh.u, 9);
    if (got4 != 408) { fail_id = 7; return 1; }
    got5 = gh.guard;
    if (got5 != 4242) { fail_id = 8; return 1; }
    return 0;
}
