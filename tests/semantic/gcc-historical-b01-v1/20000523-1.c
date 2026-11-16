/* GCC execute/20000523-1.c: nonzero high-shift division. */
/* Drop original sizeof(long long)<64 units guard: PDP-10 uses 9-bit bytes. */
int main(void)
{
    long long x;
    int n = 9;
    x = (((long long)n) << 55) / 0xff;
    if (x == 0)
        return 1;
    x = (((long long)9) << 55) / 0xff;
    if (x == 0)
        return 2;
    return 0;
}
