/*
 * Native compiler semantics of the unchanged historical 920810-1.c.
 *
 * The original needs hosted malloc, which the compiler freestanding
 * library does not provide. This companion owns one static child and
 * calls the real compiler-library memcpy and memset. It does not
 * replace malloc or claim the historical allocation succeeded.
 *
 * Verify the actual three-field structure copy before the original
 * inheritance fixups, then the super/name/size result, source
 * preservation, representation of the 9-bit memset byte, and guards.
 */

#include <string.h>

extern void abort(void);

typedef struct {
    void *super;
    int name;
    int size;
} t;

struct child_storage_v1 {
    int before;
    t child;
    int after;
};

#define P10_CHILD_LEFT_V1 012345671
#define P10_CHILD_RIGHT_V1 076543210
#define P10_CHILD_BYTE_V1 37
#define P10_CHILD_PATTERN_V1 (37 * 01001001001)

static struct child_storage_v1 storage_v1;
volatile int fail_id;
static volatile unsigned int copy_count_v1;

#define CHECK_V1(expr, code) do { \
    if (!(expr)) { fail_id = (code); abort(); } \
} while (0)

static t *
copy_child_v1(t *clas, int size)
{
    t *child = &storage_v1.child;

    /* This is real libc memcpy; only allocation is removed. */
    memcpy(child, clas, clas->size);
    copy_count_v1++;

    CHECK_V1(child->super == clas->super, 1);
    CHECK_V1(child->name == clas->name, 2);
    CHECK_V1(child->size == clas->size, 3);

    child->super = clas;
    child->name = 0;
    child->size = size;
    return child;
}

int
main(void)
{
    t foo;
    t *bar;

    CHECK_V1(sizeof(int) == 4, 4);
    CHECK_V1(sizeof(void *) == 4, 5);
    CHECK_V1(sizeof(t) == 12, 6);

    storage_v1.before = P10_CHILD_LEFT_V1;
    storage_v1.after = P10_CHILD_RIGHT_V1;

    /* Original full-byte fill, with a valid pointer before it is read. */
    memset(&foo, P10_CHILD_BYTE_V1, sizeof(t));
    CHECK_V1(foo.name == P10_CHILD_PATTERN_V1, 7);
    foo.super = 0;
    foo.size = sizeof(t);

    bar = copy_child_v1(&foo, sizeof(t));

    CHECK_V1(bar == &storage_v1.child, 8);
    CHECK_V1(copy_count_v1 == 1, 9);
    CHECK_V1(bar->super == &foo, 10);
    CHECK_V1(bar->name == 0, 11);
    CHECK_V1(bar->size == sizeof(t), 12);
    CHECK_V1(foo.super == 0, 13);
    CHECK_V1(foo.name == P10_CHILD_PATTERN_V1, 14);
    CHECK_V1(foo.size == sizeof(t), 15);
    CHECK_V1(storage_v1.before == P10_CHILD_LEFT_V1, 16);
    CHECK_V1(storage_v1.after == P10_CHILD_RIGHT_V1, 17);

    return 0;
}
