/* Wide literal type, concatenation, full word escapes, and initializers. */
#include <stddef.h>
static wchar_t a[] = "a" L"\x123456789" "\0b";
static wchar_t b[2] = L"xy";
static wchar_t z[5] = L"z";
static const wchar_t *p = L"A" "B";
static unsigned char n[] = "\377\x1ff";
static const wchar_t *q = L"\u03a9\U0001f600";
static struct S { int v; wchar_t w[3]; } g = { 7, L"ok" };
int main(void)
{
    wchar_t local[4] = L"ab";
    wchar_t (*whole)[3] = &L"ab";
    int k = 2;
    struct S s = { k, L"cd" };
    if (sizeof(wchar_t) != sizeof(int) || sizeof L'a' != sizeof(wchar_t)) return 1;
    if (sizeof(L"a" "b") != 3 * sizeof(wchar_t)) return 2;
    if (sizeof("a" L"b") != 3 * sizeof(wchar_t)) return 3;
    if (L"a" "b"[1] != L'b' || "a" L"b"[1] != L'b') return 4;
    if (sizeof a != 5 * sizeof(wchar_t) || a[0] != 'a' || a[1] != L'\x123456789' || a[2] || a[3] != 'b' || a[4]) return 5;
    if (b[0] != 'x' || b[1] != 'y' || z[0] != 'z' || z[4]) return 6;
    if (p[0] != 'A' || p[1] != 'B' || p[2] || p+2-p != 2) return 7;
    if (local[0] != 'a' || local[1] != 'b' || local[2] || local[3]) return 8;
    if ((*whole)[1] != 'b' || (*whole)[2]) return 9;
    if (n[0] != 0377 || n[1] != 0777 || n[2]) return 10;
    if (L'\u03a9' != 0x3a9 || q[0] != 0x3a9 || q[1] != 0x1f600 || q[2]) return 11;
    if (g.v != 7 || g.w[1] != 'k' || s.v != 2 || s.w[1] != 'd' || s.w[2]) return 12;
    if (L"\x800000001"[0] != L'\x800000001') return 13;
    if ("\x1ff" L"a"[0] != 0777) return 14;
    return 0;
}
