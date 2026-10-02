volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct small {
    char c;
    short s;
    int x;
};

static struct small make_small(c, s, x)
int c;
int s;
int x;
{
    struct small v;
    v.c = (char)c;
    v.s = (short)s;
    v.x = x;
    return v;
}

static int total(v)
struct small v;
{
    return v.c + v.s + v.x;
}

int main()
{
    struct small a0;
    fail_id = 0;
    a0 = make_small(13, 34, 442);
    got = total(a0);
    if (got != 489) { fail_id = 1; return 1; }
    got1 = a0.c + a0.s;
    if (got1 != 47) { fail_id = 2; return 1; }
    got4 = (got1 + 11) % 4;
    if (got4 == 0)
        got2 = got1 + 10;
    else if (got4 == 1)
        got2 = got1 + 20;
    else if (got4 == 2)
        got2 = got1 + 30;
    else
        got2 = got1 + 40;
    if (got2 != 77) { fail_id = 3; return 1; }
    return 0;
}
