/*
 * Compiler-only PDP-10 string-constant builtin regression.
 *
 * Narrow STRING_CST values carry 9-bit target characters, including
 * octal 0400..0777, in two bytes per character in the host compiler.
 * Builtin folds must use target-character lengths and values, rather
 * than calling host strlen/strcmp on those implementation bytes.
 *
 * All string operations use the real compiler-owned target C library
 * when the compiler chooses not to inline them.  Read copied storage
 * through volatile to expose incomplete or corrupted inline copies.
 */

#include <string.h>

extern void abort(void);

volatile int fail_id;
static char buffer_v1[32];

#define CHECK_V1(expr, code) do { \
    if (!(expr)) { fail_id = (code); abort(); } \
} while (0)

int
main(void)
{
    volatile unsigned char *readback = (volatile unsigned char *)buffer_v1;
    char *copy;

    CHECK_V1(strlen(" a b") == 4, 1);
    CHECK_V1(strlen("") == 0, 2);
    CHECK_V1(strlen("ab\0cd") == 2, 3);
    CHECK_V1(strlen("ab\0cd" + 3) == 2, 4);
    CHECK_V1(strlen("abcdef" + 2) == 4, 5);
    CHECK_V1(strlen("\400x") == 2, 6);
    CHECK_V1(strlen("\377\400\777") == 3, 7);

    CHECK_V1(strcmp("a", "b") < 0, 8);
    CHECK_V1(strcmp("a", "a") == 0, 9);
    CHECK_V1(strcmp("\400", "\377") > 0, 10);
    CHECK_V1(strcmp("\777", "\400") > 0, 11);
    CHECK_V1(strncmp("abcd", "abce", 3) == 0, 12);
    CHECK_V1(strncmp("abcd", "abce", 4) < 0, 13);
    CHECK_V1(strncmp("\400", "\377", 1) > 0, 14);
    CHECK_V1(memcmp("\400\377", "\400\376", 2) > 0, 15);

    copy = strcpy(buffer_v1, " a b");
    CHECK_V1(copy == buffer_v1, 16);
    CHECK_V1(readback[0] == ' ', 17);
    CHECK_V1(readback[1] == 'a', 18);
    CHECK_V1(readback[2] == ' ', 19);
    CHECK_V1(readback[3] == 'b', 20);
    CHECK_V1(readback[4] == 0, 21);

    copy = strcpy(buffer_v1, "\400x\777");
    CHECK_V1(copy == buffer_v1, 22);
    CHECK_V1(readback[0] == 0400, 23);
    CHECK_V1(readback[1] == 'x', 24);
    CHECK_V1(readback[2] == 0777, 25);
    CHECK_V1(readback[3] == 0, 26);

    return 0;
}
