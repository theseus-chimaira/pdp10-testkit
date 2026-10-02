volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;

static char rc(x)
int x;
{
    return (char)(x + 3);
}

static unsigned char ruc(x)
int x;
{
    return (unsigned char)(x + 5);
}

static short rs(x)
int x;
{
    return (short)(x - 7);
}

static int use(a, b, c)
char a;
unsigned char b;
short c;
{
    return a + b + c;
}

int main()
{
    char ca[4];
    unsigned char ua[4];
    short sa[4];
    fail_id = 0;
    ca[0] = rc(4);
    ua[0] = ruc(10);
    sa[0] = rs(20);
    got = use(ca[0], ua[0], sa[0]);
    if (got != 35) { fail_id = 1; return 1; }
    ca[1] = rc(got);
    ua[1] = ruc(ca[1]);
    sa[1] = rs(ua[1]);
    got1 = ca[1] + ua[1] + sa[1];
    if (got1 != 38 + 43 + 36) { fail_id = 2; return 1; }
    got2 = use(rc(1), ruc(2), rs(30));
    if (got2 != 4 + 7 + 23) { fail_id = 3; return 1; }
    got3 = ca[0] + ua[0] + sa[0] + ca[1] + ua[1] + sa[1];
    if (got3 != 152) { fail_id = 4; return 1; }
    return 0;
}
