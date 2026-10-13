volatile int __test_exit;
typedef signed _KCCtype_char16 s16;
typedef unsigned _KCCtype_char16 u16;
typedef unsigned _KCCtype_char18 u18;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain;

static int signed_read(u16 *p)
{
    s16 *q = (s16 *)p;
    return *q;
}

static int const_read(u16 *p)
{
    const u16 *q = (const u16 *)p;
    return *q;
}

static u16 *same_cast(u16 *p)
{
    return (u16 *)(s16 *)p;
}

int main(void)
{
    struct outer *p = &x;
    u18 *wide;
    u16 *q;

    p->pre = 025;
    p->post = 011;
    p->a[0] = 012345;
    p->a[1] = 054321;
    plain = 023456;

    if (signed_read(p->a) != 012345) return 1;
    if (signed_read(&plain) != 023456) return 2;
    if (const_read(p->a) != 012345) return 3;
    if (const_read(&plain) != 023456) return 4;

    q = same_cast(p->a);
    if (*q != 012345) return 5;
    q = same_cast(&plain);
    if (*q != 023456) return 6;

    wide = (u18 *)p->a;
    q = (u16 *)wide;
    if (*q != 012345) return 7;
    if (p->pre != 025 || p->post != 011) return 8;
    return 0;
}
