/* Pointer constants preserve the entire raw target word, including bit 35. */
#define RAW 0601100001234U
static volatile unsigned long long w = (unsigned long long)(char *)RAW;
static volatile long long s = (long long)(char *)RAW;
static char *volatile p = (char *)((1ULL << 45) | RAW);
static volatile unsigned long long zero = (unsigned long long)(int *)0;
int main(void)
{
    if (w != (unsigned long long)RAW) return 1;
    if (s != (long long)RAW) return 2;
    if ((unsigned int)p != RAW) return 3;
    if (zero != 0) return 4;
    return 0;
}
