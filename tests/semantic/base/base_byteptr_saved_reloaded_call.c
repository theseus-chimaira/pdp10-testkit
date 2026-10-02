volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct bpbox {
    char *p;
    unsigned char *u;
    int bias;
};

char gc[16];
unsigned char gu[16];
struct bpbox gb;

static int touch(b, k)
struct bpbox b;
int k;
{
    int s;
    s = *b.p++;
    s += *b.p;
    *b.p = (char)(*b.p + k);
    s += *b.u++;
    s += *b.u;
    *b.u = (unsigned char)(*b.u + k + 1);
    s += b.bias;
    s += (int)(b.p - gc) + (int)(b.u - gu);
    return s;
}

static int mutate(bp, k)
struct bpbox *bp;
int k;
{
    int s;
    s = *bp->p++;
    s += *++bp->p;
    *bp->p = (char)(*bp->p + k);
    s += *bp->u++;
    s += *++bp->u;
    *bp->u = (unsigned char)(*bp->u + k + 2);
    bp->bias += (int)(bp->p - gc) + (int)(bp->u - gu);
    return s + bp->bias;
}

int main()
{
    int i;
    fail_id = 0;
    for (i = 0; i < 16; ++i) {
        gc[i] = (char)(10 + i);
        gu[i] = (unsigned char)(40 + i);
    }
    gb.p = &gc[4];
    gb.u = &gu[5];
    gb.bias = 7;
    got = touch(gb, 3);
    if (got != 138) { fail_id = 1; return 1; }
    if ((int)(gb.p - gc) != 4 || (int)(gb.u - gu) != 5) { fail_id = 2; return 1; }
    got1 = mutate(&gb, 5);
    if (got1 != 142) { fail_id = 3; return 1; }
    got2 = (int)(gb.p - gc) + (int)(gb.u - gu) + gb.bias;
    if (got2 != 33) { fail_id = 4; return 1; }
    got3 = gc[5] + gc[6] + gc[7];
    if (got3 != 56) { fail_id = 5; return 1; }
    got4 = gu[6] + gu[7] + gu[8];
    if (got4 != 152) { fail_id = 6; return 1; }
    return 0;
}
