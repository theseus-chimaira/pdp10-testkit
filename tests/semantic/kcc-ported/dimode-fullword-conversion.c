/* Original portable 72-to-36-bit conversion regression. */
volatile int __test_exit;
unsigned int u(unsigned long long x) { return (unsigned int)x; }
int s(long long x) { return (int)x; }
int main(void)
{
    unsigned long long a;
    long long b;
    a = (unsigned long long)1 << 35;
    if (u(a) != 0400000000000U) return 1;
    a = (unsigned long long)1 << 36;
    if (u(a) != 0U) return 2;
    b = (long long)1 << 35;
    if (s(b) != (int)0400000000000U) return 3;
    b = -1;
    if (s(b) != -1) return 4;
    return 0;
}
