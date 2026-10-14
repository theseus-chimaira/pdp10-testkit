volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct rec {
    char a;
    short pad;
    char b[4];
    int tail;
};

static struct rec gr[3];

static void init_one(i, base)
int i;
int base;
{
    gr[i].a = (char)(base + 1);
    gr[i].pad = (short)(base + 2);
    gr[i].b[0] = (char)(base + 3);
    gr[i].b[1] = (char)(base + 4);
    gr[i].b[2] = (char)(base + 5);
    gr[i].b[3] = (char)(base + 6);
    gr[i].tail = base + 7;
}

static int fold_one(i)
int i;
{
    return gr[i].a + gr[i].pad + gr[i].b[0] + gr[i].b[1] +
           gr[i].b[2] + gr[i].b[3] + gr[i].tail;
}

int main()
{
    fail_id = 0;
    init_one(0, 10);
    init_one(1, 20);
    init_one(2, 30);
    got = fold_one(0);
    if (got != 98) { fail_id = 1; return 1; }
    got1 = fold_one(1);
    if (got1 != 168) { fail_id = 2; return 1; }
    got2 = fold_one(2);
    if (got2 != 238) { fail_id = 3; return 1; }
    gr[1].b[2] = (char)(gr[0].b[3] + gr[2].a);
    got3 = gr[1].b[2];
    if (got3 != 47) { fail_id = 4; return 1; }
    got4 = fold_one(1);
    if (got4 != 190) { fail_id = 5; return 1; }
    return 0;
}
