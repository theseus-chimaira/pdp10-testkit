/* Nonvacuous GNU nested-function trampoline test for 931002-1.c.
 * The original has no assertions and a NO_TRAMPOLINES early skip.
 * Preserve three invocations of the nested callback and record them.
 */

volatile unsigned int fail_id;
volatile unsigned int callback_calls_v1;
volatile unsigned int nested_calls_v1;
extern void abort(void);

static void
invoke_v1(void (*fn)(void))
{
    fn();
}

int
main(void)
{
    unsigned int captured_v1 = 3U;

    void t0_v1(void)
    {
        callback_calls_v1++;
        if (captured_v1 != 3U) {
            fail_id = 1;
            abort();
        }
    }
    void t1_v1(void)
    {
        nested_calls_v1++;
        invoke_v1(t0_v1);
    }
    void t2_v1(void)
    {
        t1_v1();
    }

    t1_v1();
    t1_v1();
    t2_v1();
    if (callback_calls_v1 != 3U || nested_calls_v1 != 3U) {
        fail_id = 2;
        abort();
    }
    return 0;
}
