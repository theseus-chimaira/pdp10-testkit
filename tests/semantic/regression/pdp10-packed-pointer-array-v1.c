/* PDP-10: pointer-array readback for GNU aligned/packed members.
 * Upstream strct-pack-2.c stores a pointer but never reads it back.
 */

struct packed_pointer_array_v1 {
    short value __attribute__((aligned(2), packed));
    short *ptr[2] __attribute__((aligned(2), packed));
};

extern void abort(void);

static struct packed_pointer_array_v1 record_v1;
static volatile short first_input_v1;
static volatile short second_input_v1;
static short first_v1;
static short second_v1;
volatile unsigned int fail_id;

int
main(void)
{
    short *p;

    first_input_v1 = 012345;
    second_input_v1 = 054321;
    first_v1 = first_input_v1;
    second_v1 = second_input_v1;
    record_v1.value = first_v1;
    record_v1.ptr[0] = &first_v1;
    record_v1.ptr[1] = &second_v1;

    p = record_v1.ptr[1];
    if (p != &second_v1 || *p != 054321) {
        fail_id = 1;
        abort();
    }
    p = record_v1.ptr[0];
    if (p != &first_v1 || *p != 012345) {
        fail_id = 2;
        abort();
    }
    if (record_v1.value != 012345) {
        fail_id = 3;
        abort();
    }

    record_v1.ptr[0] = &second_v1;
    if (record_v1.ptr[0] != &second_v1 ||
        record_v1.ptr[1] != &second_v1) {
        fail_id = 4;
        abort();
    }
    return 0;
}
