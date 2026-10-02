volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

struct rec {
    int a;
    char b;
    short c;
    unsigned char d;
};

static struct rec make_rec(a, b, c, d)
int a;
int b;
int c;
int d;
{
    struct rec r;
    r.a = a;
    r.b = (char)b;
    r.c = (short)c;
    r.d = (unsigned char)d;
    return r;
}

static struct rec bump_rec(r, k)
struct rec r;
int k;
{
    r.a = r.a + k;
    r.b = (char)(r.b + 1);
    r.c = (short)(r.c - k);
    r.d = (unsigned char)(r.d + 2);
    return r;
}

static int sum_rec(r)
struct rec r;
{
    return r.a + r.b + r.c + r.d;
}

int main()
{
    struct rec x;
    struct rec y;
    fail_id = 0;
    x = make_rec(10, 3, -4, 7);
    got = sum_rec(x);
    if (got != 16) { fail_id = 1; return 1; }
    y = bump_rec(x, 5);
    got1 = sum_rec(y);
    if (got1 != 19) { fail_id = 2; return 1; }
    got2 = x.a + x.b + x.c + x.d;
    if (got2 != 16) { fail_id = 3; return 1; }
    got3 = y.a + y.b + y.c + y.d;
    if (got3 != 19) { fail_id = 4; return 1; }
    return 0;
}
