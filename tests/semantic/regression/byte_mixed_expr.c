volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
unsigned char uca[6];
char ca[6];
int main()
{
    int i;
    fail_id = 0;
    for (i = 0; i < 6; ++i) {
        uca[i] = i + 1;
        ca[i] = 10 + i;
    }
    got = uca[0] + uca[1] * 4 + uca[2];
    if (got != 12) { fail_id = 1; return 1; }
    got1 = ca[5] - ca[1];
    if (got1 != 4) { fail_id = 2; return 1; }
    uca[4] += 7;
    got2 = uca[4];
    if (got2 != 12) { fail_id = 3; return 1; }
    ca[2] = ca[2] + uca[0] + uca[1];
    got3 = ca[2];
    if (got3 != 15) { fail_id = 4; return 1; }
    got4 = uca[0] + uca[1] + uca[2] + uca[3] + uca[4] + uca[5];
    if (got4 != 28) { fail_id = 5; return 1; }
    return 0;
}
