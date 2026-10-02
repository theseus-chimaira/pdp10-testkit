volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

char ga[8];
unsigned char gu[8];

static int walk_back(p, q)
char *p;
unsigned char *q;
{
    int sum;
    sum = p[0] + p[-1] + p[-2];
    q[0] = (unsigned char)(q[-1] + q[-2]);
    return sum + q[0];
}

int main()
{
    int i;
    char local[8];
    unsigned char uloc[8];
    fail_id = 0;
    for (i = 0; i < 8; ++i) {
        ga[i] = (char)(i + 1);
        gu[i] = (unsigned char)(10 + i);
        local[i] = (char)(20 + i);
        uloc[i] = (unsigned char)(30 + i);
    }
    got = walk_back(&ga[4], &gu[4]);
    if (got != 5 + 4 + 3 + 25) { fail_id = 1; return 1; }
    got1 = gu[4];
    if (got1 != 25) { fail_id = 2; return 1; }
    got2 = walk_back(&local[5], &uloc[5]);
    if (got2 != 25 + 24 + 23 + 67) { fail_id = 3; return 1; }
    got3 = uloc[5];
    if (got3 != 67) { fail_id = 4; return 1; }
    return 0;
}
