volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int heavy(a, b, c, d)
int a;
int b;
int c;
int d;
{
    return ((a * b) / c) + (d % 7);
}

static int use_ptr(p, n)
char *p;
int n;
{
    int x;
    x = heavy(35 + n, 9, 4, 23 + n);
    p[1] = (char)(p[1] + x);
    return p[0] + p[1] + p[2];
}

int main()
{
    char buf[5];
    int i;
    fail_id = 0;
    for (i = 0; i < 5; ++i)
        buf[i] = (char)(5 + i);
    got = use_ptr(&buf[1], 2);
    if (got != 108) { fail_id = 1; return 1; }
    got1 = buf[2];
    if (got1 != 94) { fail_id = 2; return 1; }
    return 0;
}
