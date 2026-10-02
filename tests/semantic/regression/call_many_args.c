volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
int sum8(a,b,c,d,e,f,g,h) int a; int b; int c; int d; int e; int f; int g; int h; {
    return a + b*2 + c*3 + d*4 + e*5 + f*6 + g*7 + h*8;
}
int mixptr(p,n,a,b,c) int *p; int n; int a; int b; int c; {
    return p[0] + p[n] + a - b + c;
}
int twice(x) int x; { return x + x; }
int main()
{
    int a[5];
    int i;
    fail_id = 0;
    for (i = 0; i < 5; ++i) a[i] = i + 10;
    got = sum8(1,2,3,4,5,6,7,8);
    if (got != 204) { fail_id = 1; return 1; }
    got1 = mixptr(a,3,7,2,5);
    if (got1 != 33) { fail_id = 2; return 1; }
    got2 = sum8(twice(1), twice(2), 3, 4, a[0]-5, a[1]-5, a[2]-5, a[3]-5);
    if (got2 != 209) { fail_id = 3; return 1; }
    got3 = mixptr(a, 4, sum8(1,1,1,1,1,1,1,1), 10, twice(3));
    if (got3 != 56) { fail_id = 4; return 1; }
    return 0;
}
