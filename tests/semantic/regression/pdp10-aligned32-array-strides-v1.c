/* Independent runtime alignment oracle for upstream 20010904-{1,2}.c.
 * Both original tests bypass their entire alignment assertion under
 * the PDP-10 preprocessor guard. This version checks the alignment
 * stride and actual consecutive array addresses for BOTH layouts.
 * Offset/sizeof are in target C addressable (nine-bit) characters.
 */

#include <stddef.h>

typedef struct align32_v1 {
    int a;
    int b;
} __attribute__((aligned(32))) aligned_v1;

typedef struct first_layout_v1 {
    aligned_v1 values[32];
    int last;
} first_v1;

typedef struct second_layout_v1 {
    aligned_v1 first;
    aligned_v1 rest[31];
    int last;
} second_v1;

static volatile int source_v1;
static first_v1 first_objects_v1[2];
static second_v1 second_objects_v1[2];
volatile unsigned int fail_id;
extern void abort(void);

int
main(void)
{
    size_t first_stride_v1;
    size_t second_stride_v1;
    int i;

    first_stride_v1 = sizeof(first_v1);
    second_stride_v1 = sizeof(second_v1);
    if (sizeof(aligned_v1) % 32U != 0U ||
        first_stride_v1 % 32U != 0U ||
        second_stride_v1 % 32U != 0U) {
        fail_id = 1;
        abort();
    }
    if (offsetof(first_v1, values) % 32U != 0U ||
        offsetof(second_v1, first) % 32U != 0U ||
        offsetof(second_v1, rest) % 32U != 0U) {
        fail_id = 2;
        abort();
    }
    if ((char *)&first_objects_v1[1] -
            (char *)&first_objects_v1[0] != first_stride_v1 ||
        (char *)&second_objects_v1[1] -
            (char *)&second_objects_v1[0] != second_stride_v1) {
        fail_id = 3;
        abort();
    }
    for (i = 0; i < 32; i++) {
        source_v1 = i + 100;
        first_objects_v1[1].values[i].b = source_v1;
        if (i == 0)
            second_objects_v1[1].first.b = source_v1;
        else
            second_objects_v1[1].rest[i - 1].b = source_v1;
        if (first_objects_v1[1].values[i].b != source_v1 ||
            (i == 0 ? second_objects_v1[1].first.b :
                      second_objects_v1[1].rest[i - 1].b) != source_v1) {
            fail_id = 4;
            abort();
        }
    }
    return 0;
}
