/*
 * Independent native PDP-10 test for optimized strcpy of " a b".
 * The source is independent from the 980707 token-splitting fixture.
 * Use volatile reads so the test checks actual guest memory, rather
 * than accepting the compiler's value propagation as evidence.
 * No local strcpy replacement or hosted stdio is provided.
 */

#include <string.h>

extern void abort(void);

#define P10_LITERAL_LEFT_V1 01234567u
#define P10_LITERAL_RIGHT_V1 07654321u

struct literal_storage_v1 {
    unsigned int before;
    char content[32];
    unsigned int after;
};

static struct literal_storage_v1 target_v1;
volatile int fail_id;

#define CHECK_V1(expr, code) do { \
    if (!(expr)) { fail_id = (code); abort(); } \
} while (0)

int
main(void)
{
    volatile char *readback;
    char *p;

    target_v1.before = P10_LITERAL_LEFT_V1;
    target_v1.after = P10_LITERAL_RIGHT_V1;

    p = strcpy(target_v1.content, " a b");
    readback = target_v1.content;

    CHECK_V1(p == target_v1.content, 1);
    CHECK_V1(readback[0] == ' ', 2);
    CHECK_V1(readback[1] == 'a', 3);
    CHECK_V1(readback[2] == ' ', 4);
    CHECK_V1(readback[3] == 'b', 5);
    CHECK_V1(readback[4] == 0, 6);
    CHECK_V1(target_v1.before == P10_LITERAL_LEFT_V1, 7);
    CHECK_V1(target_v1.after == P10_LITERAL_RIGHT_V1, 8);

    return 0;
}
