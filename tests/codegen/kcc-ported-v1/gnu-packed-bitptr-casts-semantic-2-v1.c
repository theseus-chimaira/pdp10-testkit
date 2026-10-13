volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain;
static u16 *roundtrip(u16 *p)
{
    void *v = (void *)p;
    return (u16 *)v;
}
int main(void)
{
    u16 *q;
    x.a[0] = 012345;
    plain = 023456;
    q = roundtrip(x.a);
    if (*q != 012345) return 1;
    q = roundtrip(&plain);
    if (*q != 023456) return 2;
    return 0;
}
