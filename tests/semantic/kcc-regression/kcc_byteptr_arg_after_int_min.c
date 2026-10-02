volatile int __test_exit;
volatile int fail_id;
volatile int got;
char ga[4];

static int get(flag, p)
int flag;
char *p;
{
    int s;
    s = 0;
    if (flag)
        s += *p;
    return s;
}

int main()
{
    fail_id = 0;
    ga[0] = 11;
    ga[1] = 22;
    got = get(1, &ga[1]);
    if (got != 22) { fail_id = 1; return 1; }
    return 0;
}
