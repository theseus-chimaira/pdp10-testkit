volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static char retc(x)
int x;
{
    return (char)(x + 1);
}

static short rets(x)
int x;
{
    return (short)(x + 2);
}

static int mix(a, b, c, d, e, f)
char a;
short b;
int c;
char d;
short e;
int f;
{
    return a + b + c - d + e + f;
}

int main()
{
    fail_id = 0;
    got = retc(12);
    if (got != 13) { fail_id = 1; return 1; }
    got1 = rets(23);
    if (got1 != 25) { fail_id = 2; return 1; }
    got2 = mix((char)got, (short)got1, 276, (char)12, (short)23, 9);
    if (got2 != 334) { fail_id = 3; return 1; }
    return 0;
}
