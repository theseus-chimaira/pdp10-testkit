/* Preserved regression source from gnu-packed-nested-byvalue.sh. */
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct inner1 {
    u16 x;
    unsigned int y:5;
    unsigned char z;
} __attribute__((packed));
struct outer1 {
    unsigned int pre:5;
    struct inner1 in;
    unsigned int post:6;
} __attribute__((packed));
struct inner2 {
    u16 a;
    u16 b;
    u16 c;
} __attribute__((packed));
struct outer2 {
    unsigned int pre:7;
    struct inner2 in;
    unsigned int post:4;
} __attribute__((packed));
static struct outer1 o1 = { 3, { 0123456, 021, 0255 }, 045 };
static struct outer2 o2 = { 012, { 0111111, 0222222, 0333333 }, 013 };
static int sum1(struct inner1 v)
{
    return v.x + v.y + v.z;
}
static u16 sum2(struct inner2 v)
{
    return v.a + v.b + v.c;
}
static struct inner1 make1(void)
{
    struct inner1 v;
    v.x = 076543;
    v.y = 013;
    v.z = 0222;
    return v;
}
static struct inner2 make2(void)
{
    struct inner2 v;
    v.a = 044444;
    v.b = 055555;
    v.c = 066666;
    return v;
}
int main(void)
{
    int s1;
    u16 s2;
    s1 = sum1(o1.in);
    if (s1 != 0123456 + 021 + 0255) return 1;
    if (o1.pre != 3 || o1.post != 045) return 2;
    o1.in = make1();
    if (o1.in.x != 076543 || o1.in.y != 013 || o1.in.z != 0222) return 3;
    if (o1.pre != 3 || o1.post != 045) return 4;
    s2 = sum2(o2.in);
    if (s2 != (u16)(0111111 + 0222222 + 0333333)) return 5;
    if (o2.pre != 012 || o2.post != 013) return 6;
    o2.in = make2();
    if (o2.in.a != 044444 || o2.in.b != 055555 || o2.in.c != 066666) return 7;
    if (o2.pre != 012 || o2.post != 013) return 8;
    return 0;
}
