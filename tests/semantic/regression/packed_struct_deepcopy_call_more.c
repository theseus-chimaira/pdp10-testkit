volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct leaf {
    char c[3];
    short s;
    int x;
    unsigned char u;
};

struct node {
    char lead;
    struct leaf l[2];
    short tail[2];
    int mark;
    char bytes[5];
};

struct node ga[3];
struct node gb;

static void fill_leaf(lp, b)
struct leaf *lp;
int b;
{
    lp->c[0] = (char)(b + 2);
    lp->c[1] = (char)(b + 3);
    lp->c[2] = (char)(b + 4);
    lp->s = (short)(-(b + 5));
    lp->x = b + 6;
    lp->u = (unsigned char)(b + 7);
}

static void fill_node(np, b)
struct node *np;
int b;
{
    np->lead = (char)(b + 1);
    fill_leaf(&np->l[0], b);
    np->l[1].c[0] = (char)(b + 8);
    np->l[1].c[1] = (char)(b + 9);
    np->l[1].c[2] = (char)(b + 10);
    np->l[1].s = (short)(b + 11);
    np->l[1].x = b + 12;
    np->l[1].u = (unsigned char)(b + 13);
    np->tail[0] = (short)(-(b + 14));
    np->tail[1] = (short)(b + 15);
    np->mark = b + 16;
    np->bytes[0] = (char)(b + 17);
    np->bytes[1] = (char)(b + 18);
    np->bytes[2] = (char)(b + 19);
    np->bytes[3] = (char)(b + 20);
    np->bytes[4] = (char)(b + 21);
}

static int sum_leaf(lp)
struct leaf *lp;
{
    return lp->c[0] + lp->c[1] + lp->c[2] + lp->s + lp->x + lp->u;
}

static int sum_node(np)
struct node *np;
{
    return np->lead + sum_leaf(&np->l[0]) + sum_leaf(&np->l[1]) +
           np->tail[0] + np->tail[1] + np->mark +
           np->bytes[0] + np->bytes[1] + np->bytes[2] +
           np->bytes[3] + np->bytes[4];
}

static struct node make_node(b)
int b;
{
    struct node n;
    fill_node(&n, b);
    return n;
}

static struct node bump_node(n, k)
struct node n;
int k;
{
    n.lead = (char)(n.lead + k);
    n.l[0].c[1] = (char)(n.l[0].c[1] + k);
    n.l[1].s = (short)(n.l[1].s - k);
    n.bytes[3] = (char)(n.bytes[3] + k);
    n.mark = n.mark + k;
    return n;
}

int main()
{
    struct node local[3];
    fail_id = 0;
    fill_node(&ga[0], 2);
    fill_node(&ga[1], 20);
    local[0] = ga[0];
    local[1] = ga[1];
    gb = local[0];
    got = sum_node(&local[0]);
    if (got != 227) { fail_id = 1; return 1; }
    got1 = sum_node(&local[1]);
    if (got1 != 533) { fail_id = 2; return 1; }
    got2 = sum_node(&gb);
    if (got2 != 227) { fail_id = 3; return 1; }
    local[2] = make_node(40);
    got3 = sum_node(&local[2]);
    if (got3 != 873) { fail_id = 4; return 1; }
    gb = bump_node(local[2], 5);
    got4 = sum_node(&gb);
    if (got4 != 888) { fail_id = 5; return 1; }
    got5 = sum_node(&local[2]);
    if (got5 != 873) { fail_id = 6; return 1; }
    ga[2] = gb;
    ga[0] = ga[2];
    if (sum_node(&ga[0]) != 888) { fail_id = 7; return 1; }
    return 0;
}
