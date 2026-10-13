/* Preserved regression source from gnu-packed-nested-wholecopy.sh. */
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct inner {
    u16 x;
    unsigned int y:5;
    unsigned char z;
} __attribute__((packed));
struct outer {
    unsigned int pre:5;
    struct inner in;
    unsigned int post:6;
} __attribute__((packed));
static struct outer a[2] = {
    { 3, { 0123456, 021, 0255 }, 045 },
    { 7, { 0154321, 007, 0111 }, 017 }
};
int main(void)
{
    struct inner q;
    struct inner r;
    q.x = 076543;
    q.y = 013;
    q.z = 0222;
    a[0].in = q;
    if (a[0].pre != 3 || a[0].post != 045) return 1;
    if (a[0].in.x != 076543 || a[0].in.y != 013 || a[0].in.z != 0222) return 2;
    r = a[1].in;
    if (r.x != 0154321 || r.y != 007 || r.z != 0111) return 3;
    if (a[1].pre != 7 || a[1].post != 017) return 4;
    a[1].in = a[0].in;
    if (a[1].in.x != 076543 || a[1].in.y != 013 || a[1].in.z != 0222) return 5;
    if (a[1].pre != 7 || a[1].post != 017) return 6;
    if (a[0].pre != 3 || a[0].post != 045) return 7;
    return 0;
}
