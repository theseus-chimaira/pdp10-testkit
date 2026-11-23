/*
 * GCC PDP-10 noreturn regression, freestanding C89 with GCC attributes.
 *
 * The historical builtin-noret-1.c originally referenced unsupported
 * _eexit because the GCC driver omitted the __pdp10__ predefine.
 * Its original 16 GCC cells now pass with that macro restored.
 * This companion additionally isolates:
 *
 *  - the standard abort and exit noreturn calls;
 *  - __builtin_abort, independently of a function declaration;
 *  - a user-defined function with __attribute__((noreturn)).
 *
 * The volatile selector prevents the compiler from eliminating all
 * call sites as unreachable by ordinary constant propagation.
 * At optimized levels, link_failure_v1 has NO definition: the
 * compiler must remove code AFTER a noreturn call.  At -O0 it is
 * defined as a real abort trap so the same source remains runnable.
 *
 * No fake abort/exit implementations or libc function stubs.
 */

extern void abort(void);
extern void exit(int);
extern void link_failure_v1(void);

volatile unsigned int selector_v1;
volatile unsigned int completed_v1;

static void marked_noreturn_v1(void) __attribute__((noreturn));

static void
marked_noreturn_v1(void)
{
    abort();
}

void
check_abort_v1(void)
{
    abort();
    link_failure_v1();
}

void
check_exit_v1(void)
{
    exit(9);
    link_failure_v1();
}

void
check_builtin_abort_v1(void)
{
    __builtin_abort();
    link_failure_v1();
}

void
check_attribute_v1(void)
{
    marked_noreturn_v1();
    link_failure_v1();
}

#ifndef __OPTIMIZE__
void
link_failure_v1(void)
{
    abort();
}
#endif

int
main(void)
{
    selector_v1 = 0;
    completed_v1 = 0;

    if (selector_v1 == 1)
        check_abort_v1();
    if (selector_v1 == 2)
        check_exit_v1();
    if (selector_v1 == 3)
        check_builtin_abort_v1();
    if (selector_v1 == 4)
        check_attribute_v1();

    completed_v1 = 1;
    if (completed_v1 != 1)
        abort();
    return 0;
}
