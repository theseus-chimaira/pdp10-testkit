/* Both words of a 71-bit integer participate in scalar truth. */
static volatile unsigned long long value;
static int truth(unsigned long long x) { return x ? 1 : 0; }
static int negate(unsigned long long x) { return !x; }
int main(void)
{
    value = 1ULL;
    if (!value || !truth(value) || negate(value)) return 1;
    value = 1ULL << 35;
    if (!value || !truth(value) || negate(value)) return 2;
    value = 0;
    if (value || truth(value) || !negate(value)) return 3;
    if (!(1ULL << 35) || !(1ULL << 32)) return 4;
    if (!((1ULL << 35) && 1) || !((1ULL << 32) || 0)) return 5;
    return 0;
}
