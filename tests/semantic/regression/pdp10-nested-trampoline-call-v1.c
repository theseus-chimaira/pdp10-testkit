/* Exercise the GNU nested closure/trampoline intended by 921215-1.c.
 * Unlike the original, main checks both the callback and captured
 * state after the trampoline was called; no NO_TRAMPOLINES bypass.
 * This source is GCC-specific; KCC GNU nested-function support is
 * not assumed or faked.
 */
volatile unsigned int fail_id;
static volatile int captures_v1;
extern void abort(void);

static void
invoke_v1(void (*fn)(void))
{
    fn();
}

static void
outer_v1(int expected)
{
    int local_count;

    local_count = expected;
    void inner_v1(void)
    {
        captures_v1 += local_count;
        local_count += 1;
    }
    invoke_v1(inner_v1);
    if (local_count != expected + 1) {
        fail_id = 1;
        abort();
    }
}

int
main(void)
{
    captures_v1 = 0;
    outer_v1(2);
    outer_v1(7);
    if (captures_v1 != 9) {
        fail_id = 2;
        abort();
    }
    return 0;
}
