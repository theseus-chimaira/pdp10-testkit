volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain;
static u16 rd(u16 *p) { return *p; }
static void wr(u16 *p, u16 v) { *p = v; }
int main(void)
{
    struct outer *p = &x;
    p->pre = 025;
    p->post = 011;
    wr(p->a, 012345);
    wr(p->a + 1, 054321);
    wr(&plain, 076543);
    if (rd(p->a) != 012345) return 1;
    if (rd(p->a + 1) != 054321) return 2;
    if (rd(&plain) != 076543) return 3;
    if (p->pre != 025 || p->post != 011) return 4;
    return 0;
}
