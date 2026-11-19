/* A nonvacuous DEC D-format regression for GNU 991228-1.c.
 * Exercise GNU designated union initialization with a negative DEC
 * native double. Do not skip the sign test when integer words are
 * non-IEEE or the word ordering differs from a host little-endian.
 */
extern void abort(void);
#define SIGN_V1 0400000000000UL
__extension__ union {
    double d;
    unsigned int words[2];
} negative_v1 = { d: -0.25 };
volatile unsigned int fail_id;

int
main(void)
{
    if (sizeof(double) != 2U * sizeof(unsigned int)) {
        fail_id = 1;
        abort();
    }
    if (!(negative_v1.words[0] & SIGN_V1)) {
        fail_id = 2;
        abort();
    }
    if (!(negative_v1.words[1] & SIGN_V1)) {
        fail_id = 3;
        abort();
    }
    if (negative_v1.d != -0.25) {
        fail_id = 4;
        abort();
    }
    negative_v1.d = 0.25;
    if ((negative_v1.words[0] & SIGN_V1) ||
        (negative_v1.words[1] & SIGN_V1)) {
        fail_id = 5;
        abort();
    }
    return 0;
}
