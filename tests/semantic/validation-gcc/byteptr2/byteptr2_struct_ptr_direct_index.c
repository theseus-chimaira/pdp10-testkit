volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct node {
    short h;
    char data[5];
    char z;
};

static int get_direct(np, i)
struct node *np;
int i;
{
    return np->data[i & 3];
}

static void set_direct(np, i, v)
struct node *np;
int i;
int v;
{
    np->data[i & 3] = (char)v;
}

int main()
{
    struct node n;
    int i;
    fail_id = 0;
    n.h = 7;
    n.z = 9;
    for (i = 0; i < 5; ++i)
        n.data[i] = (char)(40 + i);
    got = get_direct(&n, 3);
    if (got != 43) { fail_id = 1; return 1; }
    set_direct(&n, 6, got + n.h);
    got1 = n.data[2];
    if (got1 != 50) { fail_id = 2; return 1; }
    got2 = get_direct(&n, 6) + n.data[0] + n.z;
    if (got2 != 99) { fail_id = 3; return 1; }
    return 0;
}
