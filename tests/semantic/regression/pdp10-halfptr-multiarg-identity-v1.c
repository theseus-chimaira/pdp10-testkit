/* PDP-10 native halfword pointer, three-argument call identity, C89.
 * Reproduces the multi-argument pointer path of the larger torture
 * source with an actual indirect void * function call and a separate
 * assertion function.  This is not a substitute for the original.
 * Do not cast a volatile object through an unqualified pointer.
 */
extern void abort(void);

typedef unsigned short half_v1;
static half_v1 half_value_v1;
volatile unsigned int fail_id;
volatile unsigned int value_seen_v1;
half_v1 *volatile incoming_v1;
half_v1 *volatile returned_v1;

static void *
pass_pointer_v1(void *p)
{
    void * volatile copy = p;
    return copy;
}

static void *(*volatile pointer_call_v1)(void *) = pass_pointer_v1;

static void
check_v1(int yes, unsigned int id)
{
    if (!yes) {
        fail_id = id;
        abort();
    }
}

static void
check_half_pointer_v1(half_v1 *p, half_v1 value, unsigned int id)
{
    void *v = (*pointer_call_v1)((void *)p);
    half_v1 *q = (half_v1 *)v;
    incoming_v1 = p;
    returned_v1 = q;
    check_v1(q == p, id);
    value_seen_v1 = *q;
    check_v1(*q == value, id + 1);
}

int
main(void)
{
    half_value_v1 = (half_v1)0400000U;
    check_half_pointer_v1(&half_value_v1, (half_v1)0400000U, 12);
    return 0;
}
