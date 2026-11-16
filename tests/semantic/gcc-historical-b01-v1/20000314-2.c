/* GCC execute/20000314-2.c: wide constant materialization. */
/* PDP-10: long long is wider than 36 bits; sizeof is NOT bit count. */
typedef unsigned long long wide_t;
static const wide_t bigconst = 1ULL << 34;
static volatile int enabled = 1;
static wide_t getmask(void)
{
    if (enabled)
        return bigconst;
    return 0;
}
int main(void)
{
    if (getmask() != bigconst)
        return 1;
    enabled = 0;
    if (getmask() != 0)
        return 2;
    return 0;
}
