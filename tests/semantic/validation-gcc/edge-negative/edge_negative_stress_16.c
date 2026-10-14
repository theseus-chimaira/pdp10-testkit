volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

int main()
{
    unsigned char c;
    unsigned short s;
    fail_id = 0;
    c = (unsigned char)(21 + 41);
    s = (unsigned short)(21 * 41);
    got = c + s;
    if (got != 923) { fail_id = 1; return 1; }
    return 0;
}
