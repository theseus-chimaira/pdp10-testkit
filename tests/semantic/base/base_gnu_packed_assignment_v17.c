volatile int __test_exit;

typedef unsigned short u16;

struct packed_value_v17 {
    unsigned char a;
    u16 b;
    unsigned char c;
} __attribute__((packed));

static struct packed_value_v17 source_v17 = { 1, 012345, 7 };
static struct packed_value_v17 a_v17;
static struct packed_value_v17 b_v17;
static struct packed_value_v17 c_v17;

int
main(void)
{
    int v;

    v = (a_v17 = source_v17).b;
    if (v != 012345 || a_v17.a != 1 || a_v17.c != 7)
        return 1;

    c_v17 = b_v17 = a_v17;
    if (b_v17.a != 1 || b_v17.b != 012345 || b_v17.c != 7)
        return 2;
    if (c_v17.a != 1 || c_v17.b != 012345 || c_v17.c != 7)
        return 3;

    return 0;
}
