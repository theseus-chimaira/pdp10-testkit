volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct inner {
    char c;
    short s;
};

struct outer {
    int a;
    struct inner in[3];
    char tail;
};

union uval {
    int i;
    char c[5];
};

struct outer go;
union uval gu;

int main()
{
    fail_id = 0;
    go.a = 100;
    go.in[0].c = (char)1;
    go.in[0].s = (short)20;
    go.in[1].c = (char)2;
    go.in[1].s = (short)30;
    go.in[2].c = (char)3;
    go.in[2].s = (short)40;
    go.tail = (char)9;
    gu.i = 0;
    gu.c[0] = (char)7;
    gu.c[1] = (char)8;
    got = sizeof(go);
    if (got <= 0) { fail_id = 1; return 1; }
    got1 = go.a + go.in[0].c + go.in[1].s + go.in[2].c + go.tail;
    if (got1 != 143) { fail_id = 2; return 1; }
    got2 = gu.c[0] + gu.c[1];
    if (got2 != 15) { fail_id = 3; return 1; }
    got3 = (int)((char *)&go.tail - (char *)&go.a);
    if (got3 <= 0) { fail_id = 4; return 1; }
    return 0;
}
