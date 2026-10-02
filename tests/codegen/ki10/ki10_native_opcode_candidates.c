/* codegen-policy: -march=ki10 may emit KI10 native instructions where legal, but must keep ABI layout compatible with V1A ADDR18. */
volatile int __test_exit;
volatile int fail_id;
struct d { double x; double y; } gd;
int main()
{
    gd.x = 4.0;
    gd.y = 5.0;
    return gd.x < gd.y ? 0 : 1;
}
