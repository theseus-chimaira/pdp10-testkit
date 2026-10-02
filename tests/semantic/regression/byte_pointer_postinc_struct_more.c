volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

struct block {
    char a[5];
    int marker;
    unsigned char b[4];
};

static int fill_sum(bp)
struct block *bp;
{
    char *p;
    unsigned char *q;
    int i;
    int sum;
    p = bp->a;
    q = bp->b;
    sum = 0;
    for (i = 0; i < 5; ++i) {
        *p = (char)(i + 1);
        sum += *p++;
    }
    for (i = 0; i < 4; ++i) {
        *q = (unsigned char)(10 + i);
        sum += *q++;
    }
    return sum;
}

static int read_back(bp)
struct block *bp;
{
    char *p;
    unsigned char *q;
    int sum;
    p = &bp->a[4];
    q = &bp->b[3];
    sum = *p--;
    sum = sum * 10 + *p;
    sum = sum * 10 + *q--;
    sum = sum * 10 + *q;
    return sum;
}

int main()
{
    struct block x;
    fail_id = 0;
    x.marker = 1234;
    got = fill_sum(&x);
    if (got != 61) { fail_id = 1; return 1; }
    got1 = x.marker;
    if (got1 != 1234) { fail_id = 2; return 1; }
    got2 = read_back(&x);
    if (got2 != 5542) { fail_id = 3; return 1; }
    got3 = x.a[0] + x.a[4] + x.b[0] + x.b[3];
    if (got3 != 29) { fail_id = 4; return 1; }
    return 0;
}
