volatile int __test_exit;
volatile int fail_id;
volatile int got;
char ga[6];

static int get(flag, p, q)
int flag;
char *p;
char *q;
{
    int s;
    s = 0;
    if (flag)
        s += *p;
    else
        s += *q;
    s += *p;
    s += *q;
    return s;
}

int main()
{
    fail_id = 0;
    ga[0] = 11;
    ga[1] = 22;
    ga[2] = 33;
    got = get(1, &ga[1], &ga[2]);
    if (got != 77) { fail_id = 1; return 1; }
    return 0;
}
