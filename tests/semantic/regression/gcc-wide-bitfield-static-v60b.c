/* Static wide bitfield initializers retain the contiguous physical
 * layout. Expected octal words were generated with Python integers,
 * not by the compiler's runtime insertion or extraction paths.
 */
volatile unsigned fail_id;
static volatile union {
    struct { unsigned long long pad:12; signed long long field:52; } f;
    unsigned long w[2];
} u1 = { { 291UL, 320255973501901LL } };
static volatile union {
    struct { signed long long field:52; unsigned long long pad:12; } f;
    unsigned long w[2];
} u2 = { { -1876791358784075LL, 291UL } };
static volatile union {
    struct { unsigned long long pad:11; signed long long field:53; } f;
    unsigned long w[2];
} u3 = { { 291UL, -1818956999141768LL } };
static volatile union {
    struct { signed long long field:53; unsigned long long pad:11; } f;
    unsigned long w[2];
} u4 = { { 562945658454016LL, 291UL } };
static volatile union {
    struct { unsigned long long pad:1; signed long long field:71; } f;
    unsigned long w[2];
} u5 = { { 1UL, -590295810358705651695LL } };
static volatile union {
    struct { signed long long field:37; unsigned long long pad:35; } f;
    unsigned long w[2];
} u6 = { { -34359738368LL, 291UL } };
int main(void)
{
    fail_id = 1;
    if (u1.w[0]!=0044304432126UL || u1.w[1]!=0361152746400UL) return 1;
    fail_id = 2;
    if (u2.w[0]!=0452504272675UL || u2.w[1]!=0773324221400UL) return 1;
    fail_id = 3;
    if (u3.w[0]!=0110746115261UL || u3.w[1]!=0106425474000UL) return 1;
    fail_id = 4;
    if (u4.w[0]!=0037777700000UL || u4.w[1]!=0000000221400UL) return 1;
    fail_id = 5;
    if (u5.w[0]!=0700000000000UL || u5.w[1]!=0000000000021UL) return 1;
    fail_id = 6;
    if (u6.w[0]!=0600000000000UL || u6.w[1]!=0000000000443UL) return 1;
    fail_id = 0;
    return 0;
}
