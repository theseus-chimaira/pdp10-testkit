/* Preserved regression source from gnu-packed-bitptr-localmember.sh. */
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
struct req { u16 *input; };
static struct outer x;
static u16 plain[2];
static u16 *volatile saved;
static u16 *save_reload(u16 *p)
{
    saved = p;
    return saved;
}
static void store(u16 *buf, u16 v)
{
    struct req r;
    r.input = buf;
    r.input[0] = v;
}
int main(void)
{
    x.pre = 025;
    x.post = 011;
    x.a[0] = 1;
    x.a[1] = 2;
    plain[0] = 3;
    plain[1] = 4;
    store(x.a, 012345);
    store(plain, 045670);
    if (save_reload(x.a) != x.a) return 6;
    if (save_reload(plain) != plain) return 7;
    if (x.a[0] != 012345) return 1;
    if (x.a[1] != 2) return 2;
    if (plain[0] != 045670) return 3;
    if (plain[1] != 4) return 4;
    if (x.pre != 025 || x.post != 011) return 5;
    return 0;
}
