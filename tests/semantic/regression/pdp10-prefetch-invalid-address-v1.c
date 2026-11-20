/*
 * PDP-10 native-width companion to builtin-prefetch-6.c.
 *
 * Prefetch is a nonfaulting address hint.  A PDP-6 without a hardware
 * prefetch instruction may ignore the hint, but must still evaluate
 * every address expression exactly once.  Never dereference the
 * deliberately forged pointers.
 *
 * The old GNU test assumes 8 bits per C byte.  On the PDP-10 target
 * CHAR_BIT is 9, so use the actual target width to cover all address
 * patterns, not an accidentally truncated 32-bit subset.
 */

extern void abort(void);

#define ADDRESS_COUNT_V1 65
#define TARGET_BITS_V1 9

static void *invalid_v1[ADDRESS_COUNT_V1];
static unsigned long original_bits_v1[ADDRESS_COUNT_V1];
static volatile unsigned int evaluations_v1;
static volatile unsigned int read_calls_v1;
static volatile unsigned int write_calls_v1;
volatile unsigned int fail_id;

static void
check_v1(int ok, unsigned int id)
{
    if (!ok) {
        fail_id = id;
        abort();
    }
}

static void *
address_v1(unsigned int index)
{
    ++evaluations_v1;
    check_v1(index < ADDRESS_COUNT_V1, 10);
    return invalid_v1[index];
}

static void
prefetch_for_read_v1(void)
{
    unsigned int i;

    for (i = 0; i < ADDRESS_COUNT_V1; ++i) {
        __builtin_prefetch(address_v1(i), 0, 0);
        ++read_calls_v1;
    }
}

static void
prefetch_for_write_v1(void)
{
    unsigned int i;

    for (i = 0; i < ADDRESS_COUNT_V1; ++i) {
        __builtin_prefetch(address_v1(i), 1, 0);
        ++write_calls_v1;
    }
}

int
main(void)
{
    unsigned int i;
    unsigned int bit_count;
    unsigned long word;
    unsigned long checksum;

    fail_id = 0;
    evaluations_v1 = 0;
    read_calls_v1 = 0;
    write_calls_v1 = 0;

    /* A PDP-10 C byte contains nine bits; a native 36-bit pointer is
       four such bytes.  Limit shifts to the width of unsigned long. */
    bit_count = (unsigned int)(sizeof(void *) * TARGET_BITS_V1);
    check_v1(sizeof(char) == 1, 1);
    check_v1(sizeof(unsigned long) * TARGET_BITS_V1 == 36, 2);
    check_v1(bit_count == 36, 3);
    check_v1(bit_count + 1 < ADDRESS_COUNT_V1, 4);

    checksum = 0;
    for (i = 0; i < ADDRESS_COUNT_V1; ++i) {
        word = i < bit_count ? (1UL << i) : 0UL;
        original_bits_v1[i] = word;
        invalid_v1[i] = (void *)word;
        checksum ^= (word ^ (unsigned long)i);
    }

    /* Both passes must evaluate all 65 address expressions, including
       one-hot values in bits 32..35 and all zero/NULL tail entries. */
    prefetch_for_read_v1();
    check_v1(read_calls_v1 == ADDRESS_COUNT_V1, 5);
    check_v1(evaluations_v1 == ADDRESS_COUNT_V1, 6);
    prefetch_for_write_v1();
    check_v1(write_calls_v1 == ADDRESS_COUNT_V1, 7);
    check_v1(evaluations_v1 == 2 * ADDRESS_COUNT_V1, 8);

    word = 0;
    for (i = 0; i < ADDRESS_COUNT_V1; ++i) {
        check_v1(original_bits_v1[i] ==
                 (i < bit_count ? (1UL << i) : 0UL), 9);
        word ^= (original_bits_v1[i] ^ (unsigned long)i);
    }
    check_v1(word == checksum, 11);
    check_v1(fail_id == 0, 12);
    return 0;
}
