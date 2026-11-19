/* An independent readback oracle for upstream GCC 931110-1.c.
 * The original merely stores zeros without checking array neighbors,
 * bitfield ordering, sign extension or later nonzero writes.
 */
struct small_v1 {
    signed short f:3;
    signed short g:3;
    signed short h:10;
};

static struct {
    int left_guard;
    struct small_v1 entry[10];
    int right_guard;
} record_v1;

static volatile short source_v1;
volatile unsigned int fail_id;
extern void abort(void);

int
main(void)
{
    int i;

    record_v1.left_guard = 012345670;
    record_v1.right_guard = 076543210;
    for (i = 0; i < 10; ++i) {
        record_v1.entry[i].f = 0;
        record_v1.entry[i].g = 2;
        record_v1.entry[i].h = 127;
    }
    for (i = 0; i < 10; ++i) {
        if (record_v1.entry[i].f != 0 ||
            record_v1.entry[i].g != 2 ||
            record_v1.entry[i].h != 127) {
            fail_id = 1;
            abort();
        }
    }
    for (i = 0; i < 10; ++i) {
        source_v1 = (short)(i % 4);
        record_v1.entry[i].f = source_v1 - 2;
        record_v1.entry[i].g = 1;
        record_v1.entry[i].h = -1;
    }
    for (i = 0; i < 10; ++i) {
        if (record_v1.entry[i].f != i % 4 - 2 ||
            record_v1.entry[i].g != 1 ||
            record_v1.entry[i].h != -1) {
            fail_id = 2;
            abort();
        }
    }
    if (record_v1.left_guard != 012345670 ||
        record_v1.right_guard != 076543210) {
        fail_id = 3;
        abort();
    }
    return 0;
}
