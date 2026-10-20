/* KCC PDP-6 D-format sign/borrow regression.  A negative double has
 * its sign bit copied into the continuation word.  Two unrelated MOVNS
 * instructions are not a valid replacement for negating a D-format pair.
 */
extern void abort(void);

#define DF_SIGN_V1 0400000000000UL

union dformat_v1 {
    long double value;
    unsigned int words[2];
};

volatile union dformat_v1 probe_v1;

int
main(void)
{
    probe_v1.value = 1.0L;
    probe_v1.value = -probe_v1.value;
    if ((probe_v1.words[0] & DF_SIGN_V1) == 0 ||
        (probe_v1.words[1] & DF_SIGN_V1) == 0)
        abort();
    probe_v1.value = -probe_v1.value;
    if ((probe_v1.words[0] & DF_SIGN_V1) != 0 ||
        (probe_v1.words[1] & DF_SIGN_V1) != 0 ||
        probe_v1.value != 1.0L)
        abort();
    return 0;
}
