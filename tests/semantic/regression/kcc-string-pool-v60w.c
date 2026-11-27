/* Repeated encodings must fit without increasing the literal pool. */
#define A "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define B A,A,A,A,A,A,A,A
#define C B,B,B,B,B,B,B,B
#define D C,C,C,C,C,C,C,C
static char *a[] = { D };
static char *b[] = { "prefix", "fix", "a\0b", "a\0c", "\777", "\377",
                     "abc" "def", "abcdef", "", "" };
static int w[][4] = { L"abc", L"abc", L"\x12345", L"\x12345" };
int main(void)
{
    int i;
    for (i = 0; i < (int)(sizeof(a) / sizeof(a[0])); ++i)
        if (a[i][0] != '0' || a[i][61] != 'Z' || a[i][62] != 0)
            return 1;
    if (b[0][0] != 'p' || b[1][0] != 'f'
        || b[2][2] != 'b' || b[3][2] != 'c') return 2;
    if ((unsigned char)b[4][0] != 0777 || (unsigned char)b[5][0] != 0377)
        return 3;
    if (b[6][5] != 'f' || b[7][6] || b[8][0] || b[9][0])
        return 4;
    if (w[0][2] != 'c' || w[1][3] || w[2][0] != 0x12345
        || w[3][1]) return 5;
    return 0;
}
