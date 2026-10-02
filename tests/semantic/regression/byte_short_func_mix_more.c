volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;

struct node {
    unsigned char key;
    char delta;
    short sval;
    unsigned short uval;
};

static int mutate(n, count, bias)
struct node *n;
int count;
int bias;
{
    int i;
    int sum;
    sum = 0;
    for (i = 0; i < count; ++i) {
        n[i].key = (unsigned char)(n[i].key + bias + i);
        n[i].delta = (char)(n[i].delta - i);
        n[i].sval = (short)(n[i].sval + n[i].delta);
        n[i].uval = (unsigned short)(n[i].uval + n[i].key);
        sum += n[i].key + n[i].delta + n[i].sval + n[i].uval;
    }
    return sum;
}

int main()
{
    struct node n[3];
    n[0].key = 3; n[0].delta = 4; n[0].sval = 10; n[0].uval = 20;
    n[1].key = 5; n[1].delta = 7; n[1].sval = 11; n[1].uval = 21;
    n[2].key = 9; n[2].delta = 2; n[2].sval = 12; n[2].uval = 22;
    got = mutate(n, 3, 2);
    if (got != 168) { fail_id = 1; return 1; }
    got1 = n[1].key + n[1].delta + n[1].sval + n[1].uval;
    if (got1 != 60) { fail_id = 2; return 1; }
    got2 = mutate(&n[1], 2, -1);
    if (got2 != 1167) { fail_id = 3; return 1; }
    return 0;
}
