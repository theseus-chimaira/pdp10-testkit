volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int add_at(p, i, v)
char *p;
int i;
int v;
{
    p[i] = (char)(p[i] + v);
    return p[i];
}

static int callit(fn, p, i, v)
int (*fn)();
char *p;
int i;
int v;
{
    return (*fn)(p, i, v) + p[0];
}

int main()
{
    char b[4];
    fail_id = 0;
    b[0] = 10;
    b[1] = 20;
    b[2] = 30;
    b[3] = 40;
    got = callit(add_at, b, 2, 7);
    if (got != 47) { fail_id = 1; return 1; }
    got1 = b[2];
    if (got1 != 37) { fail_id = 2; return 1; }
    return 0;
}
