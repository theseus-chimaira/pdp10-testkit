/* Read the historical builtin-prefetch-2.c source without editing it.
 * The original local struct has an uninitialized `next` pointer,
 * which makes expressions t.next->d undefined. Call the exact
 * defined original routines, and replicate the local expressions
 * with t.next explicitly initialized to a live object.
 */
#define main original_main_v1
#define exit(n) return (n)
#include "../upstream/extensions/builtin-prefetch-2.c"
#undef exit
#undef main

volatile unsigned int fail_id;
extern void abort(void);

static void
safe_local_v1(void)
{
    int b[10];
    int *pb = b;
    struct S t;
    struct S *pt = &t;
    int j = 4;
    int i;
    for (i = 0; i < 10; i++)
        b[i] = i + 80;
    t.a = 3;
    t.b = 4;
    t.next = &t;
    __builtin_prefetch(&t, 0, 0);
    __builtin_prefetch(pt, 0, 0);
    __builtin_prefetch(&t.b, 0, 0);
    __builtin_prefetch(&pt->b, 0, 0);
    __builtin_prefetch(&t.d, 0, 0);
    __builtin_prefetch(&pt->d, 0, 0);
    __builtin_prefetch(t.next, 0, 0);
    __builtin_prefetch(pt->next, 0, 0);
    __builtin_prefetch(t.next->d, 0, 0);
    __builtin_prefetch(pt->next->d, 0, 0);
    __builtin_prefetch(&b, 0, 0);
    __builtin_prefetch(pb, 0, 0);
    __builtin_prefetch(&b[2], 0, 0);
    __builtin_prefetch(&pb[3], 0, 0);
    __builtin_prefetch(b+3, 0, 0);
    __builtin_prefetch(b+j, 0, 0);
    __builtin_prefetch(pb+5, 0, 0);
    __builtin_prefetch(pb+j, 0, 0);
    if (t.next != &t || t.a != 3 || t.b != 4) {
        fail_id = 1;
        abort();
    }
    for (i = 0; i < 10; i++) {
        if (b[i] != i + 80) {
            fail_id = 2;
            abort();
        }
    }
}

int
main(void)
{
    int i;
    for (i = 0; i < 100; i++)
        glob_int_arr[i] = i + 20;
    simple_global();
    simple_file();
    simple_static_local();
    simple_local();
    simple_arg(glob_int_arr, glob_ptr_int, glob_int);
    str.next = &str;
    expr_global();
    safe_local_v1();
    if (str.next != &str || glob_ptr_int != glob_int_arr ||
        glob_int != 4) {
        fail_id = 3;
        abort();
    }
    for (i = 0; i < 100; i++) {
        if (glob_int_arr[i] != i + 20) {
            fail_id = 4;
            abort();
        }
    }
    return 0;
}
