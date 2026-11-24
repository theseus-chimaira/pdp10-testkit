/* Canonical high36:low35 registers, duplicated high bit in memory.
 * Exercise unsigned and signed values through actual object boundaries.
 */
typedef unsigned long long U;
typedef long long S;
typedef unsigned long W;
union value { U u; S s; struct { W h,l; } w; };
static volatile union value saved = { 1180591620717411303431ULL };
static volatile U input = 1180591620717411303431ULL;
static U identity(U x) { return x; }
static W addr_arg(U x)
{
    union value *p = (union value *)&x;
    return p->w.l;
}
static U split(int a,int b,int c,U x) { return x + (U)(a+b+c); }
static U stack(int a,int b,int c,int d,U x) { return x + (U)(a+b+c+d); }
static void flip(volatile union value *p) { p->u ^= ~0ULL; }
int main(void)
{
    union value local;
    U x = input;
    U y = ~x;
    local.u = x;
    if (local.w.h != 0400000000000UL || local.w.l != 0400000000007UL) return 1;
    if (saved.w.h != local.w.h || saved.w.l != local.w.l) return 2;
    if (local.u != x || saved.u != x) return 3;
    if (identity(x) != x || addr_arg(x) != local.w.l) return 4;
    if (split(0,0,0,x) != x || stack(0,0,0,0,x) != x) return 5;
    flip(&saved);
    if (saved.u != y || saved.w.h != 0377777777777UL || saved.w.l != 0377777777770UL) return 6;
    saved.u ^= ~0ULL;
    if (saved.u != x || saved.w.l != 0400000000007UL) return 7;
    if ((~x)+1ULL != (0ULL-x)) return 8;
    local.s = -7LL;
    if (local.w.h != 0777777777777UL || local.w.l != 0777777777771UL || local.s != -7LL) return 9;
    return 0;
}
