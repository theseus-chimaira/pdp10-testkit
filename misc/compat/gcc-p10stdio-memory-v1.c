/*
 * GCC PDP-10 real buffer-formatting libc test (C89).
 *
 * This test intentionally links the GCC implementation, not the
 * KCC-formatting object found in the installed hosted libc archive.
 * All tests run with the true GCC target stdarg ABI and 9-bit char.
 */
#include <stdio.h>
#include <stdarg.h>
#include <limits.h>

extern void abort(void);

volatile unsigned int fail_id;

static void
check_v1(int correct, unsigned int id)
{
    if (!correct) {
        fail_id = id;
        abort();
    }
}

static int
same_v1(const char *a, const char *b)
{
    while (*a != 0 && *a == *b) {
        ++a;
        ++b;
    }
    return *a == *b;
}

static int
forward_sprintf_v1(char *output, const char *format, ...)
{
    va_list arguments;
    int count;
    va_start(arguments, format);
    count = vsprintf(output, format, arguments);
    va_end(arguments);
    return count;
}

static int
forward_snprintf_v1(char *output, size_t size, const char *format, ...)
{
    va_list arguments;
    int count;
    va_start(arguments, format);
    count = vsnprintf(output, size, format, arguments);
    va_end(arguments);
    return count;
}

int
main(void)
{
    char buffer[80];
    char bounded[8];
    int count;

    fail_id = 0;
    count = sprintf(buffer, "%d %d", 5, 20);
    check_v1(count == 4 && same_v1(buffer, "5 20"), 1);

    count = sprintf(buffer, "%d %+d %u", -123, 42, 123U);
    check_v1(count == 12 && same_v1(buffer, "-123 +42 123"), 2);

    count = sprintf(buffer, "%09.4d", 42);
    check_v1(count == 9 && same_v1(buffer, "     0042"), 3);

    count = sprintf(buffer, "%#x %#o %X", 26U, 10U, 31U);
    check_v1(count == 11 && same_v1(buffer, "0x1a 012 1F"), 4);

    count = sprintf(buffer, "%-6s|%.3s", "hi", "abcdef");
    check_v1(count == 10 && same_v1(buffer, "hi    |abc"), 5);

    count = sprintf(buffer, "%*.*d", 6, 4, 7);
    check_v1(count == 6 && same_v1(buffer, "  0007"), 6);

    count = sprintf(buffer, "%-5c%%", 'A');
    check_v1(count == 6 && same_v1(buffer, "A    %"), 7);

    count = sprintf(buffer, "%ld %lu %hd", 123456L, 1234UL, -23);
    check_v1(count == 15 && same_v1(buffer, "123456 1234 -23"), 8);

    count = forward_sprintf_v1(buffer, "%d:%s", 99, "ok");
    check_v1(count == 5 && same_v1(buffer, "99:ok"), 9);

    bounded[7] = 'Q';
    count = snprintf(bounded, 6, "%s", "1234567");
    check_v1(count == 7 && same_v1(bounded, "12345"), 10);
    check_v1(bounded[7] == 'Q', 11);

    count = forward_snprintf_v1(bounded, 8, "%s", "abcdefghij");
    check_v1(count == 10 && same_v1(bounded, "abcdefg"), 12);

    count = snprintf((char *)0, (size_t)0, "%d", 123);
    check_v1(count == 3, 13);

    bounded[1] = 'Q';
    count = snprintf(bounded, 1, "%s", "abc");
    check_v1(count == 3 && bounded[0] == 0 && bounded[1] == 'Q', 18);

    count = sprintf(buffer, "%.0d", 0);
    check_v1(count == 0 && buffer[0] == 0, 14);

    count = sprintf(buffer, "%+07d", -42);
    check_v1(count == 7 && same_v1(buffer, "-000042"), 19);

    count = sprintf(buffer, "%#o", 0U);
    check_v1(count == 1 && same_v1(buffer, "0"), 20);

    count = sprintf(buffer, "%f", 1.5);
    check_v1(count == -1, 15);

#if CHAR_BIT == 9
    count = sprintf(buffer, "%c", 0400);
    check_v1(count == 1 && (unsigned char)buffer[0] == 0400 &&
             buffer[1] == 0, 16);
#endif

    check_v1(fail_id == 0, 17);
    return 0;
}
