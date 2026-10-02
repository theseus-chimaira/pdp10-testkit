volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int gi[5];
char gc[5];
int main()
{
    int li[5];
    char lc[5];
    int i;
    fail_id = 0;
    for (i = 0; i < 5; ++i) {
        gi[i] = i + 10;
        li[i] = i + 20;
        gc[i] = i + 1;
        lc[i] = i + 6;
    }
    got = gi[4];
    if (got != 14) { fail_id = 1; return 1; }
    got1 = li[3];
    if (got1 != 23) { fail_id = 2; return 1; }
    got2 = gc[0] + gc[4];
    if (got2 != 6) { fail_id = 3; return 1; }
    got3 = lc[1] + lc[2];
    if (got3 != 15) { fail_id = 4; return 1; }
    got4 = gi[1] + li[1] + gc[1] + lc[1];
    if (got4 != 41) { fail_id = 5; return 1; }
    return 0;
}
