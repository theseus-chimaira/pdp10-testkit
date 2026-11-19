/* Bounded GNU labels-as-values address-identity diagnostic.
 * The original 920302-1.c uses short label deltas and then goto *.
 * Before executing an unbounded indirect transfer, check whether
 * the compiler preserves each target address through subtraction,
 * short conversion and re-addition. The labels are in one function.
 */

volatile unsigned int fail_id;
extern void abort(void);

static void
check_addresses_v1(void)
{
    void *base = &&label_a_v1;
    static void *labels[3] = {&&label_a_v1, &&label_b_v1,
                              &&label_c_v1};
    short displacement;
    int i;

    for (i = 0; i < 3; i++) {
        displacement = (short)(labels[i] - base);
        if (base + displacement != labels[i]) {
            fail_id = (unsigned int)i + 1U;
            abort();
        }
    }
    return;
label_a_v1:
label_b_v1:
label_c_v1:
    return;
}

int
main(void)
{
    check_addresses_v1();
    return 0;
}
