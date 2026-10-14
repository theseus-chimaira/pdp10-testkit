volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct localrec {
    short pre[2];
    char bytes[6];
    short post;
};

static int work(seed)
int seed;
{
    struct localrec lr;
    int i;
    int s;
    lr.pre[0] = (short)(seed + 1);
    lr.pre[1] = (short)(seed + 2);
    lr.post = (short)(seed + 3);
    for (i = 0; i < 6; ++i)
        lr.bytes[i] = (char)(seed + 10 + i);
    lr.bytes[2] = (char)(lr.bytes[0] + lr.pre[1]);
    lr.bytes[5] = (char)(lr.bytes[2] + lr.post);
    s = 0;
    for (i = 0; i < 6; ++i)
        s += lr.bytes[i];
    return s + lr.pre[0] + lr.post;
}

int main()
{
    fail_id = 0;
    got = work(3);
    if (got != 112) { fail_id = 1; return 1; }
    got1 = work(7);
    if (got1 != 156) { fail_id = 2; return 1; }
    return 0;
}
