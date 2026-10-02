volatile int __test_exit;
volatile int fail_id;
volatile int got;
char ga[6];

static int touch(p, k)
char *p;
int k;
{
    int old;
    old = *p;
    *p = (char)(old + k);
    return old * 10 + *p;
}

static int get(flag, p, q)
int flag;
char *p;
char *q;
{
    int s;
    s = 0;
    s += flag ? touch(p++, 3) : touch(--q, 4);
    return s;
}

int main()
{
    fail_id = 0;
    ga[0] = 10;
    ga[1] = 11;
    ga[2] = 12;
    ga[3] = 13;
    got = get(1, &ga[1], &ga[3]);
    if (got != 124) { fail_id = 1; return 1; }
    return 0;
}
