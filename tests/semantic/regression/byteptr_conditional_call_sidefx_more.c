volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct bufhold {
    char a[8];
    unsigned char b[8];
    int guard;
};

struct bufhold gh;
int sink;

static int touch(cp, k)
char *cp;
int k;
{
    int old;
    old = *cp;
    *cp = (char)(old + k);
    sink += *cp;
    return old * 10 + *cp;
}

static int utouch(cp, k)
unsigned char *cp;
int k;
{
    int old;
    old = *cp;
    *cp = (unsigned char)(old + k);
    sink += *cp;
    return *cp - old;
}

static int choose(flag, p, q)
int flag;
char *p;
char *q;
{
    int s;
    s = 0;
    s += flag ? touch(p++, 3) : touch(--q, 4);
    s += touch(p, 5);
    s += flag ? *p++ : *q--;
    s += touch(p, 6);
    s += (int)(p - q);
    return s;
}

static int uscan(flag, p)
int flag;
unsigned char *p;
{
    int s;
    s = 0;
    s += flag ? utouch(p++, 7) : utouch(++p, 8);
    s += utouch(p, 9);
    s += *p++;
    s += (int)(p - gh.b);
    return s;
}

static int sum_c(cp, n)
char *cp;
int n;
{
    int i;
    int s;
    s = 0;
    for (i = 0; i < n; ++i)
        s += cp[i];
    return s;
}

static int sum_uc(cp, n)
unsigned char *cp;
int n;
{
    int i;
    int s;
    s = 0;
    for (i = 0; i < n; ++i)
        s += cp[i];
    return s;
}

int main()
{
    char la[8];
    int i;
    fail_id = 0;
    sink = 0;
    for (i = 0; i < 8; ++i) {
        la[i] = (char)(10 + i);
        gh.a[i] = (char)(30 + i);
        gh.b[i] = (unsigned char)(50 + i);
    }
    gh.guard = 7777;
    got = choose(1, &la[1], &la[5]);
    if (got != 425) { fail_id = 1; return 1; }
    got1 = sum_c(la, 8);
    if (got1 != 122) { fail_id = 2; return 1; }
    got2 = choose(0, &gh.a[1], &gh.a[5]);
    if (got2 != 1162) { fail_id = 3; return 1; }
    got3 = sum_c(gh.a, 8);
    if (got3 != 283) { fail_id = 4; return 1; }
    got4 = uscan(1, &gh.b[2]) + uscan(0, &gh.b[3]);
    if (got4 != 175) { fail_id = 5; return 1; }
    got5 = sum_uc(gh.b, 8);
    if (got5 != 461) { fail_id = 6; return 1; }
    if (gh.guard != 7777) { fail_id = 7; return 1; }
    return 0;
}
