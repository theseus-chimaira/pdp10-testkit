/* codegen-policy: -march=base must not emit DMOVE, DMOVEM, DMOVN, DMOVNM, DFAD, DFSB, DFMP, DFDV, FIX, FIXR, or FLTR. */
volatile int __test_exit;
volatile int fail_id;
struct pair { double a; double b; } gp;
int main()
{
    gp.a = 1.0;
    gp.b = 2.0;
    return gp.a < gp.b ? 0 : 1;
}
