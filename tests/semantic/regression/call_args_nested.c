volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int add3(a,b,c) int a; int b; int c; { return a + b + c; }
int scale(p,n) int *p; int n; { return p[0] + p[n]; }
int twice(x) int x; { return x * 2; }
int main()
{
    int a[4];
    fail_id = 0;
    a[0] = 5; a[1] = 7; a[2] = 11; a[3] = 13;
    got = add3(1,2,3);
    if (got != 6) { fail_id = 1; return 1; }
    got1 = scale(a,2);
    if (got1 != 16) { fail_id = 2; return 1; }
    got2 = twice(add3(2,3,4));
    if (got2 != 18) { fail_id = 3; return 1; }
    got3 = add3(scale(a,1), scale(a,3), 1);
    if (got3 != 31) { fail_id = 4; return 1; }
    return 0;
}
