/*
 * Native PDP-10 C-locale character classification regression (C89).
 * Test the actual compiler-owned isprint and isspace implementations.
 * The complete 9-bit unsigned-char domain is checked, plus EOF.
 *
 * C locale printable: 040..0176.
 * C locale whitespace: 011..015 and 040.
 * Values 0200..0777 are not ASCII printable or whitespace in the
 * C locale; UTF-9 properties are outside the scope of these routines.
 */

#include <ctype.h>

extern void abort(void);

volatile int fail_id;
static int (*volatile call_print_v1)(int) = isprint;
static int (*volatile call_space_v1)(int) = isspace;
static volatile unsigned int checks_v1;

#define CHECK_V1(expr, n) do { \
    if (!(expr)) { fail_id = (n); abort(); } \
} while (0)

int
main(void)
{
    volatile int code_v1;
    int i;

    CHECK_V1(sizeof(char) == 1, 1);
    CHECK_V1(sizeof(unsigned int) == 4, 2);

    for (i = 0; i <= 0777; ++i) {
        int expected_print;
        int expected_space;
        int got_print;
        int got_space;

        code_v1 = i;
        expected_print = i >= 040 && i <= 0176;
        expected_space = i == 040 || (i >= 011 && i <= 015);
        got_print = call_print_v1(code_v1);
        got_space = call_space_v1(code_v1);

        CHECK_V1((got_print != 0) == expected_print, 3);
        CHECK_V1((got_space != 0) == expected_space, 4);
        ++checks_v1;
    }

    CHECK_V1(checks_v1 == 01000u, 5);
    CHECK_V1(call_print_v1(-1) == 0, 6);
    CHECK_V1(call_space_v1(-1) == 0, 7);

    /* The original 991112-1.c values are checked independently. */
    CHECK_V1(call_print_v1('a') != 0, 8);
    CHECK_V1(call_print_v1('\002') == 0, 9);
    CHECK_V1(call_space_v1(' ') != 0, 10);
    CHECK_V1(call_space_v1('\n') != 0, 11);

    return 0;
}
