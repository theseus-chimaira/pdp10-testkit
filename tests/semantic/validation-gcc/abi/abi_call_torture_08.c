volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct pairx {
    char c;
    short s;
    int x;
    char d[2];
};

static struct pairx mk(c, s)
int c;
int s;
{
    struct pairx p;
    p.c = (char)c;
    p.s = (short)s;
    p.x = c * s;
    p.d[0] = (char)(c + 1);
    p.d[1] = (char)(s + 1);
    return p;
}

static struct pairx add(p, k)
struct pairx p;
int k;
{
    p.c = (char)(p.c + k);
    p.s = (short)(p.s + k);
    p.x = p.x + k;
    p.d[0] = (char)(p.d[0] + k);
    p.d[1] = (char)(p.d[1] + k);
    return p;
}

static int sum(p)
struct pairx p;
{
    return p.c + p.s + p.x + p.d[0] + p.d[1];
}

int main()
{
    struct pairx p;
    fail_id = 0;
    p = mk(11, 21);
    got = sum(p);
    if (got != 297) { fail_id = 1; return 1; }
    p = add(p, 7);
    got1 = sum(p);
    if (got1 != 332) { fail_id = 2; return 1; }
    return 0;
}
