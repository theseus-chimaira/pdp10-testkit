/* PDP-10: executable oracle for the packed unsigned-long member.
 * The upstream packed-2.c only stores zero and returns success.
 * Test multiple patterns and a change of the adjacent short member.
 */

struct packed_record_v1 {
    unsigned short half;
    unsigned long whole __attribute__((packed));
};

static struct packed_record_v1 record_v1;
static volatile unsigned short half_input_v1;
static volatile unsigned long whole_input_v1;
volatile unsigned int fail_id;

extern void abort(void);

int
main(void)
{
    half_input_v1 = 0123456U;
    whole_input_v1 = 012345670123UL;
    record_v1.half = half_input_v1;
    record_v1.whole = whole_input_v1;
    if (record_v1.half != half_input_v1 ||
        record_v1.whole != whole_input_v1) {
        fail_id = 1;
        abort();
    }

    whole_input_v1 = 0765432107654UL;
    record_v1.whole = whole_input_v1;
    if (record_v1.half != 0123456U ||
        record_v1.whole != whole_input_v1) {
        fail_id = 2;
        abort();
    }

    record_v1.whole = 0UL;
    if (record_v1.whole != 0UL || record_v1.half != 0123456U) {
        fail_id = 3;
        abort();
    }
    return 0;
}
