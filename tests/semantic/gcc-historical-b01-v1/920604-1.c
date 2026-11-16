/* GCC execute/920604-1.c: wide signed remainder code generation. */
static long long mod(long long a, long long b)
{
    return a % b;
}
int main(void)
{
    if (mod(1LL, 2LL) != 1LL)
        return 1;
    if (mod((1LL << 40) + 1LL, (1LL << 40)) != 1LL)
        return 2;
    return 0;
}
