volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int f2i(f)
float f;
{
    return (int)f;
}

static int d2i(d)
double d;
{
    return (int)d;
}

static int i2f_roundtrip(i)
int i;
{
    float f;
    f = (float)i;
    return (int)f;
}

int main()
{
    fail_id = 0;
    got = f2i(12.75f);
    if (got != 12) { fail_id = 1; return 1; }
    got1 = f2i(-12.75f);
    if (got1 != -12) { fail_id = 2; return 1; }
    got2 = d2i(1000.5);
    if (got2 != 1000) { fail_id = 3; return 1; }
    got3 = d2i(-1000.5);
    if (got3 != -1000) { fail_id = 4; return 1; }
    got4 = i2f_roundtrip(12345);
    if (got4 != 12345) { fail_id = 5; return 1; }
    return 0;
}
