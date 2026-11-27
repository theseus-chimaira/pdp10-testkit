/* Pointer conversions preserve the raw unsigned 36-bit pointer word. */
static int a[3] = { 11, 22, 33 };
static char b[] = "abcdef";
static int calls;
static int *get(void) { ++calls; return a + 1; }
int main(void)
{
    volatile unsigned long long w;
    volatile long long s;
    volatile unsigned int raw;
    int *p = get();
    char *q = b + 3;
    w = (unsigned long long)p;
    if (w != (unsigned int)p || (int *)w != p || *(int *)w != 22)
        return 1;
    raw = (unsigned int)q;
    w = (unsigned long long)q;
    if (w != (unsigned long long)raw || (char *)w != q)
        return 2;
    s = (long long)q;
    if (s != (long long)raw || (char *)s != q || *(char *)s != 'd')
        return 3;
    w = (1ULL << 45) | raw;
    if ((char *)w != q) return 4;
    if ((unsigned char)q != (unsigned char)raw) return 5;
    return calls != 1;
}
