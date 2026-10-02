volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int classify(x)
unsigned char x;
{
    switch (x) {
    case 0:
        return 7;
    case 200:
        return 13;
    case 255:
        return 19;
    default:
        if (x > 128)
            return 23;
        return 29;
    }
}

int main()
{
    unsigned char a;
    unsigned char b;
    fail_id = 0;
    a = (unsigned char)200;
    b = (unsigned char)255;
    got = classify(a);
    if (got != 13) { fail_id = 1; return 1; }
    got1 = classify(b);
    if (got1 != 19) { fail_id = 2; return 1; }
    got2 = (a < b) ? 31 : 37;
    if (got2 != 31) { fail_id = 3; return 1; }
    return 0;
}
