/*
 * Freestanding PDP-10 companion to original 920501-8.c.
 *
 * Preserve the original first int/double/int arguments, all thirteen
 * variable arguments, the sixteen-field sprintf format and the exact
 * formatted string.  The original calls hosted printf first, which is
 * not required for its only runtime assertion; this companion instead
 * checks the same varargs and buffer-write behavior without console I/O.
 *
 * Diagnostic nonzero exit codes identify the first failing contract:
 *   20..32: incorrect va_arg integer slot;
 *   41..43: invalid sprintf return value;
 *   50..93: wrong formatted byte offset;
 *   100..101: missing NUL or wrong byte count;
 *   110: incorrect return-value accumulation.
 * A nonzero result is a real compiler/runtime failure, not a skipped test.
 * No result here proves that the original hosted printf path works.
 */

#include <stdio.h>
#include <stdarg.h>

extern void abort(void);
extern void exit(int);

static char buffer_v1[80];
static const char expected_v1[] =
    "1,1.000000,2,3,4,5,6,7,8,9,10,11,12,13,14,15";

static int
many_args_v1(int first, double floating, int third, ...)
{
    va_list args;
    int values[13];
    int i;
    int length;

    va_start(args, third);
    for (i = 0; i < 13; ++i)
        values[i] = va_arg(args, int);
    va_end(args);

    /* Reject bad va_arg advancement even if formatting happens to match. */
    for (i = 0; i < 13; ++i)
        if (values[i] != i + 3)
            exit(20 + i);

    length = sprintf(buffer_v1,
                     "%d,%f,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",
                     first, floating, third,
                     values[0], values[1], values[2], values[3],
                     values[4], values[5], values[6], values[7],
                     values[8], values[9], values[10], values[11],
                     values[12]);
    if (length < 0)
        exit(41);
    if (length == 0)
        exit(42);
    if (length >= (int)sizeof(buffer_v1))
        exit(43);

    for (i = 0; expected_v1[i] != '\0'; ++i)
        if (buffer_v1[i] != expected_v1[i])
            exit(50 + i);
    if (buffer_v1[i] != '\0')
        exit(100);
    if (length != i)
        exit(101);

    return first + third + values[0] + values[1] + values[2] +
           values[3] + values[4] + values[5] + values[6] +
           values[7] + values[8] + values[9] + values[10] +
           values[11] + values[12];
}

int
main(void)
{
    if (many_args_v1(1, 1.0, 2, 3, 4, 5, 6, 7, 8, 9,
                     10, 11, 12, 13, 14, 15) != 120)
        exit(110);
    return 0;
}
