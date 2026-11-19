/* Reuse EVERY historical builtin-prefetch-1.c call site without edits.
 * This source adapts only the original main() exit for test harness
 * return and adds a separate observable data-integrity assertion.
 * The original byte-identical source is included by the preprocessor.
 */
#define main original_main_v1
#define exit(n) return (n)
#include "../upstream/extensions/builtin-prefetch-1.c"
#undef exit
#undef main

static volatile unsigned int invokes_v1;
volatile unsigned int fail_id;
extern void abort(void);

int
main(void)
{
    int i;
    for (i = 0; i < 10; i++)
        arr[i] = i * 17 + 3;
    invokes_v1++;
    if (original_main_v1() != 0) {
        fail_id = 1;
        abort();
    }
    if (invokes_v1 != 1U) {
        fail_id = 2;
        abort();
    }
    for (i = 0; i < 10; i++) {
        if (arr[i] != i * 17 + 3) {
            fail_id = 3U + (unsigned)i;
            abort();
        }
    }
    return 0;
}
