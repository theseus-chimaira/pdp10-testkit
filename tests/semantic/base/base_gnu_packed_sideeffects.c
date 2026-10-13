volatile int __test_exit;
struct packed_sidefx_v18 {
    unsigned char a;
    unsigned long d __attribute__((packed));
    unsigned char e;
} __attribute__((packed));
static struct packed_sidefx_v18 x_v18[3];
static int calls_v18;
static int which_v18;
static int pick_v18(void) { ++calls_v18; return which_v18; }
int main(void)
{
    unsigned long old;
    x_v18[1].d = 012345670123UL;
    which_v18 = 1;
    calls_v18 = 0;
    if ((x_v18[pick_v18()].d += 7) != 012345670132UL) return 1;
    if (calls_v18 != 1 || x_v18[1].d != 012345670132UL) return 2;
    calls_v18 = 0;
    old = x_v18[pick_v18()].d++;
    if (old != 012345670132UL || calls_v18 != 1
        || x_v18[1].d != 012345670133UL) return 3;
    calls_v18 = 0;
    if (++x_v18[pick_v18()].d != 012345670134UL) return 4;
    if (calls_v18 != 1 || x_v18[1].d != 012345670134UL) return 5;
    calls_v18 = 0;
    if ((x_v18[pick_v18()].d ^= 077UL) != (012345670134UL ^ 077UL)) return 6;
    if (calls_v18 != 1 || x_v18[1].d != (012345670134UL ^ 077UL)) return 7;
    return 0;
}
