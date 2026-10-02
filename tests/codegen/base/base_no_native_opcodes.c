/* codegen-policy: base must not emit KI/KL native-only instructions such as DMOVE, DFAD, DFSB, DFMP, DFDV, FIX, FIXR, FLTR, ADJBP, ADJSP, or extended-addressing opcodes. */
volatile int __test_exit;
volatile int fail_id;
int a[4];
int main()
{
    a[0] = 1;
    a[1] = a[0] + 2;
    return a[1] == 3 ? 0 : 1;
}
