/* Native PDP-10 high36:low35 two-word union overlay for 960416-1.c.
 * A 71-bit unsigned long long shares the physical 72-bit two-word
 * storage with two unsigned 36-bit longs; low word's high bit is a
 * continuation/sign copy and its other 35 bits are magnitude bits.
 * Test both historical BE and LE struct member orders without the
 * original 32/32 IEEE/host assumptions or vacuous conditional exits.
 */
extern void abort(void);
volatile unsigned int fail_id;
typedef unsigned long word_v1;
typedef unsigned long long wide_v1;

union big_v1 {
    wide_v1 d;
    struct { word_v1 h,l; } s;
};
union little_v1 {
    wide_v1 d;
    struct { word_v1 l,h; } s;
};
static volatile union big_v1 big_v1;
static volatile union little_v1 little_v1;

int
main(void)
{
    big_v1.d = 1ULL;
    if (big_v1.s.h != 0UL || big_v1.s.l != 1UL) {
        fail_id = 1;
        abort();
    }
    big_v1.d = 1ULL << 35;
    if (big_v1.s.h != 1UL || big_v1.s.l != 0UL) {
        fail_id = 2;
        abort();
    }
    big_v1.s.h = 0x10000000UL;
    big_v1.s.l = 0xe0000000UL;
    if (big_v1.d != ((wide_v1)0x10000000UL << 35) +
                    (wide_v1)0xe0000000UL) {
        fail_id = 3;
        abort();
    }
    little_v1.d = 1ULL;
    if (little_v1.s.l != 0UL || little_v1.s.h != 1UL) {
        fail_id = 4;
        abort();
    }
    little_v1.s.l = 0x10000000UL;
    little_v1.s.h = 0xe0000000UL;
    if (little_v1.d != ((wide_v1)0x10000000UL << 35) +
                       (wide_v1)0xe0000000UL) {
        fail_id = 5;
        abort();
    }
    return 0;
}
