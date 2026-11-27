/* GNU union casts select by type and evaluate the operand once. */
union U { int i; double d; unsigned long long w; char c; int *p; };
static int calls;
static int x = 33;
static union U si = (union U)(19 + 23);
static union U sd = (union U)2.5;
static union U sw = (union U)(1ULL << 45);
static union U sp = (union U)&x;
static int f(void) { ++calls; return 42; }
static union U wrap(int n) { return (union U)n; }
int main(void)
{
    union U u;
    static union U local = (union U)77;
    volatile int v = 51;
    u = (union U)f();
    if (u.i != 42 || calls != 1) return 1;
    (void)(union U)f();
    if (calls != 2) return 2;
    u = (union U)v++;
    if (v != 52 || u.i != 51) return 3;
    u = (union U)2.5;
    if (u.d != 2.5) return 4;
    u = (union U)(1ULL << 45);
    if (u.w != (1ULL << 45)) return 5;
    u = (union U)(char)0377;
    if (u.c != (char)0377) return 6;
    u = (union U)&x;
    if (u.p != &x || *u.p != 33) return 7;
    u = wrap(77);
    if (u.i != 77) return 8;
    if (((union U)f()).i != 42 || calls != 3) return 9;
    if (sizeof((union U)f()) != sizeof(union U) || calls != 3) return 10;
    if (si.i != 42 || sd.d != 2.5 || sw.w != (1ULL << 45)
        || sp.p != &x || local.i != 77) return 11;
    return 0;
}
