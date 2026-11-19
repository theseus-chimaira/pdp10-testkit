/* PDP-10 target-width companion to upstream GCC 980526-2.c.
 * The original Linux 32-bit major<<22 constant cannot be used as the
 * expected value on a 36-bit unsigned int target. Its signed shift
 * and arbitrary integer-to-pointer conversion are not test oracles.
 * Compare independently computed modulo-2^36 device encodings using
 * unsigned arithmetic, preserving the original major/minor split.
 */

static volatile unsigned int device_v1;
volatile unsigned int fail_id;
extern void abort(void);

static unsigned int
encode_v1(unsigned int device)
{
    unsigned int major;
    unsigned int minor;

    major = device >> 8;
    minor = device & 0377U;
    return (major << 22) | minor;
}

static void
check_v1(unsigned int device, unsigned int expected, unsigned int number)
{
    device_v1 = device;
    if (encode_v1(device_v1) != expected) {
        fail_id = number;
        abort();
    }
}

int
main(void)
{
    check_v1(0x00000000U, 0x000000000U, 1);
    check_v1(0x00000001U, 0x000000001U, 2);
    check_v1(0x000000ffU, 0x0000000ffU, 3);
    check_v1(0x00000100U, 0x000400000U, 4);
    check_v1(0x0000ffffU, 0x03fc000ffU, 5);
    check_v1(0x12345678U, 0x0d15800078U, 6);
    check_v1(0xffffffffU, 0x0fffc000ffU, 7);
    check_v1(0xabcdef00U, 0x037bc00000U, 8);
    check_v1(0x80000000U, 0x000000000U, 9);
    check_v1(0x3fffffffU, 0x0fffc000ffU, 10);
    return 0;
}
