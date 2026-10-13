volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[3];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
int main(void)
{
    struct outer *p = &x;
    u16 *q = p->a;
    u16 *r;
    int i = 2;

    p->pre = 025;
    p->post = 011;
    q[0] = 012345;
    q[1] = 054321;
    r = p->a;
    r[i] = 076543;
    if (*q != 012345) return 1;
    if (*(q + 1) != 054321) return 2;
    if (r[i] != 076543) return 3;
    q[1] += 7;
    if (q[1] != 054330) return 4;
    if ((r + 2) - r != 2) return 5;
    if (p->pre != 025 || p->post != 011) return 6;
    return 0;
}
