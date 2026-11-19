/* GCC 921007-1.c: builtin strcmp of two nine-bit-char strings.
 * X compared to X + octal-376 suffix must be strictly negative.
 * Keep a separate non-builtin implementation to ensure that the
 * local C symbol is NOT what the GNU builtin calls or compares.
 */

volatile unsigned int fail_id;
extern void abort(void);

static int
ordinary_strcmp_v1(const char *x, const char *y)
{
    (void)x;
    (void)y;
    return 1;
}

int
main(void)
{
    static const char first_v1[] = "X";
    static const char second_v1[] = "X\376";

    if (__builtin_strcmp(first_v1, second_v1) >= 0) {
        fail_id = 1;
        abort();
    }
    if (ordinary_strcmp_v1(first_v1, second_v1) != 1) {
        fail_id = 2;
        abort();
    }
    if ((unsigned char)second_v1[1] != 254U) {
        fail_id = 3;
        abort();
    }
    return 0;
}
