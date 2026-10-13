/* Preserved regression source from gnu-packed-array-bitoffset.sh. */
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[3];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x[2];
int main(void)
{
    struct outer *p;
    int i;
    p = x;
    p->pre = 025;
    p->post = 011;
    for (i = 0; i < 3; ++i)
        p->a[i] = 010000 + i;
    if (p->pre != 025 || p->post != 011) return 1;
    if (p->a[0] != 010000 || p->a[1] != 010001 || p->a[2] != 010002) return 2;
    i = 1;
    p->a[i] += 7;
    if (p->a[1] != 010010) return 3;
    if (p->pre != 025 || p->post != 011) return 4;
    ++p;
    p->pre = 03;
    p->post = 07;
    i = 2;
    p->a[i] = 065432;
    if (p->a[2] != 065432 || p->pre != 03 || p->post != 07) return 5;
    return 0;
}
