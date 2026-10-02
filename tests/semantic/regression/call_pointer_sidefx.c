volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int addat(p,i,v) int *p; int i; int v; { p[i] += v; return p[i]; }
int swapadd(p,q) int *p; int *q; { int t; t = *p; *p = *q + 1; *q = t + 2; return *p + *q; }
int choose(p,q,n) int *p; int *q; int n; { if (n) return *p; return *q; }
int main()
{
    int a[4];
    int b[4];
    fail_id = 0;
    a[0] = 3; a[1] = 5; a[2] = 7; a[3] = 9;
    b[0] = 20; b[1] = 30; b[2] = 40; b[3] = 50;
    got = addat(a, 2, 11);
    if (got != 18) { fail_id = 1; return 1; }
    got1 = swapadd(&a[1], &b[2]);
    if (got1 != 48) { fail_id = 2; return 1; }
    got2 = a[1];
    if (got2 != 41) { fail_id = 3; return 1; }
    got3 = b[2];
    if (got3 != 7) { fail_id = 4; return 1; }
    got4 = choose(&a[2], &b[0], 1) + choose(&a[2], &b[0], 0);
    if (got4 != 38) { fail_id = 5; return 1; }
    return 0;
}
