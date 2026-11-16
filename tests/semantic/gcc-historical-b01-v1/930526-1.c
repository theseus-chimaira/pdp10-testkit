/* GCC execute/930526-1.c: inlined pointer arrays into stack storage. */
static inline int f(int x)
{
    int *p[25];
    int m[25 * 7];
    int i;
    for (i = 0; i < 25; ++i)
        p[i] = m + x * i;
    p[1][0] = x;
    return p[1][0];
}
int main(void)
{
    return f(7) != 7;
}
