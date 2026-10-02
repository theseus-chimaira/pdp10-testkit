volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
struct P { int x; char y; int z; };
struct P gp[2];
int sum(p) struct P *p; { return p->x + p->y + p->z; }
int main()
{
    struct P lp[2];
    fail_id = 0;
    gp[1].x = 4;
    gp[1].y = 5;
    gp[1].z = 6;
    lp[1] = gp[1];
    got = sum(&lp[1]);
    if (got != 15) { fail_id = 1; return 1; }
    return 0;
}
