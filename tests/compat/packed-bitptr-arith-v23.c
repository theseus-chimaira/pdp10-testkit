#include "daimos-language-v1.h"

volatile int __test_exit;

struct packed_bits_v23 {
    unsigned int pre:5;
    daimos_uint16_t a[3];
    unsigned int post:4;
} DAIMOS_PACKED;

static struct packed_bits_v23 obj;

static daimos_uint16_t rd(daimos_uint16_t *p, int i)
{
    return p[i];
}

static void wr(daimos_uint16_t *p, int i, daimos_uint16_t v)
{
    p[i] = v;
}

int main(void)
{
    obj.pre = 021;
    obj.post = 013;

    wr(obj.a, 0, 0111);
    wr(obj.a, 1, 0222);
    wr(obj.a, 2, 0333);

    if (rd(obj.a, 0) != 0111) return 1;
    if (rd(obj.a, 1) != 0222) return 2;
    if (rd(obj.a, 2) != 0333) return 3;

    wr(obj.a, 1, 0444);
    if (rd(obj.a, 1) != 0444) return 4;
    if (obj.pre != 021) return 5;
    if (obj.post != 013) return 6;
    return 0;
}
