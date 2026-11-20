/*
 * PDP-10 C89 compiler oracle derived from unchanged GCC 960521-1.c.
 *
 * The historical test allocates two 32768-element int arrays using
 * malloc(), for 65536 36-bit words before other code/stack/runtime data.
 * This exceeds useful bare PDP-6 core capacity and cannot prove its
 * indexing semantics with a successful freestanding guest execution.
 *
 * This independent test preserves the two original fill loops, the
 * *b++ = 0 sentinel, and the original b[-1] check.  It uses 4096-element
 * static native-word arrays to test nontrivial indexing without a fake
 * malloc implementation or a hidden heap ABI.  Both end canaries and
 * every array element are independently checked after the actual loops.
 *
 * This validates native C pointer/array behavior, NOT hosted allocation
 * correctness or exact 65536-word memory pressure. The original remains
 * registered separately and its reported timeouts remain real failures.
 */

#define P10_BLOCK_WORDS_V1 4096
#define P10_LEFT_GUARD_V1 0123456
#define P10_RIGHT_GUARD_V1 0654321

extern void abort(void);

struct p10_guarded_array_v1 {
    volatile int before;
    volatile int data[P10_BLOCK_WORDS_V1];
    volatile int after;
};

static volatile int a_storage_v1[P10_BLOCK_WORDS_V1];
static struct p10_guarded_array_v1 b_storage_v1;
static volatile int *a_v1;
static volatile int *b_v1;
static volatile int n_v1;

static void
fill_v1(void)
{
    int i;

    for (i = 0; i < n_v1; i++)
        a_v1[i] = -1;
    for (i = 0; i < P10_BLOCK_WORDS_V1 - 1; i++)
        b_v1[i] = -1;
}

int
main(void)
{
    int i;

    n_v1 = P10_BLOCK_WORDS_V1;
    a_v1 = a_storage_v1;
    b_storage_v1.before = P10_LEFT_GUARD_V1;
    b_storage_v1.after = P10_RIGHT_GUARD_V1;
    b_v1 = b_storage_v1.data;

    /* Identical shifted base and zero sentinel operation to original. */
    *b_v1++ = 0;
    fill_v1();

    if (b_v1[-1] != 0 ||
            b_storage_v1.data[0] != 0 ||
            b_storage_v1.before != P10_LEFT_GUARD_V1 ||
            b_storage_v1.after != P10_RIGHT_GUARD_V1)
        abort();

    /* Check all writes, including the last valid a[] and b[] slots. */
    for (i = 0; i < P10_BLOCK_WORDS_V1; i++)
        if (a_storage_v1[i] != -1)
            abort();
    for (i = 0; i < P10_BLOCK_WORDS_V1 - 1; i++)
        if (b_v1[i] != -1 || b_storage_v1.data[i + 1] != -1)
            abort();

    return 0;
}
