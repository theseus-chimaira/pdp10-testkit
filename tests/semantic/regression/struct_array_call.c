volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
struct P { int x; char y; int z; };
struct P gp[3];
int sum(p) struct P *p; { return p->x + p->y + p->z; }
int main()
{
    struct P lp[2];
    fail_id = 0;
    gp[0].x = 1; gp[0].y = 2; gp[0].z = 3;
    gp[1].x = 4; gp[1].y = 5; gp[1].z = 6;
    lp[0] = gp[0];
    lp[1] = gp[1];
    got = sum(&gp[0]);
    if (got != 6) { fail_id = 1; return 1; }
    got1 = sum(&lp[1]);
    if (got1 != 15) { fail_id = 2; return 1; }
    gp[2] = lp[0];
    gp[2].y = 9;
    got2 = sum(&gp[2]);
    if (got2 != 13) { fail_id = 3; return 1; }
    return 0;
}
