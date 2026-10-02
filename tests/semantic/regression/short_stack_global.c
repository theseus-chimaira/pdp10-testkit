volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
short gs[4];
unsigned short gu[4];
int main()
{
    short ls[4];
    unsigned short lu[4];
    fail_id = 0;
    ls[0] = -1;
    ls[1] = 012345;
    lu[0] = 0177777;
    lu[1] = 1;
    gs[0] = ls[0];
    gs[1] = ls[1];
    gu[0] = lu[0];
    gu[1] = lu[1];
    got = gs[0];
    if (got != -1) { fail_id = 1; return 1; }
    got1 = gs[1];
    if (got1 != 012345) { fail_id = 2; return 1; }
    got2 = gu[0];
    if (got2 != 0177777) { fail_id = 3; return 1; }
    got3 = gu[0] + gu[1];
    if (got3 != 0200000) { fail_id = 4; return 1; }
    return 0;
}
