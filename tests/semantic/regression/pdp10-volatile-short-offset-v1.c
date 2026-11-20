/*
 * Compiler-only PDP-10 oracle for the unchanged GCC 941014-2.c.
 *
 * The original obtains its volatile structure with hosted malloc and
 * conditionally prints a diagnostic.  Neither service is implemented by
 * this fixture.  Static storage lets the compiler's volatile 18-bit
 * short fields, pointer-to-36-bit-integer conversions, three original
 * a1() address expressions, and return/readback contract be checked
 * without a fake allocator or console.  Original malloc/printf runtime
 * failures and their source remain separate obligations.
 */

extern void abort(void);

typedef struct {
    unsigned short a;
    unsigned short b;
} foo_t;

struct guarded_foo_v1 {
    unsigned int left;
    volatile foo_t payload;
    unsigned int right;
};

static struct guarded_foo_v1 storage_v1;
static volatile unsigned long a1_values_v1[3];
static volatile unsigned int a1_count_v1;
volatile int fail_id;

#define LEFT_V1  0123456701u
#define RIGHT_V1 0765432101u
#define INITIAL_A_V1 0x0a55u
#define INITIAL_B_V1 0x155aau
#define FINAL_B_V1 0x0100u

#define CHECK_V1(test, code) do { \
    if (!(test)) { fail_id = (code); abort(); } \
} while (0)

void
a1(unsigned long offset)
{
    CHECK_V1(a1_count_v1 < 3, 14);
    a1_values_v1[a1_count_v1++] = offset;
}

static volatile foo_t *
f(void)
{
    volatile foo_t *foo_p = &storage_v1.payload;

    a1((unsigned long)foo_p - 30);
    /* Preserve the original volatile test, without a hosted printf. */
    CHECK_V1(!(foo_p->a & 0xf000u), 15);
    foo_p->b = FINAL_B_V1;
    a1((unsigned long)foo_p + 2);
    a1((unsigned long)foo_p - 30);
    return foo_p;
}

int
main(void)
{
    volatile foo_t *foo_p;
    unsigned long address;

    /* Two 18-bit shorts occupy exactly one 36-bit native word. */
    CHECK_V1(sizeof(unsigned short) == 2, 1);
    CHECK_V1(sizeof(foo_t) == 4, 2);
    CHECK_V1(sizeof(unsigned long) == 4, 3);

    storage_v1.left = LEFT_V1;
    storage_v1.payload.a = INITIAL_A_V1;
    storage_v1.payload.b = INITIAL_B_V1;
    storage_v1.right = RIGHT_V1;

    foo_p = f();
    address = (unsigned long)&storage_v1.payload;

    CHECK_V1(foo_p == &storage_v1.payload, 4);
    CHECK_V1(foo_p->a == INITIAL_A_V1, 5);
    CHECK_V1(foo_p->b == FINAL_B_V1, 6);
    CHECK_V1(storage_v1.payload.b == FINAL_B_V1, 7);
    CHECK_V1(storage_v1.left == LEFT_V1, 8);
    CHECK_V1(storage_v1.right == RIGHT_V1, 9);
    CHECK_V1(a1_count_v1 == 3, 10);
    CHECK_V1(a1_values_v1[0] == address - 30, 11);
    CHECK_V1(a1_values_v1[1] == address + 2, 12);
    CHECK_V1(a1_values_v1[2] == address - 30, 13);
    CHECK_V1(a1_values_v1[1] - a1_values_v1[0] == 32, 16);

    return 0;
}
