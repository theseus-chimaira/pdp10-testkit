volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

char gc;
unsigned char guc;
short gs;
unsigned short gus;

static char ret_c(x)
int x;
{
    return (char)x;
}

static unsigned char ret_uc(x)
int x;
{
    return (unsigned char)x;
}

static short ret_s(x)
int x;
{
    return (short)x;
}

static unsigned short ret_us(x)
int x;
{
    return (unsigned short)x;
}

int main()
{
    fail_id = 0;
    gc = ret_c(-7);
    guc = ret_uc(0377);
    gs = ret_s(-01234);
    gus = ret_us(077777);
    got = gc;
    if (got != 0771) { fail_id = 1; return 1; }
    got1 = guc;
    if (got1 != 0377) { fail_id = 2; return 1; }
    got2 = gs;
    if (got2 != -01234) { fail_id = 3; return 1; }
    got3 = gus;
    if (got3 != 077777) { fail_id = 4; return 1; }
    return 0;
}
