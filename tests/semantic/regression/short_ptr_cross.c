volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
short gs[8];
unsigned short gu[8];
int main()
{
    short ls[8];
    unsigned short lu[8];
    short *p;
    unsigned short *q;
    int i;
    fail_id = 0;
    for (i = 0; i < 8; ++i) {
        gs[i] = i - 4;
        gu[i] = 0100000 + i;
        ls[i] = i + 11;
        lu[i] = 0177760 + i;
    }
    got = gs[0] + gs[7];
    if (got != -1) { fail_id = 1; return 1; }
    p = ls + 5;
    *(p - 2) = -12;
    got1 = ls[3];
    if (got1 != -12) { fail_id = 2; return 1; }
    q = gu;
    q += 6;
    q -= 4;
    *q = 0123456;
    got2 = gu[2];
    if (got2 != 0123456) { fail_id = 3; return 1; }
    got3 = lu[0] + lu[1];
    if (got3 != 0377741) { fail_id = 4; return 1; }
    got4 = gs[4] + ls[4] + gu[1];
    if (got4 != 0100020) { fail_id = 5; return 1; }
    return 0;
}
