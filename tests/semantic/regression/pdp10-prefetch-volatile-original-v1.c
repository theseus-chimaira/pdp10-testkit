/* Exercise the exact historical volatile prefetch expression source.
 * The original byte-identical builtin-prefetch-3.c is included and
 * its main return is adapted so testkit can verify state afterward.
 */
#define main original_main_v1
#define exit(n) return (n)
#include "../upstream/extensions/builtin-prefetch-3.c"
#undef exit
#undef main

volatile unsigned int fail_id;
extern void abort(void);

int
main(void)
{
    int i;
    for (i = 0; i < 100; i++) {
        glob_int_arr[i] = i + 1;
        glob_vol_int_arr[i] = i + 17;
    }
    if (original_main_v1() != 0) {
        fail_id = 1;
        abort();
    }
    if (str.next != &str || vol_str.next != &str ||
        glob_vol_ptr_int != glob_int_arr ||
        glob_ptr_vol_int != glob_vol_int_arr ||
        glob_vol_ptr_vol_int != glob_vol_int_arr) {
        fail_id = 2;
        abort();
    }
    for (i = 0; i < 100; i++) {
        if (glob_int_arr[i] != i + 1 ||
            glob_vol_int_arr[i] != i + 17) {
            fail_id = 3;
            abort();
        }
    }
    return 0;
}
