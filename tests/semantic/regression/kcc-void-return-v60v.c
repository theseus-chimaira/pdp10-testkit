/* GNU compatibility: discard the return value, not its side effects. */
static volatile int n;
static int f(void) { ++n; return 42; }
static void g(void) { return f(); }
static void h(void) { return n++; }
static void i(void) { return (void)f(); }
static void j(void) { return 73; }
static void k(void) { return (n += 3, 5); }
struct S { int a, b, c; };
static struct S aggregate(void)
{
    struct S s = { 1, 2, 3 };
    ++n;
    return s;
}
static void l(void) { return aggregate(); }
int main(void)
{
    g();
    if (n != 1) return 1;
    h();
    if (n != 2) return 2;
    i();
    if (n != 3) return 3;
    j();
    if (n != 3) return 4;
    k();
    if (n != 6) return 5;
    l();
    return n != 7;
}
