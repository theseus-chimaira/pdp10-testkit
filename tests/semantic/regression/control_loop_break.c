volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int main()
{
    int i;
    int s;
    fail_id = 0;
    s = 0;
    for (i = 0; i < 10; ++i) {
        if (i == 2) continue;
        if (i == 7) break;
        s += i;
    }
    got = s;
    if (got != 19) { fail_id = 1; return 1; }
    i = 0;
    s = 1;
    while (i < 5) {
        s *= 2;
        ++i;
    }
    got1 = s;
    if (got1 != 32) { fail_id = 2; return 1; }
    do {
        --i;
        s += i;
    } while (i > 0);
    got2 = s;
    if (got2 != 42) { fail_id = 3; return 1; }
    return 0;
}
