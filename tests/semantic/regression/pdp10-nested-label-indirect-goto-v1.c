/* Nonvacuous companion for GCC 920415-1.c.
 * The original labels feature is exercised without NO_LABEL_VALUES:
 * a nested GNU function returns the address of an enclosing local label,
 * which is used for an indirect goto. The bypass is a failing path.
 */

static volatile int total_v1;
volatile unsigned int fail_id;
extern void abort(void);

static void
enter_v1(int value)
{
    __label__ target_v1;
    void *address_v1(void)
    {
        return &&target_v1;
    }
    void * volatile jump_v1;
    volatile int marker_v1;

    marker_v1 = value;
    jump_v1 = address_v1();
    goto *jump_v1;
    fail_id = 1;
    abort();

target_v1:
    if (marker_v1 != value) {
        fail_id = 2;
        abort();
    }
    total_v1 += marker_v1;
}

int
main(void)
{
    total_v1 = 0;
    enter_v1(2);
    enter_v1(7);
    if (total_v1 != 9) {
        fail_id = 3;
        abort();
    }
    return 0;
}
