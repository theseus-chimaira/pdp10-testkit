volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct item {
    char op;
    unsigned char ix;
    char data[9];
};

struct item gi[5];

static int act(ip, p)
struct item *ip;
char *p;
{
    int s;
    s = 0;
    switch (ip->op) {
    case 1:
        s += *p++;
        s += ip->data[ip->ix & 7];
        break;
    case 2:
        s += *++p;
        ip->ix = (unsigned char)(ip->ix + 3);
        /* fall through */
    case 3:
        s += p[2];
        s += ip->ix;
        break;
    default:
        s += p[-1];
        s += ip->op;
        break;
    }
    s += (int)(p - ip->data);
    return s;
}

int main()
{
    int i, j;
    fail_id = 0;
    for (i = 0; i < 5; ++i) {
        gi[i].op = (char)(i + 1);
        gi[i].ix = (unsigned char)(i + 2);
        for (j = 0; j < 9; ++j)
            gi[i].data[j] = (char)(10 + i * 10 + j);
    }
    got = act(&gi[0], &gi[0].data[3]);
    if (got != 29) { fail_id = 1; return 1; }
    got1 = act(&gi[1], &gi[1].data[3]);
    if (got1 != 60) { fail_id = 2; return 1; }
    got2 = act(&gi[2], &gi[2].data[3]);
    if (got2 != 42) { fail_id = 3; return 1; }
    got3 = act(&gi[3], &gi[3].data[3]);
    if (got3 != 49) { fail_id = 4; return 1; }
    return 0;
}
