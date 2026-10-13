volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[3];
    unsigned int post:4;
} __attribute__((packed));
static struct outer g = { 025, { 01111, 02222, 03333 }, 011 };
static u16 *q = g.a;
static u16 *r;
static void *v;

static int check_local_static(void)
{
    static u16 *s = g.a;
    return s[2] == 03333;
}

int main(void)
{
    if (q[0] != 01111 || q[1] != 02222 || q[2] != 03333) return 1;
    q[1] += 3;
    if (g.a[1] != 02225) return 2;

    r = g.a;
    if (r[2] != 03333) return 3;
    r[0] = 04444;
    if (g.a[0] != 04444) return 4;

    v = (void *)g.a;
    r = (u16 *)v;
    if (r[1] != 02225) return 5;

    if (!check_local_static()) return 6;
    if (g.pre != 025 || g.post != 011) return 7;
    return 0;
}
