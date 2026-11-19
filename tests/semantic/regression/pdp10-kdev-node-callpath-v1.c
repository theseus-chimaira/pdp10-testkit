/* Source-faithful defined subset of 980526-2.c: native device major /
 * minor encoding and a real mknod argument callback. Undefined pointer
 * arithmetic in historical getname() is intentionally excluded; the
 * callback checks the exact original filename, mode and encoded dev.
 * No Linux mknod filesystem or fake target OS is installed.
 */
extern void abort(void);
static volatile unsigned int callback_count_v1;
static volatile unsigned int observed_mode_v1;
static volatile unsigned int observed_dev_v1;
static const char *observed_filename_v1;
volatile unsigned int fail_id;

static unsigned int
encode_v1(unsigned int value)
{
    unsigned int major = value >> 8;
    unsigned int minor = value & 255U;
    return (major << 22) | minor;
}

static void
mknod_v1(const char *filename, unsigned int mode, unsigned int dev)
{
    callback_count_v1++;
    observed_filename_v1 = filename;
    observed_mode_v1 = mode;
    observed_dev_v1 = dev;
}

static int
sys_mknod_v1(const char *filename, unsigned int mode,
             unsigned int dev)
{
    mknod_v1(filename, mode, encode_v1(dev));
    return 0;
}

int
main(void)
{
    static const char name_v1[] = "test";
    static volatile unsigned int input_v1;
    callback_count_v1 = 0;
    input_v1 = 0x12345678U;
    if (sys_mknod_v1(name_v1, 1U, input_v1) != 0) {
        fail_id = 1;
        abort();
    }
    if (callback_count_v1 != 1U) {
        fail_id = 2;
        abort();
    }
    if (observed_filename_v1 != name_v1 ||
        observed_filename_v1[0] != 't' ||
        observed_filename_v1[3] != 't' ||
        observed_filename_v1[4] != 0) {
        fail_id = 3;
        abort();
    }
    if (observed_mode_v1 != 1U || observed_dev_v1 != 0xd15800078U) {
        fail_id = 4;
        abort();
    }
    return 0;
}
