volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct tiny {
    char c[4];
    unsigned char u;
    short s;
};

struct pack {
    char lead;
    struct tiny t[3];
    short sh[3];
    int marker;
    char tail[7];
};

struct pack ga[4];
struct pack gb;

static void fill_tiny(tp, b)
struct tiny *tp;
int b;
{
    tp->c[0] = (char)(b + 1);
    tp->c[1] = (char)(b + 2);
    tp->c[2] = (char)(b + 3);
    tp->c[3] = (char)(b + 4);
    tp->u = (unsigned char)(b + 5);
    tp->s = (short)(b - 6);
}

static void fill_pack(pp, b)
struct pack *pp;
int b;
{
    int i;
    pp->lead = (char)(b + 10);
    for (i = 0; i < 3; ++i)
        fill_tiny(&pp->t[i], b + i * 10);
    pp->sh[0] = (short)(b + 40);
    pp->sh[1] = (short)(-(b + 41));
    pp->sh[2] = (short)(b + 42);
    pp->marker = b + 1000;
    for (i = 0; i < 7; ++i)
        pp->tail[i] = (char)(b + 50 + i);
}

static int sum_tiny(tp)
struct tiny *tp;
{
    return tp->c[0] + tp->c[1] + tp->c[2] + tp->c[3] + tp->u + tp->s;
}

static int sum_pack(pp)
struct pack *pp;
{
    int i;
    int s;
    s = pp->lead + pp->marker;
    for (i = 0; i < 3; ++i)
        s += sum_tiny(&pp->t[i]) + pp->sh[i];
    for (i = 0; i < 7; ++i)
        s += pp->tail[i];
    return s;
}

static struct pack make_pack(b)
int b;
{
    struct pack p;
    fill_pack(&p, b);
    return p;
}

static struct pack pass_pack(p, k)
struct pack p;
int k;
{
    p.lead = (char)(p.lead + k);
    p.t[1].c[2] = (char)(p.t[1].c[2] + k);
    p.t[2].s = (short)(p.t[2].s - k);
    p.sh[1] = (short)(p.sh[1] + k);
    p.tail[5] = (char)(p.tail[5] + k);
    p.marker = p.marker + k;
    return p;
}

int main()
{
    struct pack local[4];
    fail_id = 0;
    fill_pack(&ga[0], 3);
    fill_pack(&ga[1], 13);
    local[0] = ga[0];
    local[1] = make_pack(23);
    ga[2] = pass_pack(local[0], 4);
    local[2] = pass_pack(local[1], 5);
    gb = ga[2];
    local[3] = gb;
    got = sum_pack(&local[0]);
    if (got != 1713) { fail_id = 1; return 1; }
    got1 = sum_pack(&local[1]);
    if (got1 != 2273) { fail_id = 2; return 1; }
    got2 = sum_pack(&ga[2]);
    if (got2 != 1729) { fail_id = 3; return 1; }
    got3 = sum_pack(&local[2]);
    if (got3 != 2293) { fail_id = 4; return 1; }
    got4 = sum_pack(&local[3]);
    if (got4 != 1729) { fail_id = 5; return 1; }
    ga[3] = local[2];
    ga[1] = ga[3];
    got5 = sum_pack(&ga[1]);
    if (got5 != 2293) { fail_id = 6; return 1; }
    if (sum_pack(&local[1]) != 2273) { fail_id = 7; return 1; }
    return 0;
}
