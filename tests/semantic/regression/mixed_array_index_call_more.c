volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

int gi;
int ga[6];
char gc[6];

static int next_index()
{
    gi = gi + 1;
    return gi;
}

static int add_store(ip, cp, k)
int *ip;
char *cp;
int k;
{
    *ip = *ip + k;
    *cp = (char)(*cp + k);
    return *ip + *cp;
}

int main()
{
    int i;
    fail_id = 0;
    gi = -1;
    for (i = 0; i < 6; ++i) {
        ga[i] = i * 10;
        gc[i] = (char)i;
    }
    i = next_index();
    got = next_index();
    got = add_store(&ga[i], &gc[got], 5);
    if (got != 11) { fail_id = 1; return 1; }
    i = next_index();
    got1 = next_index();
    got1 = add_store(&ga[i], &gc[got1], -2);
    if (got1 != 19) { fail_id = 2; return 1; }
    got2 = gi;
    if (got2 != 3) { fail_id = 3; return 1; }
    got3 = ga[0] + gc[1] + ga[2] + gc[3];
    if (got3 != 30) { fail_id = 4; return 1; }
    return 0;
}
