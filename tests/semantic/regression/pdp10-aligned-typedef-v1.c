/* PDP-10: check that aligned(16) changes member placement in C bytes.
 * The original align-1.c checks only unrelated struct/int size.
 * Alignment is 16 addressable chars, independent of 9-bit char width.
 */
#include <stddef.h>

typedef int aligned_int_v1 __attribute__((aligned(16)));

struct aligned_holder_v1 {
    char prefix;
    aligned_int_v1 value;
};

extern void abort(void);

static struct aligned_holder_v1 holder_v1;
volatile unsigned int fail_id;

int
main(void)
{
    unsigned long offset_v1;

    offset_v1 = (unsigned long)offsetof(struct aligned_holder_v1, value);
    if (offset_v1 < 16UL || offset_v1 % 16UL != 0UL) {
        fail_id = 1;
        abort();
    }
    if (sizeof(struct aligned_holder_v1) % 16 != 0) {
        fail_id = 2;
        abort();
    }
    holder_v1.value = 012345670;
    if (holder_v1.value != 012345670) {
        fail_id = 3;
        abort();
    }
    return 0;
}
