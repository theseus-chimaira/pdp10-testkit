volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct casts {
    unsigned char uc;
    signed char sc;
    unsigned short us;
    short ss;
};

static int pack(cp, v)
struct casts *cp;
int v;
{
    cp->uc = (unsigned char)v;
    cp->sc = (signed char)(v - 20);
    cp->us = (unsigned short)(v * 4);
    cp->ss = (short)(v - 7);
    return cp->uc + cp->sc + cp->us + cp->ss;
}

int main()
{
    struct casts c;
    fail_id = 0;
    got = pack(&c, 50);
    if (got != 323) { fail_id = 1; return 1; }
    got1 = c.uc + c.sc + c.us + c.ss;
    if (got1 != 323) { fail_id = 2; return 1; }
    return 0;
}
