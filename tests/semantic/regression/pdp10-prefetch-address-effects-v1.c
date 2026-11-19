/* Executable PDP-10 prefetch oracle for a no-hardware-prefetch target.
 * Address expressions are evaluated exactly once, including volatile
 * accesses, although the prefetch operation itself may be a no-op.
 * No invented hardware prefetch opcode or libc shim is required.
 * Companion to upstream builtin-prefetch-{1,2,3,5,6}.c.
 */

static int words_v1[32];
static char bytes_v1[8];
static volatile int next_v1;
static volatile int calls_v1;
static volatile int *volatile shared_v1;
volatile unsigned int fail_id;
extern void abort(void);

static int *
address_v1(int index)
{
    calls_v1++;
    return &words_v1[index];
}

static void
global_prefetch_v1(void)
{
    __builtin_prefetch(&words_v1[next_v1++], 0, 0);
    __builtin_prefetch(&words_v1[next_v1++], 1, 3);
    __builtin_prefetch(address_v1(6), 0, 1);
}

static void
local_prefetch_v1(void)
{
    int local_v1[4];
    int i;
    int *p;

    for (i = 0; i < 4; i++)
        local_v1[i] = i + 20;
    p = local_v1;
    __builtin_prefetch(p++, 0, 2);
    if (p != &local_v1[1] || local_v1[0] != 20) {
        fail_id = 1;
        abort();
    }
}

int
main(void)
{
    int i;

    for (i = 0; i < 32; i++)
        words_v1[i] = i + 100;
    for (i = 0; i < 8; i++)
        bytes_v1[i] = (char)(i + 40);
    next_v1 = 3;
    calls_v1 = 0;
    shared_v1 = &words_v1[7];

    global_prefetch_v1();
    if (next_v1 != 5 || calls_v1 != 1) {
        fail_id = 2;
        abort();
    }
    __builtin_prefetch(shared_v1, 0, 0);
    __builtin_prefetch(shared_v1, 1, 0);
    __builtin_prefetch(&words_v1[next_v1++], 0, 3);
    if (next_v1 != 6 || shared_v1 != &words_v1[7]) {
        fail_id = 3;
        abort();
    }

    /* Prefetch accepts an address without dereferencing it. */
    __builtin_prefetch((void *)0, 0, 0);
    __builtin_prefetch((void *)0, 1, 0);
    /* The 9-bit character addresses can lie inside a 36-bit word. */
    __builtin_prefetch(&bytes_v1[1], 0, 0);
    __builtin_prefetch(&bytes_v1[3], 1, 1);
    local_prefetch_v1();

    for (i = 0; i < 32; i++)
        if (words_v1[i] != i + 100) {
            fail_id = 4;
            abort();
        }
    for (i = 0; i < 8; i++)
        if (bytes_v1[i] != i + 40) {
            fail_id = 5;
            abort();
        }
    return 0;
}
