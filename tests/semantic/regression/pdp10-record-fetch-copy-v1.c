/*
 * Native PDP-10 compiler oracle for the unchanged GCC 990628-1.c.
 *
 * Test the actual memset(0x55), byte representation, 101-int struct
 * assignment, pointer postincrement and two-step SQL fetch loop.
 * The original uses malloc() to obtain the destination; this
 * freestanding compiler fixture instead owns one real static record.
 * No test allocator is installed and no hosted malloc success is
 * implied. The original historical test and its failures remain.
 */

#include <string.h>

extern void abort(void);

#define P10_RECORD_WORDS_V1 100
#define P10_BYTE_PATTERN_V1 (0x55 * 01001001001)
#define P10_RECORD_LEFT_V1 01234567
#define P10_RECORD_RIGHT_V1 07654321

struct p10_sqlca_v1 {
    long sqlcode;
};

struct p10_record_v1 {
    int dummy;
    int a[P10_RECORD_WORDS_V1];
};

struct p10_destination_v1 {
    int before;
    struct p10_record_v1 record;
    int after;
};

static struct p10_sqlca_v1 sqlca_v1;
static struct p10_record_v1 data_tmp_v1;
static struct p10_record_v1 *data_ptr_v1;
static struct p10_destination_v1 dest_v1;
static volatile int fetch_count_v1;
static volatile int store_count_v1;

static int
num_records_v1(void)
{
    return 1;
}

static void
fetch_v1(void)
{
    memset(&data_tmp_v1, 0x55, sizeof(data_tmp_v1));
    sqlca_v1.sqlcode = (++fetch_count_v1 > 1 ? 100 : 0);
}

static void
load_data_v1(void)
{
    struct p10_record_v1 *p;
    int num = num_records_v1();

    if (num != 1)
        abort();
    data_ptr_v1 = &dest_v1.record;
    memset(data_ptr_v1, 0xaa, sizeof(*data_ptr_v1));

    fetch_v1();
    p = data_ptr_v1;
    while (sqlca_v1.sqlcode == 0) {
        *p++ = data_tmp_v1;
        ++store_count_v1;
        fetch_v1();
    }
    if (p != data_ptr_v1 + 1)
        abort();
}

int
main(void)
{
    int i;

    /* Four 9-bit bytes per native 36-bit integer are required. */
    if (sizeof(int) != 4 || sizeof(struct p10_record_v1) != 404)
        abort();

    dest_v1.before = P10_RECORD_LEFT_V1;
    dest_v1.after = P10_RECORD_RIGHT_V1;
    load_data_v1();

    if (fetch_count_v1 != 2 || store_count_v1 != 1 ||
            sqlca_v1.sqlcode != 100 ||
            data_ptr_v1 != &dest_v1.record ||
            dest_v1.before != P10_RECORD_LEFT_V1 ||
            dest_v1.after != P10_RECORD_RIGHT_V1 ||
            dest_v1.record.dummy != P10_BYTE_PATTERN_V1 ||
            data_tmp_v1.dummy != P10_BYTE_PATTERN_V1)
        abort();

    for (i = 0; i < P10_RECORD_WORDS_V1; i++) {
        if (dest_v1.record.a[i] != P10_BYTE_PATTERN_V1 ||
                data_tmp_v1.a[i] != P10_BYTE_PATTERN_V1)
            abort();
    }
    return 0;
}
