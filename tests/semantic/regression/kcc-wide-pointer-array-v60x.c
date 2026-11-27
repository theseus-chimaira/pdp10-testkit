/* A wide literal in a pointer array contributes an address, not its data. */
static int *w[] = { L"abc", L"abc", L"\x12345", L"\x12345" };
static int *z[3] = { L"", L"XY" };
static int chars[4] = L"abc";
static struct S { int *p[2]; } s = {{ L"first", L"second" }};
int main(void)
{
    int *a[] = { L"auto", L"local" };
    if (w[0][2] != 'c' || w[1][3] || w[2][0] != 0x12345 || w[3][1])
        return 1;
    if (z[0][0] || z[1][1] != 'Y' || z[2]) return 2;
    if (chars[0] != 'a' || chars[3]) return 3;
    if (s.p[0][4] != 't' || s.p[1][5] != 'd') return 4;
    if (a[0][3] != 'o' || a[1][4] != 'l') return 5;
    return 0;
}
