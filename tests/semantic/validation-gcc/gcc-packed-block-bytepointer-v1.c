/*
 * Regression for PDP-10 packed aggregate block-copy addressing.
 *
 * A packed record has byte alignment even though its first fields occupy
 * 18 and 36 bits.  GCC must convert ordinary stack and symbol addresses
 * to 9-bit byte pointers before an inline LDB/DPB copy.  Check the fields
 * independently of the later packed halfword extraction bugs exercised by
 * the original upstream 20010518-2.c test.
 *
 * The C source remains C89 apart from the target's GNU packed attribute.
 */
typedef struct packed_record_v1 {
    short a;
    long b;
    short c;
    short d;
    char tail[6];
} __attribute__((packed)) packed_record_v1;

typedef struct packed_outer_v1 {
    char lead;
    packed_record_v1 data;
} __attribute__((packed)) packed_outer_v1;

static const packed_record_v1 initial_v1 = {
    1, 2, 3, 4, { 0 }
};

int
main(void)
{
    volatile packed_record_v1 value;
    volatile packed_record_v1 *p = &value;
    volatile packed_outer_v1 outer;

    *p = initial_v1;
    if (p->a != 1)
        return 1;
    if (p->b != 2)
        return 2;

    /* A nested packed record can already arrive as a byte pointer.
       Do not reset its P,S selector to the first byte of the word. */
    p = &outer.data;
    *p = initial_v1;
    if (p->a != 1)
        return 3;
    if (p->b != 2)
        return 4;
    return 0;
}
