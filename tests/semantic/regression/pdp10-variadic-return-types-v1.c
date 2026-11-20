/*
 * Freestanding PDP-10 varargs and mixed return-type ABI regression.
 *
 * The original 920726-1.c checks its formatted strings but discards
 * an uninitialized integer and an uninitialized returned structure.
 * This C89 oracle instead returns initialized values, checks them,
 * and verifies all output bytes without a hosted stdio library.
 */

#include <stdarg.h>

extern void abort(void);

struct answer_v1 {
    int sum;
    int arguments;
};

volatile unsigned int fail_id;

static void
check_v1(int ok, unsigned int id)
{
    if (!ok) {
        fail_id = id;
        abort();
    }
}

static void
append_number_v1(char **out, int value)
{
    check_v1(value >= 0 && value < 100, 1);
    if (value >= 10)
        *(*out)++ = (char)('0' + value / 10);
    *(*out)++ = (char)('0' + value % 10);
}

static int
first_v1(char *buffer, char *format, ...)
{
    va_list args;
    char *p = buffer;
    int i;
    int value;
    int sum = 0;

    va_start(args, format);
    for (i = 0; format[i] != 0; ++i) {
        if (format[i] == 'i') {
            value = va_arg(args, int);
            sum += value;
            append_number_v1(&p, value);
        } else {
            *p++ = format[i];
        }
    }
    va_end(args);
    *p = 0;
    return sum;
}

static struct answer_v1
second_v1(char *buffer, char *format, ...)
{
    va_list args;
    struct answer_v1 result;
    char *p = buffer;
    int i;
    int value;

    result.sum = 0;
    result.arguments = 0;
    va_start(args, format);
    for (i = 0; format[i] != 0; ++i) {
        if (format[i] == 'i') {
            value = va_arg(args, int);
            result.sum += value;
            ++result.arguments;
            append_number_v1(&p, value);
        } else {
            *p++ = format[i];
        }
    }
    va_end(args);
    *p = 0;
    return result;
}

static void
check_buffer_v1(const char *buf, unsigned int id)
{
    check_v1(buf[0] == '5' && buf[1] == ' ' &&
             buf[2] == '2' && buf[3] == '0' &&
             buf[4] == ' ' && buf[5] == 0, id);
}

int
main(void)
{
    char first_buffer[16];
    char second_buffer[16];
    char format[] = "i i ";
    struct answer_v1 result;
    int sum;

    fail_id = 0;
    first_buffer[15] = 'Q';
    second_buffer[15] = 'R';

    sum = first_v1(first_buffer, format, 5, 20);
    check_v1(sum == 25, 10);
    check_buffer_v1(first_buffer, 11);
    check_v1(first_buffer[15] == 'Q', 13);

    result = second_v1(second_buffer, format, 5, 20);
    check_v1(result.sum == 25, 20);
    check_v1(result.arguments == 2, 21);
    check_buffer_v1(second_buffer, 22);
    check_v1(second_buffer[15] == 'R', 24);

    check_v1(fail_id == 0, 30);
    return 0;
}
