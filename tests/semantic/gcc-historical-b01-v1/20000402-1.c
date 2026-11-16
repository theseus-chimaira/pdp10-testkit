/* GCC execute/20000402-1.c: wide unsigned division (constant/local). */
/* PDP-10 native GCC: unsigned long long holds the 0x1400000000 value. */
static volatile unsigned long long runtime_a = 0x1400000000ULL;
static volatile unsigned long long runtime_b = 0x80000000ULL;
int main(void)
{
    const unsigned long long a = 0x1400000000ULL;
    const unsigned long long b = 0x80000000ULL;
    const unsigned long long quotient = a / b;
    if (quotient != 40ULL)
        return 1;
    if ((0x1400000000ULL / 0x80000000ULL) != 40ULL)
        return 2;
    if (runtime_a / runtime_b != 40ULL)
        return 3;
    return 0;
}
