volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct S {
    unsigned int pre:5;
    u16 x;
    unsigned int post:3;
} __attribute__((packed));
struct B {
    unsigned int a:5;
    unsigned int b:16;
    unsigned int c:7;
} __attribute__((packed));
static struct S s;
static struct B b;
static u16 rds(void) { return s.x; }
static void wrs(u16 x) { s.x = x; }
static unsigned rdb(void) { return b.b; }
static void wrb(unsigned x) { b.b = x; }
int main(void)
{
    s.pre = 025;
    s.post = 5;
    wrs(012345);
    if (rds() != 012345) return 1;
    if (s.pre != 025 || s.post != 5) return 2;
    b.a = 021;
    b.c = 0105;
    wrb(054321);
    if (rdb() != 054321) return 3;
    if (b.a != 021 || b.c != 0105) return 4;
    wrs(076543);
    wrb(012345);
    if (rds() != 076543 || rdb() != 012345) return 5;
    if (s.pre != 025 || s.post != 5 || b.a != 021 || b.c != 0105) return 6;
    return 0;
}
