volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

short gs[5] = { -3, 4, -5, 6, 7 };
unsigned short gu[5] = { 10, 11, 12, 13, 14 };

static int mutate(sp, up, n)
short *sp;
unsigned short *up;
int n;
{
    int i;
    int sum;
    sum = 0;
    for (i = 0; i < n; ++i) {
        sp[i] = (short)(sp[i] - i);
        up[i] = (unsigned short)(up[i] + i * 2);
        sum += sp[i] + up[i];
    }
    return sum;
}

int main()
{
    short ls[3];
    unsigned short lu[3];
    fail_id = 0;
    ls[0] = gs[1]; ls[1] = gs[2]; ls[2] = gs[3];
    lu[0] = gu[0]; lu[1] = gu[1]; lu[2] = gu[2];
    got = mutate(ls, lu, 3);
    if (got != 41) { fail_id = 1; return 1; }
    got1 = ls[0] + ls[1] + ls[2];
    if (got1 != 2) { fail_id = 2; return 1; }
    got2 = lu[0] + lu[1] + lu[2];
    if (got2 != 39) { fail_id = 3; return 1; }
    got3 = gs[0] + gs[4] + gu[4];
    if (got3 != 18) { fail_id = 4; return 1; }
    return 0;
}
