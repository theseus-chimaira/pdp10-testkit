volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
char ga[16];
int main()
{
    char la[16];
    char *p;
    int i;
    fail_id = 0;
    for (i = 0; i < 16; ++i) {
        ga[i] = i + 1;
        la[i] = 20 + i;
    }
    got = ga[3] + ga[4] + ga[7] + ga[8];
    if (got != 26) { fail_id = 1; return 1; }
    got1 = la[3] + la[4] + la[7] + la[8];
    if (got1 != 102) { fail_id = 2; return 1; }
    p = ga + 8;
    *(p - 5) = 77;
    --p;
    *p = 66;
    got2 = ga[3] + ga[7];
    if (got2 != 143) { fail_id = 3; return 1; }
    p = la;
    p += 12;
    p -= 4;
    *p = 55;
    got3 = la[8];
    if (got3 != 55) { fail_id = 4; return 1; }
    got4 = ga[15] + la[15];
    if (got4 != 51) { fail_id = 5; return 1; }
    return 0;
}
