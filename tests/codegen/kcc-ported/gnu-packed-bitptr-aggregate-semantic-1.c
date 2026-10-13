volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct inner {
    u16 x;
    unsigned int b:3;
    unsigned char y;
} __attribute__((packed));
struct outer {
    unsigned int pre:5;
    struct inner in;
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
int main(void)
{
    struct outer *p = &x;
    struct inner *q = &p->in;
    struct inner *r;

    p->pre = 025;
    p->post = 011;
    q->x = 012345;
    q->b = 5;
    q->y = 0321;
    if (q->x != 012345) return 1;
    if (q->b != 5) return 2;
    if (q->y != 0321) return 3;
    if ((*q).x != 012345) return 010;
    q->x += 7;
    q->b ^= 3;
    if (q->x != 012354) return 4;
    if (q->b != 6) return 5;
    r = &p->in;
    r->y += 4;
    if (r->y != 0325) return 6;
    if (p->pre != 025 || p->post != 011) return 7;
    return 0;
}
