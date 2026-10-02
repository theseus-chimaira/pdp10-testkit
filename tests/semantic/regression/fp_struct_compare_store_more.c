volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;

struct fpbox {
    double d[3];
    int tag;
};

struct fpbox gb;

static int calc(p, k)
struct fpbox *p;
int k;
{
    double x;
    int r;
    x = p->d[0] + p->d[1] - p->d[2];
    p->d[k] = x + 1.5;
    r = (int)x;
    if (p->d[k] > x) r += 10;
    if (p->d[k] != x) r += 20;
    return r + p->tag;
}

int main()
{
    struct fpbox b;
    fail_id = 0;
    b.d[0] = 8.0;
    b.d[1] = 2.5;
    b.d[2] = 4.0;
    b.tag = 3;
    got = calc(&b, 1);
    if (got != 39) { fail_id = 1; return 1; }
    got1 = (int)b.d[1];
    if (got1 != 8) { fail_id = 2; return 1; }
    gb = b;
    gb.d[2] = -1.0;
    got2 = calc(&gb, 0);
    if (got2 != 50) { fail_id = 3; return 1; }
    got3 = (int)gb.d[0];
    if (got3 != 18) { fail_id = 4; return 1; }
    return 0;
}
