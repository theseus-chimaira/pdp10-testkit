#include "daimos-language-v1.h"

volatile int __test_exit;

struct packed_bits_v22 {
    unsigned int pre:5;
    daimos_uint16_t a[3];
    unsigned int post:4;
} DAIMOS_PACKED;

static struct packed_bits_v22 obj;

static daimos_uint16_t read_first(daimos_uint16_t *p)
{
    return *p;
}

static void write_first(daimos_uint16_t *p, daimos_uint16_t v)
{
    *p = v;
}

int main(void)
{
    obj.pre = 021;
    obj.post = 013;
    obj.a[0] = 012345;

    if (read_first(obj.a) != 012345) return 1;
    if (obj.pre != 021) return 2;
    if (obj.post != 013) return 3;

    write_first(obj.a, 054321);
    if (obj.a[0] != 054321) return 4;
    if (obj.pre != 021) return 5;
    if (obj.post != 013) return 6;
    return 0;
}
