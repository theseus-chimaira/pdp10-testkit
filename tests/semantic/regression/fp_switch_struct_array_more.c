volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct fs {
    float f;
    double d;
    short code;
    char tag;
};

struct fs ga[4];
double gd;

static double mix(a, b, k)
double a;
float b;
int k;
{
    double x;
    x = a + (double)b;
    if (k)
        x = x * 1.5;
    else
        x = x - 2.25;
    return x;
}

static int classify(p, k)
struct fs *p;
int k;
{
    double x;
    int r;
    x = mix(p->d, p->f, k);
    p->d = x;
    p->f = (float)(x + 0.75);
    r = (int)x;
    switch (r) {
    case -2:
        p->code = (short)(p->code - 5);
        return 10 + (int)p->code;
    case 4:
        p->tag = (char)(p->tag + 3);
        return 20 + p->tag;
    case 9:
        p->code = (short)(p->code + 7);
        return 30 + (int)p->code;
    default:
        return 40 + r;
    }
}

int main()
{
    fail_id = 0;
    ga[0].f = 1.5;
    ga[0].d = 2.5;
    ga[0].code = 11;
    ga[0].tag = 5;
    ga[1].f = 2.0;
    ga[1].d = 4.0;
    ga[1].code = 12;
    ga[1].tag = 7;
    ga[2].f = -1.0;
    ga[2].d = 1.0;
    ga[2].code = 13;
    ga[2].tag = 9;
    got = classify(&ga[0], 0);
    if (got != 41) { fail_id = 1; return 1; }
    got1 = classify(&ga[1], 1);
    if (got1 != 49) { fail_id = 2; return 1; }
    got2 = classify(&ga[2], 0);
    if (got2 != 18) { fail_id = 3; return 1; }
    gd = ga[0].d + ga[1].d + ga[2].d;
    got3 = (int)gd;
    if (got3 != 8) { fail_id = 4; return 1; }
    got4 = (int)(ga[0].f + ga[1].f + ga[2].f);
    if (got4 != 10) { fail_id = 5; return 1; }
    got5 = ga[0].tag + ga[1].code + ga[2].code;
    if (got5 != 32) { fail_id = 6; return 1; }
    return 0;
}
