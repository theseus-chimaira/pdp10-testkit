/* A four-byte packed record can be embedded at any byte position.
   Access it through a real pointer, not just a constant field path. */
#include "pdp10-types.h"
#include "test-compiler-compat.h"

typedef pdp10_uint16_t u16;
struct inner {
    unsigned char a;
    u16 b;
    unsigned char c;
} PDP10_PACKED;
struct outer {
    unsigned char tag;
    struct inner v;
    unsigned char tail[2];
} PDP10_PACKED;

static struct outer x[4];
static struct inner * volatile selected;

static PDP10_NOINLINE int change(struct inner *p, unsigned int n)
{
    p->a = n;
    p->b = (u16)(0100000U + n);
    p->c = n + 1;
    if (p->a != n || p->b != 0100000U + n || p->c != n + 1)
        return 1;
    p->b += 7;
    if (p->b != 0100007U + n)
        return 2;
    return 0;
}

int main(void)
{
    int i;
    for (i = 0; i < 4; ++i) {
        x[i].tag = 0123;
        x[i].tail[0] = 0456;
        x[i].tail[1] = 0670;
    }
    /* Seven-byte outer stride visits all four starting byte positions. */
    selected = &x[0].v;
    if (change(selected, 1)) return 1;
    selected = &x[1].v;
    if (change(selected, 2)) return 2;
    selected = &x[2].v;
    if (change(selected, 3)) return 3;
    selected = &x[3].v;
    if (change(selected, 4)) return 4;
    if (x[0].v.b != 0100010U || x[1].v.b != 0100011U
        || x[2].v.b != 0100012U || x[3].v.b != 0100013U)
        return 5;
    for (i = 0; i < 4; ++i)
        if (x[i].tag != 0123 || x[i].tail[0] != 0456
            || x[i].tail[1] != 0670)
            return 6;
    return 0;
}
