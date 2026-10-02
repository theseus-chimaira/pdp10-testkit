volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

static int score(x)
int x;
{
    int r;
    r = 0;
    switch (x) {
    case -3:
        r += 5;
        break;
    case 0:
        r += 1;
    case 1:
        r += 2;
        break;
    case 4:
        r += 10;
    case 5:
        r += 20;
        break;
    case 100:
        r += 7;
        break;
    default:
        r -= 4;
        break;
    }
    return r;
}

int main()
{
    fail_id = 0;
    got = score(-3) + score(0) + score(1);
    if (got != 10) { fail_id = 1; return 1; }
    got1 = score(4) + score(5);
    if (got1 != 50) { fail_id = 2; return 1; }
    got2 = score(100) + score(99);
    if (got2 != 3) { fail_id = 3; return 1; }
    got3 = score(7) + score(0) + score(4);
    if (got3 != 29) { fail_id = 4; return 1; }
    return 0;
}
