/* codegen-policy: -march=base must not emit KL/XKL extended-addressing opcodes or section-number dependent code. */
volatile int __test_exit;
volatile int fail_id;
int ga[4];
int main()
{
    int *p;
    p = &ga[0];
    p[0] = 11;
    p[1] = p[0] + 5;
    return p[1] == 16 ? 0 : 1;
}
