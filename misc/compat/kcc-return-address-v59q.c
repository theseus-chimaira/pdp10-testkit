/* Called by the assembly oracle, which knows each exact return PC. */
extern void *alloca(unsigned int);
static volatile int sink;

static int __attribute__((noinline)) scratch(int n)
{
    volatile int a[4];
    a[0] = n;
    a[3] = a[0] + 1;
    return a[3];
}

void *ra_leaf(void)
{
    return __builtin_return_address(0);
}

void *ra_fixed(int n)
{
    void *first = __builtin_return_address(0);
    volatile int *p = &n;
    sink = scratch(*p);
    if (sink != n + 1 || first != __builtin_return_address(0))
        return 0;
    return first;
}

void *ra_dynamic(int n)
{
    void *first = __builtin_return_address(0);
    unsigned char *p = alloca(n);
    unsigned char *q = alloca(9);
    p[0] = 123;
    p[n-1] = 231;
    q[8] = 45;
    sink = scratch(n);
    if (sink != n + 1 || p[0] != 123 || p[n-1] != 231 || q[8] != 45)
        return 0;
    if (first != __builtin_return_address(0)) return 0;
    return first;
}

void *ra_deeper(void)
{
    return __builtin_return_address(1);
}
