volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

char gc[32];
unsigned char gu[32];

static int walk_c(p, q)
char *p;
char *q;
{
    int s;
    s = (int)(q - p);
    s += q[-1];
    s += p[1];
    q -= 5;
    s += (int)(q - p);
    s += *q;
    return s;
}

static int walk_u(p, q)
unsigned char *p;
unsigned char *q;
{
    int s;
    s = (int)(q - p);
    s += q[-2];
    s += p[2];
    q -= 7;
    s += (int)(q - p);
    s += *q;
    return s;
}

int main()
{
    int i;
    fail_id = 0;
    for (i = 0; i < 32; ++i) {
        gc[i] = (char)(i + 1);
        gu[i] = (unsigned char)(100 + i);
    }
    got = walk_c(&gc[3], &gc[19]);
    if (got != 66) { fail_id = 1; return 1; }
    got1 = walk_u(&gu[4], &gu[27]);
    if (got1 != 390) { fail_id = 2; return 1; }
    got2 = (int)(&gc[31] - &gc[0]);
    if (got2 != 31) { fail_id = 3; return 1; }
    got3 = (int)(&gu[0] - &gu[31]);
    if (got3 != -31) { fail_id = 4; return 1; }
    return 0;
}
