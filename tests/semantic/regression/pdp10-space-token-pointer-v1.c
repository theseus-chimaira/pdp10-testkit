/*
 * Compiler-only token pointer oracle for the unchanged 980707-1.c.
 *
 * The original uses hosted isspace(), which compiler libp10c does not
 * provide; the installed GCC target also lacks ctype.h. This fixture
 * deliberately handles ONLY the ASCII space required by the original
 * input " a b". It is not an implementation or substitute for isspace.
 *
 * Preserve the two nested scan loops, (unsigned char) input read,
 * arglist pointer writes, in-place delimiter termination, and the
 * real compiler-library strcpy/strcmp calls. Test exact 9-bit byte
 * positions, empty input, consecutive delimiters, and both guards.
 */

#include <string.h>

extern void abort(void);

#define TOKEN_LIMIT_V1 256
#define LEFT_GUARD_V1 0123456701u
#define RIGHT_GUARD_V1 0765432101u

struct input_storage_v1 {
    unsigned int before;
    char input[TOKEN_LIMIT_V1];
    unsigned int after;
};

static struct input_storage_v1 storage_v1;
static char *arglist_v1[TOKEN_LIMIT_V1];
static volatile unsigned int visit_count_v1;
volatile int fail_id;

/*
 * Default mode deliberately permits the GCC direct-call strcpy
 * optimizer. The diagnostic mode forces the real compiler-library
 * call without changing the source input, tokenizer or assertions.
 * This is not a replacement string function: both modes call strcpy.
 */
#ifdef PDP10_TOKEN_REAL_STRCPY_V1
static char *(*volatile compiler_strcpy_v1)(char *, const char *) = strcpy;
#define COPY_V1(dst, src) compiler_strcpy_v1((dst), (src))
#else
#define COPY_V1(dst, src) strcpy((dst), (src))
#endif

#define CHECK_V1(condition, code) do { \
    if (!(condition)) { fail_id = (code); abort(); } \
} while (0)

static int
is_original_space_v1(unsigned char c)
{
    /* Original test input contains only ' ' as a separator. */
    return c == (unsigned char)' ';
}

static char **
build_space_argv_v1(char *input)
{
    int numargs = 0;

    while (1) {
        while (is_original_space_v1((unsigned char)*input) && *input != 0)
            input++;
        if (*input == 0)
            break;
        CHECK_V1(numargs < TOKEN_LIMIT_V1 - 1, 1);
        arglist_v1[numargs++] = input;
        visit_count_v1++;
        while (!is_original_space_v1((unsigned char)*input) && *input != 0)
            input++;
        if (*input == 0)
            break;
        *(input++) = 0;
    }
    arglist_v1[numargs] = (char *)0;
    return arglist_v1;
}

static void
check_guards_v1(void)
{
    CHECK_V1(storage_v1.before == LEFT_GUARD_V1, 2);
    CHECK_V1(storage_v1.after == RIGHT_GUARD_V1, 3);
}

int
main(void)
{
    char **args;
    char *buf = storage_v1.input;

    CHECK_V1(sizeof(char) == 1, 4);
    CHECK_V1(sizeof(unsigned int) == 4, 5);
    storage_v1.before = LEFT_GUARD_V1;
    storage_v1.after = RIGHT_GUARD_V1;

    /* Exact original " a b" and strcmp assertions. */
    CHECK_V1(COPY_V1(buf, " a b") == buf, 6);
    args = build_space_argv_v1(buf);
    CHECK_V1(args == arglist_v1, 7);
    CHECK_V1(args[0] == buf + 1, 8);
    CHECK_V1(args[1] == buf + 3, 9);
    CHECK_V1(strcmp(args[0], "a") == 0, 10);
    CHECK_V1(strcmp(args[1], "b") == 0, 11);
    CHECK_V1(args[2] == (char *)0, 12);
    CHECK_V1(buf[0] == ' ' && buf[1] == 'a' && buf[2] == 0 &&
             buf[3] == 'b' && buf[4] == 0, 13);
    CHECK_V1(visit_count_v1 == 2, 14);
    check_guards_v1();

    /* Multiple consecutive delimiters and a trailing delimiter. */
    CHECK_V1(COPY_V1(buf, "  c   d  ") == buf, 15);
    args = build_space_argv_v1(buf);
    CHECK_V1(args[0] == buf + 2 && args[1] == buf + 6, 16);
    CHECK_V1(strcmp(args[0], "c") == 0 && strcmp(args[1], "d") == 0, 17);
    CHECK_V1(args[2] == (char *)0 && visit_count_v1 == 4, 18);
    CHECK_V1(buf[3] == 0 && buf[7] == 0 && buf[8] == ' ', 19);
    check_guards_v1();

    /* Empty and space-only strings must yield a null-terminated list. */
    CHECK_V1(COPY_V1(buf, "") == buf, 20);
    args = build_space_argv_v1(buf);
    CHECK_V1(args[0] == (char *)0 && visit_count_v1 == 4, 21);
    CHECK_V1(COPY_V1(buf, "    ") == buf, 22);
    args = build_space_argv_v1(buf);
    CHECK_V1(args[0] == (char *)0 && visit_count_v1 == 4, 23);
    check_guards_v1();

    /* A three-element list exercises one further indexed write. */
    CHECK_V1(COPY_V1(buf, "a b c") == buf, 24);
    args = build_space_argv_v1(buf);
    CHECK_V1(args[0] == buf && args[1] == buf + 2 && args[2] == buf + 4, 25);
    CHECK_V1(strcmp(args[0], "a") == 0 && strcmp(args[1], "b") == 0 &&
             strcmp(args[2], "c") == 0, 26);
    CHECK_V1(args[3] == (char *)0 && visit_count_v1 == 7, 27);
    check_guards_v1();

    return 0;
}
