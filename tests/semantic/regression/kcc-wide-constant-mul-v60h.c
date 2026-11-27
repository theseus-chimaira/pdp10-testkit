/* Compile-time products must agree with independent literal oracles.
 * Volatile objects prevent the runtime comparisons from being folded. */
typedef unsigned long long U;
typedef long long S;
static volatile S positive = 2863311530LL * 3;
static volatile S negative = -2863311530LL * 3;
static volatile U cross = (1ULL << 34) * (1ULL << 35);
static volatile U wrap = (~0ULL) * 3ULL;
static volatile U mixed = 34359738369ULL * 34359738369ULL;
static volatile U zero = (~0ULL) * 0ULL;
int main(void)
{
    if (positive != 8589934590LL || negative != -8589934590LL)
        return 1;
    if (cross != 590295810358705651712ULL)
        return 2;
    if (wrap != 2361183241434822606845ULL)
        return 3;
    if (mixed != 1180591620786130780161ULL)
        return 4;
    if (zero != 0ULL)
        return 5;
    return 0;
}
