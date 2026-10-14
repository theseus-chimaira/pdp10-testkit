volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int calc(a, b, c)
unsigned char a;
unsigned short b;
short c;
{
    return ((int)a * 3) + ((int)b >> 2) - c;
}

int main()
{
    fail_id = 0;
    got = calc((unsigned char)250, (unsigned short)100, (short)17);
    if (got != 758) { fail_id = 1; return 1; }
    got1 = calc((unsigned char)17, (unsigned short)512, (short)44);
    if (got1 != 135) { fail_id = 2; return 1; }
    return 0;
}
