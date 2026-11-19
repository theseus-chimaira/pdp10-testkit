/* Preserve the signbit(double) GNU local designated union form of
 * upstream 991228-1.c that ICEs at GCC PDP-6 O0.
 * Unlike the original target-guarded test, always call signbit on
 * both polarities and check the native DEC D-format most-significant
 * word. GCC ICE evidence remains a compiler-fix gate, not a test PASS.
 */
extern void abort(void);
volatile unsigned int fail_id;
static volatile double input_v1;

static int
native_signbit_v1(double x)
{
    __extension__ union {
        double d;
        int words[2];
    } bits = { d: x };
    return bits.words[0] < 0;
}

int
main(void)
{
    input_v1 = -0.25;
    if (!native_signbit_v1(input_v1)) {
        fail_id = 1;
        abort();
    }
    input_v1 = 0.25;
    if (native_signbit_v1(input_v1)) {
        fail_id = 2;
        abort();
    }
    return 0;
}
