/* Indexed bitfield stores in word-stride records must address the
 * containing word, not step an unencoded byte pointer.  Retain the
 * original v59y probe, which also exercises copying and filling.
 */
#include <string.h>
typedef struct {
    unsigned int high : 8;
    unsigned int low : 28;
    unsigned int words[7];
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
        source[i].high = base + i;
        source[i].low = base * 16 + i;
        for (j = 0; j < 7; ++j)
            source[i].words[j] = base + 100*i + j;
    }
    for (i = 0; i < 3; ++i) {
        dst = source[i];
        if (dst.high != base + i || dst.low != base * 16 + i)
            return 1;
        for (j = 0; j < 7; ++j)
            if (dst.words[j] != base + 100*i + j)
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
        dst.high = base + i;
        dst.low = base * 16 + i;
        for (j = 0; j < 7; ++j)
            dst.words[j] = base + j;
        if (dst.words[6] != base + 6) return 3;
        memset(&dst, 0, sizeof(dst));
        if (dst.high || dst.low) return 4;
        for (j = 0; j < 7; ++j)
            if (dst.words[j]) return 5;
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
