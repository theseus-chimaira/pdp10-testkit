volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct sh {
    unsigned char a;
    unsigned char b;
    short s;
};

static int do_shift(sp)
struct sh *sp;
{
    return ((int)sp->a << 2) + ((int)sp->b >> 1) + (sp->s << 1);
}

int main()
{
    struct sh s;
    fail_id = 0;
    s.a = (unsigned char)63;
    s.b = (unsigned char)200;
    s.s = (short)17;
    got = do_shift(&s);
    if (got != 386) { fail_id = 1; return 1; }
    s.a = (unsigned char)(s.a + 5);
    got1 = do_shift(&s);
    if (got1 != 406) { fail_id = 2; return 1; }
    return 0;
}
