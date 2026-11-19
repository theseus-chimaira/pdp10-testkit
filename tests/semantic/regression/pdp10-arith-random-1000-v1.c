/* Reconstructed original 1000-iteration arithmetic stress, 36-bit PDP10.
 * Original simple_rand LCG and random_bitstring generation preserved
 * with unsigned 36-bit wrap and nine-bit char native widths.
 * Host Python independently derives six 36-bit rolling signatures
 * from 1000 x/y pairs, signed truncation-toward-zero q and remainder.
 * Exclude zero divisors and MIN/-1, which are undefined in C.
 * The historical 8*sizeof(long) termination assumes eight-bit bytes;
 * correct target termination is 9*sizeof(long)+6. No fake runtime.
 */
extern void abort(void);
volatile unsigned int fail_id;
static volatile unsigned long seed_v1 = 47114711UL;
static unsigned long hash_u9_v1, hash_s9_v1;
static unsigned long hash_u18_v1, hash_s18_v1;
static unsigned long hash_u36_v1, hash_s36_v1;

static unsigned long
rand_v1(void)
{
    unsigned long next = seed_v1 * 1103515245UL + 12345UL;
    seed_v1 = next;
    return next >> 8;
}

static unsigned long
bits_v1(void)
{
    unsigned long x = 0UL;
    unsigned long ran;
    int n_bits;
    int total = 0;
    for (;;) {
        ran = rand_v1();
        n_bits = (int)((ran >> 1) % 16UL);
        total += n_bits;
        if (n_bits == 0)
            return x;
        x <<= n_bits;
        if (ran & 1UL)
            x |= (1UL << n_bits) - 1UL;
        if (total > 9 * (int)sizeof(long) + 6)
            return x;
    }
}

static unsigned long
mix_v1(unsigned long hash, unsigned long value)
{
    return (hash * 33UL) ^ value;
}

static void
check_u9_v1(unsigned long x, unsigned long y)
{
    volatile unsigned char a = (unsigned char)x;
    volatile unsigned char b = (unsigned char)y;
    unsigned char quotient;
    unsigned char remainder;
    if (b == 0U) {
        hash_u9_v1 = mix_v1(hash_u9_v1, 012345UL);
        return;
    }
    quotient = a / b;
    remainder = a % b;
    hash_u9_v1 = mix_v1(hash_u9_v1, (unsigned long)quotient);
    hash_u9_v1 = mix_v1(hash_u9_v1, (unsigned long)remainder);
}

static void
check_s9_v1(unsigned long x, unsigned long y)
{
    volatile signed char a = (signed char)x;
    volatile signed char b = (signed char)y;
    signed char quotient;
    signed char remainder;
    if (b == 0 || (a == (signed char)(1UL << 8) && b == -1)) {
        hash_s9_v1 = mix_v1(hash_s9_v1, 012345UL);
        return;
    }
    quotient = a / b;
    remainder = a % b;
    hash_s9_v1 = mix_v1(hash_s9_v1, (unsigned long)quotient);
    hash_s9_v1 = mix_v1(hash_s9_v1, (unsigned long)remainder);
}

static void
check_u18_v1(unsigned long x, unsigned long y)
{
    volatile unsigned short a = (unsigned short)x;
    volatile unsigned short b = (unsigned short)y;
    unsigned short quotient;
    unsigned short remainder;
    if (b == 0U) {
        hash_u18_v1 = mix_v1(hash_u18_v1, 012345UL);
        return;
    }
    quotient = a / b;
    remainder = a % b;
    hash_u18_v1 = mix_v1(hash_u18_v1, (unsigned long)quotient);
    hash_u18_v1 = mix_v1(hash_u18_v1, (unsigned long)remainder);
}

static void
check_s18_v1(unsigned long x, unsigned long y)
{
    volatile signed short a = (signed short)x;
    volatile signed short b = (signed short)y;
    signed short quotient;
    signed short remainder;
    if (b == 0 || (a == (signed short)(1UL << 17) && b == -1)) {
        hash_s18_v1 = mix_v1(hash_s18_v1, 012345UL);
        return;
    }
    quotient = a / b;
    remainder = a % b;
    hash_s18_v1 = mix_v1(hash_s18_v1, (unsigned long)quotient);
    hash_s18_v1 = mix_v1(hash_s18_v1, (unsigned long)remainder);
}

static void
check_u36_v1(unsigned long x, unsigned long y)
{
    volatile unsigned long a = (unsigned long)x;
    volatile unsigned long b = (unsigned long)y;
    unsigned long quotient;
    unsigned long remainder;
    if (b == 0U) {
        hash_u36_v1 = mix_v1(hash_u36_v1, 012345UL);
        return;
    }
    quotient = a / b;
    remainder = a % b;
    hash_u36_v1 = mix_v1(hash_u36_v1, (unsigned long)quotient);
    hash_u36_v1 = mix_v1(hash_u36_v1, (unsigned long)remainder);
}

static void
check_s36_v1(unsigned long x, unsigned long y)
{
    volatile signed long a = (signed long)x;
    volatile signed long b = (signed long)y;
    signed long quotient;
    signed long remainder;
    if (b == 0 || (a == (signed long)(1UL << 35) && b == -1)) {
        hash_s36_v1 = mix_v1(hash_s36_v1, 012345UL);
        return;
    }
    quotient = a / b;
    remainder = a % b;
    hash_s36_v1 = mix_v1(hash_s36_v1, (unsigned long)quotient);
    hash_s36_v1 = mix_v1(hash_s36_v1, (unsigned long)remainder);
}

int
main(void)
{
    unsigned long x, y;
    int i;
    if (sizeof(char) != 1 || sizeof(short) != 2 ||
        sizeof(long) != 4) {
        fail_id = 1;
        abort();
    }
    for (i = 0; i < 1000; i++) {
        x = bits_v1();
        y = bits_v1();
        if (i == 0 && (x != 1023UL || y != 68719345664UL)) {
            fail_id = 1;
            abort();
        }
        if (i == 1 && (x != 0UL || y != 0UL)) {
            fail_id = 1;
            abort();
        }
        if (i == 2 && (x != 68585263103UL || y != 51606683648UL)) {
            fail_id = 1;
            abort();
        }
        if (i == 3 && (x != 68718952448UL || y != 0UL)) {
            fail_id = 1;
            abort();
        }
        check_u9_v1(x, y);
        check_s9_v1(x, y);
        check_u18_v1(x, y);
        check_s18_v1(x, y);
        check_u36_v1(x, y);
        check_s36_v1(x, y);
    }
    /* u9: independently skipped 457 undefined cases. */
    if (hash_u9_v1 != 49137987253UL) {
        fail_id = 2;
        abort();
    }
    /* s9: independently skipped 461 undefined cases. */
    if (hash_s9_v1 != 44256830091UL) {
        fail_id = 3;
        abort();
    }
    /* u18: independently skipped 263 undefined cases. */
    if (hash_u18_v1 != 66627985415UL) {
        fail_id = 4;
        abort();
    }
    /* s18: independently skipped 265 undefined cases. */
    if (hash_s18_v1 != 24353083531UL) {
        fail_id = 5;
        abort();
    }
    /* u36: independently skipped 159 undefined cases. */
    if (hash_u36_v1 != 4956819756UL) {
        fail_id = 6;
        abort();
    }
    /* s36: independently skipped 159 undefined cases. */
    if (hash_s36_v1 != 39023015253UL) {
        fail_id = 7;
        abort();
    }
    return 0;
}
