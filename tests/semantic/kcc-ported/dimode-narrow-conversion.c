/* Preserved regression source from dimode-narrow-conversion.sh. */
volatile int __test_exit;
typedef signed _KCCtype_char6 s6;
typedef unsigned _KCCtype_char6 u6;
int f(long long x) { return (int)x; }
unsigned int g(unsigned long long x) { return (unsigned int)x; }
int h(long long x) { return (s6)x; }
int i(unsigned long long x) { return (u6)x; }
int main(void)
{
    if (f((long long)-1234567) != -1234567) return 1;
    if (g((unsigned long long)07654321U) != 07654321U) return 2;
    if (h((long long)-041) != 037) return 3;
    if (i((unsigned long long)0100) != 0) return 4;
    return 0;
}
