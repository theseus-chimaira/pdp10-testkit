/* PDP-10 byte-sized object pointer round-trip locator, C89, version 1.
 * Retain the full 9/18/36-bit object data and function-pointer call.
 * The original old.tort companion has distinct KCC and GCC failures.
 * Keep the observed values and all three pointer identities visible
 * to the native simulator: no alias violations and no hosted libc.
 */
extern void abort(void);

typedef unsigned char byte_v1;
typedef unsigned short half_v1;
typedef unsigned long word_v1;

/* These are ordinary C objects: the function pointer and result probes
 * are volatile, but the address casts never discard object qualifiers.
 */
static byte_v1 b_v1;
static half_v1 h_v1;
static word_v1 w_v1;

volatile unsigned int fail_id;
volatile unsigned int b_seen_v1;
volatile unsigned int h_seen_v1;
volatile word_v1 w_seen_v1;
volatile unsigned int identity_mask_v1;
volatile unsigned int value_mask_v1;

static void *
identity_v1(void *p)
{
    void * volatile saved = p;
    return saved;
}

static void *(*volatile invoke_v1)(void *) = identity_v1;

int
main(void)
{
    byte_v1 *bp;
    half_v1 *hp;
    word_v1 *wp;

    b_v1 = (byte_v1)0400U;
    h_v1 = (half_v1)0400000U;
    w_v1 = 0400000000000UL;

    bp = (byte_v1 *)(*invoke_v1)((void *)&b_v1);
    hp = (half_v1 *)(*invoke_v1)((void *)&h_v1);
    wp = (word_v1 *)(*invoke_v1)((void *)&w_v1);

    if (bp != &b_v1)
        identity_mask_v1 |= 1U;
    if (hp != &h_v1)
        identity_mask_v1 |= 2U;
    if (wp != &w_v1)
        identity_mask_v1 |= 4U;

    b_seen_v1 = *bp;
    h_seen_v1 = *hp;
    w_seen_v1 = *wp;
    if (b_seen_v1 != 0400U)
        value_mask_v1 |= 1U;
    if (h_seen_v1 != 0400000U)
        value_mask_v1 |= 2U;
    if (w_seen_v1 != 0400000000000UL)
        value_mask_v1 |= 4U;
    if (identity_mask_v1 != 0U || value_mask_v1 != 0U) {
        fail_id = identity_mask_v1 | (value_mask_v1 << 8);
        abort();
    }
    return 0;
}
