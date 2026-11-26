/* Static exact-width pointer initializers must retain the packed member's
   physical bit coordinate and the C element stride.  Ordinary exact32
   objects still use full native word slots. */
#include "pdp10-types.h"
typedef pdp10_uint32_t u32;
struct record {
    unsigned char left;
    u32 a[3];
    unsigned char right;
} __attribute__((packed));
static struct record x = {0123, {7, 11, 19}, 0456};
static u32 native[3] = {23, 29, 31};
static u32 *volatile middle = &x.a[1];
static u32 *volatile last = x.a + 2;
static u32 *volatile plain = native + 1;

int main(void)
{
    if (*middle != 11 || *last != 19 || *plain != 29)
        return 1;
    if (middle[1] != 19 || middle[-1] != 7 || plain[1] != 31)
        return 2;
    if (last - middle != 1 || middle - last != -1)
        return 3;
    *middle = 37;
    *plain = 41;
    if (x.a[0] != 7 || x.a[1] != 37 || x.a[2] != 19 ||
        x.left != 0123 || x.right != 0456 || native[0] != 23 ||
        native[1] != 41 || native[2] != 31)
        return 4;
    return 0;
}
