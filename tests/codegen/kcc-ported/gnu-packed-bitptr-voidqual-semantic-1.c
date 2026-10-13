volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;

int main(void)
{
    struct outer *p = &x;
    u16 *q;
    volatile u16 *vq;
    const volatile u16 *cvq;
    void *v;

    p->pre = 025;
    p->post = 011;
    p->a[0] = 012345;
    p->a[1] = 054321;

    q = (u16 *)(void *)p->a;
    if (q[0] != 012345 || q[1] != 054321) return 1;

    v = (void *)p->a;
    q = (u16 *)v;
    q[1] += 3;
    if (p->a[1] != 054324) return 2;

    vq = (volatile u16 *)q;
    *vq = 023456;
    if (p->a[0] != 023456) return 3;

    cvq = (const volatile u16 *)vq;
    if (*cvq != 023456) return 4;
    if (p->pre != 025 || p->post != 011) return 5;
    return 0;
}
