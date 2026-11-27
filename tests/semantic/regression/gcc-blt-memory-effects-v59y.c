/* BLT copies and fills must invalidate ordinary, nonvolatile field reads.
 * Volatile inputs prevent compile-time evaluation, not memory optimization
 * of the actual destination. No computed goto, heap or runtime helper
 * is needed to exercise the block-copy dependency.
 */
#include <string.h>
typedef union {
    struct {
        unsigned int high : 8;
        unsigned int low : 28;
        unsigned int words[7];
    } field;
    unsigned int raw[8];
} record_t;
static record_t source[3];
static volatile unsigned int seed = 37;
volatile unsigned int fail_id;

static int
copy_loop(unsigned int base)
{
    record_t dst;
    unsigned int i, j;
    for (i = 0; i < 3; ++i) {
        /* Independent raw-word source, rather than a bitfield store
         * followed by a bitfield read using the same lowering. */
        source[i].raw[0] = ((base + i) << 28) | (base * 16 + i);
        for (j = 0; j < 7; ++j)
            source[i].raw[j+1] = base + 100*i + j;
    }
    for (i = 0; i < 3; ++i) {
        dst = source[i];
        if (dst.field.high != base + i || dst.field.low != base * 16 + i)
            return 1;
        for (j = 0; j < 7; ++j)
            if (dst.field.words[j] != base + 100*i + j)
                return 2;
    }
    return 0;
}

static int
fill_loop(unsigned int base)
{
    record_t dst;
    unsigned int i, j;
    for (i = 0; i < 3; ++i) {
        dst.raw[0] = ((base + i) << 28) | (base * 16 + i);
        for (j = 0; j < 7; ++j)
            dst.raw[j+1] = base + j;
        if (dst.field.words[6] != base + 6) return 3;
        memset(&dst, 0, sizeof(dst));
        if (dst.field.high || dst.field.low) return 4;
        for (j = 0; j < 7; ++j)
            if (dst.field.words[j]) return 5;
    }
    return 0;
}

int
main(void)
{
    unsigned int n = seed;
    fail_id = copy_loop(n);
    if (fail_id) return 1;
    fail_id = fill_loop(n);
    if (fail_id) return 1;
    return 0;
}
