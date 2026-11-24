/* Exact-width pointers can denote native word slots or packed bit streams.
   Exercise both through the same separately compiled-looking helpers. */
#include "pdp10-types.h"
#include "test-compiler-compat.h"

typedef pdp10_uint32_t u32;
typedef pdp10_int32_t s32;
struct rec {
    unsigned char left;
    u32 a[3];
    s32 b[2];
    unsigned char right;
} PDP10_PACKED;
static struct rec x = { 0123, { 1, 2, 3 }, { -1, -2 }, 0456 };
static u32 normal[3] = { 7, 8, 9 };
static s32 signed_normal[2] = { -4, -5 };
static u32 * volatile selected;
static u32 * static_packed = &x.a[1];

static PDP10_NOINLINE int check(u32 *p, unsigned int start)
{
    u32 *q = p;
    if (q[0] != start || q[1] != start + 1 || q[2] != start + 2)
        return 1;
    q += 2;
    if (q - p != 2 || p - q != -2)
        return 2;
    if (*q-- != start + 2 || q != p + 1)
        return 3;
    if ((*q)++ != start + 1 || *q != start + 2)
        return 4;
    if (*++q != start + 2)
        return 5;
    *q = (u32)037777777777U;
    if (++*q != 0 || *q != 0)
        return 6;
    return 0;
}

static PDP10_NOINLINE int signed_check(s32 *p, int expected)
{
    if ((int)*p != expected)
        return 1;
    p[1] = (s32)020000000000U;
    if ((int)p[1] != -020000000000)
        return 2;
    return 0;
}

int main(void)
{
    int r;
    if (*static_packed != 2)
        return 1;
    selected = x.a;
    if ((r = check(selected, 1)) != 0)
        return 20 + r;
    selected = normal;
    if ((r = check(selected, 7)) != 0)
        return 30 + r;
    if ((r = signed_check(x.b, -1)) != 0)
        return 40 + r;
    if ((r = signed_check(signed_normal, -4)) != 0)
        return 50 + r;
    if (x.a[0] != 1 || x.a[1] != 3 || x.a[2] != 0)
        return 5;
    if (normal[0] != 7 || normal[1] != 9 || normal[2] != 0)
        return 6;
    if (x.left != 0123 || x.right != 0456 || x.b[0] != -1)
        return 7;
    return 0;
}
