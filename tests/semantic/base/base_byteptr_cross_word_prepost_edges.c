volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

char gbuf[24];

struct holdptr {
    char *p;
    int bias;
};

static int walk(p, n)
char *p;
int n;
{
    int s;
    s = 0;
    while (n-- > 0) {
        s += *p;
        *p = (char)(*p + 1);
        ++p;
    }
    return s + (int)(p - gbuf);
}

static int prepost(h)
struct holdptr *h;
{
    int s;
    s = *h->p++;
    s += *h->p++;
    s += *++h->p;
    s += (int)(h->p - gbuf) + h->bias;
    return s;
}

int main()
{
    int i;
    struct holdptr h;
    fail_id = 0;
    for (i = 0; i < 24; ++i)
        gbuf[i] = (char)(i + 1);

    got = walk(&gbuf[2], 10);
    if (got != 87) { fail_id = 1; return 1; }
    if (gbuf[2] != 4 || gbuf[3] != 5 || gbuf[7] != 9 || gbuf[11] != 13) {
        fail_id = 2; return 1;
    }

    h.p = &gbuf[6];
    h.bias = 5;
    got1 = prepost(&h);
    if (got1 != 42) { fail_id = 3; return 1; }
    got2 = (int)(h.p - gbuf);
    if (got2 != 9) { fail_id = 4; return 1; }
    got3 = gbuf[4] + gbuf[8] + gbuf[12];
    if (got3 != 29) { fail_id = 5; return 1; }
    return 0;
}
