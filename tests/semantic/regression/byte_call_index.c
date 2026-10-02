volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
struct B { char a[9]; unsigned char u; int z; };
int sumchars(p, n) char *p; int n;
{
    int s;
    int i;
    s = 0;
    for (i = 0; i < n; ++i) s += p[i];
    return s;
}
int poke(p, i, v) char *p; int i; int v;
{
    p[i] = v;
    return p[i];
}
int main()
{
    struct B b;
    int i;
    fail_id = 0;
    for (i = 0; i < 9; ++i) b.a[i] = i + 1;
    b.u = 0377;
    b.z = 1000;
    got = sumchars(b.a, 9);
    if (got != 45) { fail_id = 1; return 1; }
    got1 = poke(b.a, 4, 44);
    if (got1 != 44) { fail_id = 2; return 1; }
    got2 = b.a[3] + b.a[4] + b.a[5];
    if (got2 != 54) { fail_id = 3; return 1; }
    got3 = b.u;
    if (got3 != 0377) { fail_id = 4; return 1; }
    got4 = b.z + b.a[8];
    if (got4 != 1009) { fail_id = 5; return 1; }
    return 0;
}
