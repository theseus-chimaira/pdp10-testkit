/* Native pointer differences are in elements, not encoded P/S words.
** Static initializers and independent runtime pointer arithmetic agree.
*/
struct item {
    int word;
    char a, b;
    short h;
    int end;
};
struct nested {
    int first;
    struct item inner;
    int last;
};
static struct item obj;
static struct nested nest;
static int words[8];
static char bytes[12];
static int matrix[2][3];
static struct { char a, b, f[3]; } with_array;
static volatile int offsets[] = {
    (char *)&obj.a - (char *)&obj,
    (char *)&obj.b - (char *)&obj,
    (char *)&obj.h - (char *)&obj,
    (char *)&obj.end - (char *)&obj,
    (char *)&nest.inner.b - (char *)&nest,
    (char *)&((struct item *)0)->h - (char *)0,
    (char *)&((struct nested *)0)->inner.b - (char *)0,
    &words[5] - &words[2],
    (bytes + 7) - (bytes + 2),
    &matrix[1] - &matrix[0],
    (char *)&obj.a - (char *)&obj.b,
    with_array.f - &with_array.b
};

static int char_diff(char *a, char *b)
{
    return a - b;
}
static int int_diff(int *a, int *b)
{
    return a - b;
}

int main(void)
{
    if (offsets[0] != 4 || offsets[1] != 5 ||
        offsets[2] != 6 || offsets[3] != 8) return 1;
    if (offsets[4] != 9 || offsets[5] != 6 ||
        offsets[6] != 9) return 2;
    if (offsets[7] != 3 || offsets[8] != 5 ||
        offsets[9] != 1 || offsets[10] != -1 || offsets[11] != 3) return 3;
    if (char_diff((char *)&obj.h, (char *)&obj) != offsets[2] ||
        char_diff((char *)&nest.inner.b, (char *)&nest) != offsets[4])
        return 4;
    if (int_diff(&words[5], &words[2]) != offsets[7] ||
        char_diff(bytes + 7, bytes + 2) != offsets[8] ||
        char_diff(with_array.f, &with_array.b) != offsets[11])
        return 5;
    return 0;
}
