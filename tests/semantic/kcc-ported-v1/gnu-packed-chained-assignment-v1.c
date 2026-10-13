/* Preserved regression source from gnu-packed-chained-assignment.sh. */
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct p {
    unsigned char a, b, c;
    u16 d;
    unsigned char e;
} __attribute__((packed));
static struct p x[3];
int main(void)
{
    x[0].a = 1;
    x[0].b = 2;
    x[0].c = 3;
    x[0].d = 04567;
    x[0].e = 5;
    x[1].a = 7;
    x[2].a = 6;
    x[2] = x[1] = x[0];
    if (x[1].a != 1 || x[1].b != 2 || x[1].c != 3
      || x[1].d != 04567 || x[1].e != 5) return 1;
    if (x[2].a != 1 || x[2].b != 2 || x[2].c != 3
      || x[2].d != 04567 || x[2].e != 5) return 2;
    return 0;
}
