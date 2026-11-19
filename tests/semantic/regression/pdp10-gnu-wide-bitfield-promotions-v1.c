/* GNU extension policy for unsigned long long bitfields, bf-sign-2.c.
 * Unlike ISO C int bitfields, these GNU fields explicitly require an
 * independent target-width promotion decision. Native PDP-10 int has
 * 36 bits, making all nonnegative values of a 35-bit field fit int.
 * Check both small fields with identical signed-int promotion policy.
 */
extern void abort(void);
volatile unsigned int fail_id;
struct wide_bits_v1 {
    unsigned long long u3 : 3;
    unsigned long long u35 : 35;
};
static volatile struct wide_bits_v1 bits_v1;

int
main(void)
{
    bits_v1.u3 = 0ULL;
    bits_v1.u35 = 0ULL;
    if ((bits_v1.u3 - 2) >= 0) {
        fail_id = 1;
        abort();
    }
    if ((bits_v1.u35 - 2) >= 0) {
        fail_id = 2;
        abort();
    }
    bits_v1.u3 = 7ULL;
    bits_v1.u35 = ((1ULL << 35) - 1ULL);
    if (bits_v1.u3 != 7ULL) {
        fail_id = 3;
        abort();
    }
    if (bits_v1.u35 != ((1ULL << 35) - 1ULL)) {
        fail_id = 4;
        abort();
    }
    return 0;
}
