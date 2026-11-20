/*
 * PDP-10 byte-pointer and object-pointer round-trip regression.
 *
 * This replaces the former system-specific test and uses the actual
 * C representation (9-bit char, 18-bit short, 36-bit long), never
 * assumes 8-bit bytes, and has one unambiguous zero-success oracle.
 *
 * In particular, object pointers of different byte sizes must survive
 * conversion to void *, a function call, and conversion back to their
 * original types.  Access through an unrelated pointer type is NOT
 * tested: such aliasing would have no portable C89 result.
 *
 * No hosted headers, formatted I/O, or allocator are required.
 */

extern void abort(void);

typedef unsigned char byte_v1;
typedef unsigned short half_v1;
typedef unsigned long word_v1;

struct mixed_v1 {
    word_v1 leading[6];
    byte_v1 byte;
    word_v1 separator;
    byte_v1 bytes[48];
};

struct half_mixed_v1 {
    word_v1 leading[6];
    half_v1 half;
    word_v1 separator;
    half_v1 halves[48];
};

union arrays_v1 {
    byte_v1 bytes[48];
    half_v1 halves[24];
    word_v1 words[12];
};

static byte_v1 bytes_v1[48];
static half_v1 halves_v1[48];
static word_v1 words_v1[48];
static struct mixed_v1 mixed_v1;
static struct half_mixed_v1 half_mixed_v1;
static union arrays_v1 arrays_v1;

static byte_v1 byte_value_v1;
static half_v1 half_value_v1;
static word_v1 word_value_v1;

volatile unsigned int fail_id;

static void *
pass_pointer_v1(void *p)
{
    void * volatile copied = p;
    return copied;
}

static void *(*volatile pointer_call_v1)(void *) = pass_pointer_v1;

static void
check_v1(int result, unsigned int id)
{
    if (!result) {
        fail_id = id;
        abort();
    }
}

/*
 * Each type's original pointer must survive a void * round trip.
 * Compare both identity and data: comparing pointer values alone
 * would miss an incorrect byte-size selector on PDP-10 hardware.
 */
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

static void
check_word_pointer_v1(word_v1 *p, word_v1 value, unsigned int id)
{
    void *v = (*pointer_call_v1)((void *)p);
    word_v1 *q = (word_v1 *)v;
    check_v1(q == p, id);
    check_v1(*q == value, id + 1);
}

int
main(void)
{
    unsigned int i;
    byte_v1 *bp;
    half_v1 *hp;
    word_v1 *wp;
    void *v;

    /* The native C memory unit is 9 bits on this target. */
    check_v1(sizeof(byte_v1) == 1, 1);
    check_v1(sizeof(half_v1) == 2, 2);
    check_v1(sizeof(word_v1) == 4, 3);

    byte_value_v1 = (byte_v1)0400U;
    half_value_v1 = (half_v1)0400000U;
    word_value_v1 = 0400000000000UL;

    check_byte_pointer_v1(&byte_value_v1, (byte_v1)0400U, 10);
    check_half_pointer_v1(&half_value_v1, (half_v1)0400000U, 12);
    check_word_pointer_v1(&word_value_v1, 0400000000000UL, 14);

    for (i = 0; i < 48; ++i) {
        bytes_v1[i] = (byte_v1)(0400U + i);
        halves_v1[i] = (half_v1)(0400000U + i);
        words_v1[i] = 0400000000000UL + (word_v1)i;
    }

    for (i = 0; i < 47; ++i) {
        check_byte_pointer_v1(&bytes_v1[i],
                              (byte_v1)(0400U + i), 20);
        check_half_pointer_v1(&halves_v1[i],
                              (half_v1)(0400000U + i), 22);
        check_word_pointer_v1(&words_v1[i],
                              0400000000000UL + (word_v1)i, 24);

        /* A decoded pointer must keep its element stride. */
        v = pass_pointer_v1(&bytes_v1[i]);
        bp = (byte_v1 *)v;
        check_v1(bp + 1 == &bytes_v1[i + 1], 26);
        check_v1(bp[1] == (byte_v1)(0401U + i), 27);

        v = pass_pointer_v1(&halves_v1[i]);
        hp = (half_v1 *)v;
        check_v1(hp + 1 == &halves_v1[i + 1], 28);
        check_v1(hp[1] == (half_v1)(0400001U + i), 29);

        v = pass_pointer_v1(&words_v1[i]);
        wp = (word_v1 *)v;
        check_v1(wp + 1 == &words_v1[i + 1], 30);
        check_v1(wp[1] == 0400000000001UL + (word_v1)i, 31);
    }

    /* Nested records place byte-sized and halfword-sized members
       at offsets that are not interchangeable with word pointers. */
    mixed_v1.byte = (byte_v1)0437U;
    half_mixed_v1.half = (half_v1)0432101U;
    check_byte_pointer_v1(&mixed_v1.byte, (byte_v1)0437U, 40);
    check_half_pointer_v1(&half_mixed_v1.half, (half_v1)0432101U, 42);

    for (i = 0; i < 48; ++i) {
        mixed_v1.bytes[i] = (byte_v1)(0400U + i);
        half_mixed_v1.halves[i] = (half_v1)(0400000U + i);
    }
    for (i = 0; i < 48; ++i) {
        check_byte_pointer_v1(&mixed_v1.bytes[i],
                              (byte_v1)(0400U + i), 44);
        check_half_pointer_v1(&half_mixed_v1.halves[i],
                              (half_v1)(0400000U + i), 46);
    }

    /* A union member is read only while that same member is active. */
    for (i = 0; i < 48; ++i)
        arrays_v1.bytes[i] = (byte_v1)(0400U + i);
    for (i = 0; i < 48; ++i)
        check_byte_pointer_v1(&arrays_v1.bytes[i],
                              (byte_v1)(0400U + i), 50);

    for (i = 0; i < 24; ++i)
        arrays_v1.halves[i] = (half_v1)(0400000U + i);
    for (i = 0; i < 24; ++i)
        check_half_pointer_v1(&arrays_v1.halves[i],
                              (half_v1)(0400000U + i), 52);

    for (i = 0; i < 12; ++i)
        arrays_v1.words[i] = 0400000000000UL + (word_v1)i;
    for (i = 0; i < 12; ++i)
        check_word_pointer_v1(&arrays_v1.words[i],
                              0400000000000UL + (word_v1)i, 54);

    check_v1(fail_id == 0, 60);
    return 0;
}
