volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
struct I { int x; char c; short s; };
struct O { struct I in[2]; int tail; char tag[3]; };
struct O go[2];
int isum(p) struct I *p; { return p->x + p->c + p->s; }
int fill(o,base) struct O *o; int base; {
    o->in[0].x = base;
    o->in[0].c = base + 1;
    o->in[0].s = base + 2;
    o->in[1].x = base + 3;
    o->in[1].c = base + 4;
    o->in[1].s = base + 5;
    o->tail = base + 6;
    o->tag[0] = base + 7;
    o->tag[1] = base + 8;
    o->tag[2] = base + 9;
    return 0;
}
int main()
{
    struct O lo[2];
    fail_id = 0;
    fill(&go[0], 1);
    fill(&go[1], 20);
    lo[0] = go[0];
    lo[1] = go[1];
    got = isum(&lo[0].in[0]);
    if (got != 6) { fail_id = 1; return 1; }
    got1 = isum(&lo[1].in[1]);
    if (got1 != 72) { fail_id = 2; return 1; }
    got2 = lo[0].tag[0] + lo[0].tag[1] + lo[0].tag[2];
    if (got2 != 27) { fail_id = 3; return 1; }
    go[1] = lo[0];
    go[1].in[1].c = 17;
    got3 = isum(&go[1].in[1]);
    if (got3 != 27) { fail_id = 4; return 1; }
    got4 = go[1].tail + go[1].tag[1];
    if (got4 != 16) { fail_id = 5; return 1; }
    return 0;
}
