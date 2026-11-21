/* Native PDP-10 S=18 pointer equality after an S=9 pointer call.
 * No pointer observations are inserted between the identity return
 * and its == comparison: isolates a register lifetime/codegen defect
 * from the larger 9/18/36-bit pointer torture without weakening it.
 */
extern void abort(void);

typedef unsigned char byte_v1;
typedef unsigned short half_v1;
static byte_v1 byte_value_v1;
static half_v1 half_value_v1;
volatile unsigned int fail_id;

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
check_byte_pointer_v1(byte_v1 *p, byte_v1 value, unsigned int id)
{
    void *v = (*pointer_call_v1)((void *)p);
    byte_v1 *q = (byte_v1 *)v;
    check_v1(q == p, id);
    check_v1(*q == value, id + 1);
}

static void
check_half_pointer_v1(half_v1 *p, half_v1 value, unsigned int id)
{
    void *v = (*pointer_call_v1)((void *)p);
    half_v1 *q = (half_v1 *)v;
    check_v1(q == p, id);
    check_v1(*q == value, id + 1);
}

int
main(void)
{
    byte_value_v1 = (byte_v1)0400U;
    half_value_v1 = (half_v1)0400000U;
    check_byte_pointer_v1(&byte_value_v1, (byte_v1)0400U, 10);
    check_half_pointer_v1(&half_value_v1, (half_v1)0400000U, 12);
    return 0;
}
