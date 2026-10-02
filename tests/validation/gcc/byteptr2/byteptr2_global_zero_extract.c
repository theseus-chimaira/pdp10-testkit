volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct pair {
    char left;
    char right;
    short s;
};

static struct pair gp[4];

static int sum_chars()
{
    int i;
    int s;
    s = 0;
    for (i = 0; i < 4; ++i)
        s += gp[i].left + gp[i].right;
    return s;
}

int main()
{
    int i;
    fail_id = 0;
    for (i = 0; i < 4; ++i) {
        gp[i].left = (char)(11 + i * 3);
        gp[i].right = (char)(12 + i * 5);
        gp[i].s = (short)(100 + i);
    }
    got = sum_chars();
    if (got != 140) { fail_id = 1; return 1; }
    got1 = gp[3].right - gp[0].left + gp[2].left;
    if (got1 != 33) { fail_id = 2; return 1; }
    gp[1].left = (char)(gp[3].right + 4);
    got2 = sum_chars();
    if (got2 != 157) { fail_id = 3; return 1; }
    return 0;
}
