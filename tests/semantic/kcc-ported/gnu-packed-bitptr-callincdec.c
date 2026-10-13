/* Preserved regression source from gnu-packed-bitptr-callincdec.sh. */
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[4];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain[4];
static int walk(u16 *p)
{
    register u16 *q = p;

    if (*q != p[0]) return 1;
    if (*++q != p[1]) return 2;
    if (*q++ != p[1]) return 3;
    if (*q != p[2]) return 4;
    if (*--q != p[1]) return 5;
    if (*q-- != p[1]) return 6;
    if (*q != p[0]) return 7;
    return 0;
}
int main(void)
{
    struct outer *p = &x;

    p->a[0] = 1;
    p->a[1] = 2;
    p->a[2] = 3;
    plain[0] = 4;
    plain[1] = 5;
    plain[2] = 6;
    if (walk(p->a)) return 1;
    if (walk(plain)) return 2;
    return 0;
}
