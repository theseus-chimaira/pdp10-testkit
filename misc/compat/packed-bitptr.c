#include "pdp10-types.h"
#include "test-compiler-compat.h"

volatile int __test_exit;

struct packed_bits_v22 {
    unsigned int pre:5;
    pdp10_uint16_t a[3];
    unsigned int post:4;
} PDP10_PACKED;

static struct packed_bits_v22 obj;

static pdp10_uint16_t read_first(pdp10_uint16_t *p)
{
    return *p;
}

static void write_first(pdp10_uint16_t *p, pdp10_uint16_t v)
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
