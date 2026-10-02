volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct item {
    char tag;
    short v[3];
    char bytes[6];
};

static int bump(ip, idx, add)
struct item *ip;
int idx;
int add;
{
    ip->bytes[idx] = (char)(ip->bytes[idx] + add);
    return ip->bytes[idx];
}

static int fold(ip)
struct item *ip;
{
    int i;
    int s;
    s = ip->tag;
    for (i = 0; i < 6; ++i)
        s += ip->bytes[i];
    return s + ip->v[0] - ip->v[1] + ip->v[2];
}

int main()
{
    struct item it;
    int i;
    fail_id = 0;
    it.tag = (char)11;
    it.v[0] = (short)28;
    it.v[1] = (short)29;
    it.v[2] = (short)30;
    for (i = 0; i < 6; ++i)
        it.bytes[i] = (char)(11 + i * 2);
    got = bump(&it, 2, 28);
    if (got != 43) { fail_id = 1; return 1; }
    got1 = bump(&it, 4, 30);
    if (got1 != 49) { fail_id = 2; return 1; }
    got2 = fold(&it);
    if (got2 != 194) { fail_id = 3; return 1; }
    got3 = got * 3 + got1 - it.bytes[0];
    if (got3 != 167) { fail_id = 4; return 1; }
    got4 = got2 + got3;
    if (got4 != 361) { fail_id = 5; return 1; }
    return 0;
}
