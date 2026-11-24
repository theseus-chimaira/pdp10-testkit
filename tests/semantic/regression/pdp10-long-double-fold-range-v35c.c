/* Adapted from GCC torture-execute 960405-1.c for native PDP-10.
 * X = 2^126 - 2^99, exactly representable with 27 fraction bits.
 * Twice X = 2^127 - 2^100, within the native exponent range.
 * Using the common 27-bit subset also avoids host-literal rounding
 * differences in software double precision on PDP-6 and KA10.
 * Preserve the original static addition/multiplication comparison.
 */
#define X 85070591096409315751728951109590450176.0L
#define EXPECTED 170141182192818631503457902219180900352.0L

long double x = X + X;
long double y = 2.0L * X;

int main(void)
{
    if (x != y)
        return 1;
    if (x != EXPECTED || y != EXPECTED)
        return 2;
    if (x <= X)
        return 3;
    return 0;
}
