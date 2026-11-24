/* GNU extension checks: type/expression alignment without evaluation,
 * and void pointer arithmetic in addressable C byte units. */
int main(void)
{
    unsigned char a[12];
    void *p = a + 5;
    void *q = a + 2;
    int i = 0;
    int n = 3;
    if (__alignof__(char) != 1 || __alignof__(int) != sizeof(int))
        return 1;
    if (__alignof__(i++) != __alignof__(int) || i != 0)
        return 2;
    if (__alignof__ i != __alignof(int) || __alignof__(void) != 1)
        return 3;
    if (p - q != 3 || (unsigned char *)(p - 3) != a + 2)
        return 4;
    p += n;
    if (p != a + 8)
        return 5;
    if ((unsigned char *)p-- != a + 8 || p != a + 7)
        return 6;
    if ((unsigned char *)++p != a + 8)
        return 7;
    p -= 6;
    if (p != q)
        return 8;
    return 0;
}
