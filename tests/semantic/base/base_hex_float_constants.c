volatile int __test_exit;
volatile int fail_id;
volatile double gotd;
volatile float gotf;

int main(void)
{
    fail_id = 0;
    gotd = 0x1.8p+2;
    if (gotd != 6.0) { fail_id = 1; return 1; }
    gotd = 0X.8P-1;
    if (gotd != 0.25) { fail_id = 2; return 1; }
    gotd = 0x1.ap+1L;
    if (gotd != 3.25) { fail_id = 3; return 1; }
    gotf = 0x1p+3F;
    if (gotf != 8.0F) { fail_id = 4; return 1; }
    gotd = 0x1p-4;
    if (gotd != 0.0625) { fail_id = 5; return 1; }
    gotd = 0x0p+9999;
    if (gotd != 0.0) { fail_id = 6; return 1; }
    return 0;
}
