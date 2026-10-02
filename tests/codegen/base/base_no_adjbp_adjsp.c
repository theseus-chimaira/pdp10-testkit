/* codegen-policy: -march=base must not emit ADJBP or ADJSP; byte-pointer adjustment and stack adjustment must use portable sequences. */
volatile int __test_exit;
volatile int fail_id;
char gc[32];
int main()
{
    char *p;
    p = &gc[20];
    p -= 7;
    p += 3;
    return (p == &gc[16]) ? 0 : 1;
}
