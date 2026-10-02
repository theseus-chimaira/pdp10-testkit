volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct swent {
    char op;
    char val;
    short count;
    int total;
};

struct swent ga[5];

static int bump(ep, k)
struct swent *ep;
int k;
{
    ep->val = (char)(ep->val + k);
    ep->count = (short)(ep->count - k);
    return ep->val + ep->count;
}

static int run_switch(a, n)
struct swent *a;
int n;
{
    int i;
    int acc;
    acc = 0;
    for (i = 0; i < n; ++i) {
        switch (a[i].op) {
        case 1:
            a[i].val = (char)(a[i].val + 2);
            /* fall through */
        case 2:
            a[i].count = (short)(a[i].count + a[i].val);
            a[i].total = a[i].total + a[i].count;
            break;
        case 3:
            a[i].total = a[i].total + bump(&a[i], i + 1);
            break;
        case 4:
            a[i].op = 2;
            a[i].val = (char)(a[i].val + 1);
            continue;
        default:
            a[i].total = a[i].total - a[i].op;
            break;
        }
        acc = acc + a[i].val + a[i].count + a[i].total;
    }
    return acc;
}

int main()
{
    fail_id = 0;
    ga[0].op = 1; ga[0].val = 10; ga[0].count = 100; ga[0].total = 1000;
    ga[1].op = 2; ga[1].val = 20; ga[1].count = 200; ga[1].total = 2000;
    ga[2].op = 3; ga[2].val = 30; ga[2].count = 300; ga[2].total = 3000;
    ga[3].op = 4; ga[3].val = 40; ga[3].count = 400; ga[3].total = 4000;
    ga[4].op = 7; ga[4].val = 50; ga[4].count = 500; ga[4].total = 5000;

    got = run_switch(ga, 5);
    if (got != 12899) { fail_id = 1; return 1; }
    got1 = run_switch(ga, 5);
    if (got1 != 18547) { fail_id = 2; return 1; }
    got2 = ga[0].val + ga[0].count + ga[0].total;
    if (got2 != 1378) { fail_id = 3; return 1; }
    got3 = ga[2].val + ga[2].count + ga[2].total;
    if (got3 != 3990) { fail_id = 4; return 1; }
    got4 = ga[3].op + ga[3].val + ga[3].count + ga[3].total;
    if (got4 != 4925) { fail_id = 5; return 1; }
    got5 = ga[4].total;
    if (got5 != 4986) { fail_id = 6; return 1; }
    return 0;
}
