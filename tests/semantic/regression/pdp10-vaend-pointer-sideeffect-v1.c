/*
 * Freestanding native compiler oracle for upstream va-arg-21.c.
 *
 * The historical source uses hosted malloc and vprintf. Here two
 * actual va_list objects have automatic storage, but the source's
 * va_list *ap_array[3], pointer expression va_end(**ap_ptr++), and
 * second explicit ap_ptr++ are preserved. This tests the true
 * expansion and side effect of the compiler's installed stdarg.h;
 * it does not replace va_end or any hosted function.
 *
 * Two variadic int arguments are read through both real va_lists.
 * The NULL middle slot must never be read. The value and guard tests
 * distinguish an omitted va_end argument side effect from accidental
 * extra evaluation and detect corruption of the vararg storage.
 */

#include <stdarg.h>

extern void abort(void);

#define P10_VA_LEFT_V1 012345671u
#define P10_VA_RIGHT_V1 076543210u

volatile int fail_id;
static volatile unsigned int call_count_v1;

#define CHECK_V1(expr, code) do { \
    if (!(expr)) { fail_id = (code); abort(); } \
} while (0)

static void
check_va_end_v1(int marker, ...)
{
    va_list first_v1;
    va_list third_v1;
    va_list *ap_array[3];
    va_list **ap_ptr = ap_array;
    unsigned int before_v1 = P10_VA_LEFT_V1;
    unsigned int after_v1 = P10_VA_RIGHT_V1;
    int a;
    int b;

    CHECK_V1(marker == 037, 1);
    ap_array[0] = &first_v1;
    ap_array[1] = (va_list *)0;
    ap_array[2] = &third_v1;

    va_start(*ap_array[0], marker);
    a = va_arg(**ap_ptr, int);
    CHECK_V1(a == 012345, 2);
    b = va_arg(**ap_ptr, int);
    CHECK_V1(b == 07654, 3);

    /* The actual original macro argument expression under test. */
    va_end(**ap_ptr++);
    CHECK_V1(ap_ptr == &ap_array[1], 4);

    /* Original second pointer increment skips the NULL sentinel. */
    ap_ptr++;
    CHECK_V1(ap_ptr == &ap_array[2], 5);
    CHECK_V1(*ap_ptr != (va_list *)0, 6);

    va_start(*ap_array[2], marker);
    a = va_arg(**ap_ptr, int);
    CHECK_V1(a == 012345, 7);
    b = va_arg(**ap_ptr, int);
    CHECK_V1(b == 07654, 8);
    va_end(**ap_ptr);

    CHECK_V1(ap_ptr == &ap_array[2], 9);
    CHECK_V1(ap_array[0] == &first_v1, 10);
    CHECK_V1(ap_array[1] == (va_list *)0, 11);
    CHECK_V1(ap_array[2] == &third_v1, 12);
    CHECK_V1(before_v1 == P10_VA_LEFT_V1, 13);
    CHECK_V1(after_v1 == P10_VA_RIGHT_V1, 14);
    call_count_v1++;
}

int
main(void)
{
    check_va_end_v1(037, 012345, 07654);
    CHECK_V1(call_count_v1 == 1, 15);
    return 0;
}
