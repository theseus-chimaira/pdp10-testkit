volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;

struct pack {
    char a[5];
    short s[3];
    unsigned char b[4];
    int x;
};

struct pack gp = { {1, 2, 3, 4, 5}, {11, -12, 13}, {6, 7, 8, 9}, 10 };
struct pack gq;

static int sump(p)
struct pack *p;
{
    return p->a[0] + p->a[4] + p->s[0] + p->s[1] +
           p->s[2] + p->b[0] + p->b[3] + p->x;
}

int main()
{
    struct pack l;
    fail_id = 0;
    got = sump(&gp);
    if (got != 43) { fail_id = 1; return 1; }
    l = gp;
    l.a[2] = 20;
    l.s[1] = -5;
    l.b[2] = 30;
    got1 = sump(&l);
    if (got1 != 50) { fail_id = 2; return 1; }
    gq = l;
    gq.a[4] = 40;
    gq.x = -3;
    got2 = sump(&gq);
    if (got2 != 72) { fail_id = 3; return 1; }
    got3 = sump(&gp);
    if (got3 != 43) { fail_id = 4; return 1; }
    return 0;
}
