volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

#ifdef __COMPILER_KCC__
#define EXPECT_MIXED_SUM 463
#else
#define EXPECT_MIXED_SUM (-49 + 150 - 150)
#endif

struct one {
    int a;
};

struct two {
    int a;
    int b;
};

struct mixed {
    char c;
    short s;
    int i;
};

static struct one ret_one(x)
int x;
{
    struct one r;
    r.a = x + 3;
    return r;
}

static struct two ret_two(x, y)
int x;
int y;
{
    struct two r;
    r.a = x + y;
    r.b = x - y;
    return r;
}

static struct mixed ret_mixed(x)
int x;
{
    struct mixed r;
    r.c = (char)(x + 1);
    r.s = (short)(x + 200);
    r.i = x * 3;
    return r;
}

int main()
{
    struct one a;
    struct two b;
    struct mixed c;
    fail_id = 0;
    a = ret_one(9);
    b = ret_two(20, 7);
    c = ret_mixed(-50);
    got = a.a;
    if (got != 12) { fail_id = 1; return 1; }
    got1 = b.a + b.b;
    if (got1 != 40) { fail_id = 2; return 1; }
    got2 = (int)c.c + (int)c.s + c.i;
    if (got2 != EXPECT_MIXED_SUM) { fail_id = 3; return 1; }
    return 0;
}
