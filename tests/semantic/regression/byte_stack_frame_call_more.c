volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;

static int touch(p, q, k)
char *p;
unsigned char *q;
int k;
{
    char tmp[4];
    int s;
    tmp[0] = (char)(k + 1);
    tmp[1] = (char)(k + 2);
    p[-2] = (char)(p[-1] + tmp[0]);
    q[2] = (unsigned char)(q[1] + tmp[1]);
    s = p[-2] + p[-1] + p[0] + p[1] + q[0] + q[1] + q[2];
    return s;
}

int main()
{
    char a[8];
    unsigned char b[8];
    int i;
    fail_id = 0;
    for (i = 0; i < 8; ++i) {
        a[i] = (char)(10 + i);
        b[i] = (unsigned char)(30 + i);
    }
    got = touch(&a[4], &b[3], 5);
    if (got != 19 + 13 + 14 + 15 + 33 + 34 + 41) { fail_id = 1; return 1; }
    got1 = a[2];
    if (got1 != 19) { fail_id = 2; return 1; }
    got2 = b[5];
    if (got2 != 41) { fail_id = 3; return 1; }
    got3 = touch(&a[3], &b[2], 1);
    if (got3 != 21 + 19 + 13 + 14 + 32 + 33 + 36) { fail_id = 4; return 1; }
    return 0;
}
