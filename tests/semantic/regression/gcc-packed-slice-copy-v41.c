volatile int __test_exit;
/* Small packed aggregate at a non-word-aligned position. */
struct sub { unsigned a:7; unsigned b:9; } __attribute__((packed));
struct box { unsigned pre:5; struct sub s; unsigned post:6; } __attribute__((packed));
static struct box x, y;
int main(void)
{
    struct sub z;
    x.pre = 3; x.post = 17;
    y.pre = 6; y.post = 21;
    z.a = 111; z.b = 477;
    x.s = z;
    if (x.s.a != 111 || x.s.b != 477) return 1;
    if (x.pre != 3 || x.post != 17) return 2;
    y.s = x.s;
    if (y.s.a != 111 || y.s.b != 477) return 3;
    if (y.pre != 6 || y.post != 21) return 4;
    z = y.s;
    if (z.a != 111 || z.b != 477) return 5;
    return 0;
}
