/* GCC complex array and conjugation regression: 20020411-1.c.
 * Exercise complex-float array element, conjugation and conversion
 * to complex-double return. No hosted printf or test-only math shim.
 */

volatile unsigned int fail_id;
extern void abort(void);

static __complex__ float
conjugate_v1(void)
{
    __complex__ float parts[1];
    __real__ parts[0] = 1.0F;
    __imag__ parts[0] = 1.0F;
    parts[0] = __builtin_conjf(parts[0]);
    return parts[0];
}

int
main(void)
{
    __complex__ double result[1];
    result[0] = conjugate_v1();
    if (__real__ result[0] != 1.0) {
        fail_id = 1;
        abort();
    }
    if (__imag__ result[0] != -1.0) {
        fail_id = 2;
        abort();
    }
    return 0;
}
