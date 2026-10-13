/* Preserved regression source from gnu-packed-array-decay-bitptr.sh. */
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
    int i;
    p->pre = 025;
    p->post = 011;
    *(p->a + 0) = 012345;
    *(p->a + 1) = 054321;
    i = 2;
    *(p->a + i) = 076543;
    if (*(p->a + 0) != 012345) return 1;
    if (*(p->a + 1) != 054321) return 2;
    if (*(p->a + i) != 076543) return 3;
    if ((p->a + 2) - p->a != 2) return 4;
    if (p->pre != 025 || p->post != 011) return 5;
    return 0;
}
