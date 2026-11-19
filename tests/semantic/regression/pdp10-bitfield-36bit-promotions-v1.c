/* Target-width integer promotions for original bf-sign-2.c.
 * 36-bit signed int can represent every value of unsigned fields
 * up to 35 bits. A full unsigned 36-bit field cannot promote to
 * signed int. These are standard 36-bit-int expectations, not the
 * historical source's hardcoded 32-bit assumptions.
 * The nonstandard unsigned long-long bitfield extension requires a
 * separate explicitly justified compiler-policy decision.
 */

struct widths_v1 {
    unsigned int u3 : 3;
    signed int s31 : 31;
    signed int s32 : 32;
    unsigned int u15 : 15;
    unsigned int u31 : 31;
    unsigned int u32 : 32;
    unsigned int u36 : 36;
};

static volatile struct widths_v1 widths_v1;
volatile unsigned int fail_id;
extern void abort(void);

int
main(void)
{
    widths_v1.u3 = 0U;
    widths_v1.s31 = 0;
    widths_v1.s32 = 0;
    widths_v1.u15 = 0U;
    widths_v1.u31 = 0U;
    widths_v1.u32 = 0U;
    widths_v1.u36 = 0U;

    if (widths_v1.u3 - 2 >= 0) {
        fail_id = 1;
        abort();
    }
    if (widths_v1.s31 - 2 >= 0) {
        fail_id = 2;
        abort();
    }
    if (widths_v1.s32 - 2 >= 0) {
        fail_id = 3;
        abort();
    }
    if (widths_v1.u15 - 2 >= 0) {
        fail_id = 4;
        abort();
    }
    if (widths_v1.u31 - 2 >= 0) {
        fail_id = 5;
        abort();
    }
    if (widths_v1.u32 - 2 >= 0) {
        fail_id = 6;
        abort();
    }
    if (widths_v1.u36 - 2U <= 0U) {
        fail_id = 7;
        abort();
    }
    return 0;
}
