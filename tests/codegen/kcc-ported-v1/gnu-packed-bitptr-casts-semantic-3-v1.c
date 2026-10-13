volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
typedef unsigned _KCCtype_char18 u18;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain;
static u18 *widen(u16 *p)
{
    return (u18 *)p;
}
static u16 *narrow(u18 *p)
{
    return (u16 *)p;
}
int main(void)
{
    u16 *q;
    x.a[0] = 012345;
    plain = 023456;
    q = narrow(widen(x.a));
    if (*q != 012345) return 1;
    q = narrow(widen(&plain));
    if (*q != 023456) return 2;
    return 0;
}
