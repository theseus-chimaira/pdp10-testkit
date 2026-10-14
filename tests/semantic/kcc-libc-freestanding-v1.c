/* OS-independent KCC libc regression, PDP-6 compatible C99.
 * Test partial words, aligned words, overlap, and return values without
 * depending on DAIMOS kernel services or host-C byte width.
 */
#include <string.h>

extern void abort(void);

static unsigned char source[104], dest[104], other[104];

int main(void)
{
    unsigned int i;
    unsigned char overlap[96];
    char text[24];

    for (i = 0; i < 104; ++i) {
        source[i] = (unsigned char)(i + 129);
        dest[i] = 0;
        other[i] = (unsigned char)(i + 129);
    }
    if (memcpy(dest + 1, source + 2, 79) != dest + 1)
        abort();
    for (i = 0; i < 79; ++i)
        if (dest[i + 1] != source[i + 2]) abort();

    if (memset(dest + 3, 0377, 45) != dest + 3)
        abort();
    for (i = 3; i < 48; ++i)
        if (dest[i] != (unsigned char)0377) abort();
    if (memcmp(source, other, 104) != 0) abort();
    other[31]++;
    if (memcmp(source, other, 104) >= 0) abort();
    if (memcmp(other, source, 104) <= 0) abort();

    for (i = 0; i < 96; ++i) overlap[i] = (unsigned char)i;
    if (memmove(overlap + 5, overlap, 75) != overlap + 5) abort();
    for (i = 0; i < 75; ++i)
        if (overlap[i + 5] != (unsigned char)i) abort();
    if (memmove(overlap, overlap + 5, 75) != overlap) abort();
    for (i = 0; i < 75; ++i)
        if (overlap[i] != (unsigned char)i) abort();
    if (memmove(overlap, overlap, 75) != overlap) abort();

    if (strcpy(text, "abc") != text) abort();
    if (strlen(text) != 3) abort();
    if (strcmp(text, "abc") != 0) abort();
    if (strcmp(text, "abd") >= 0) abort();
    if (strcmp(text, "abb") <= 0) abort();
    if (strncmp(text, "abcX", 3) != 0) abort();
    if (strcat(text, "def") != text) abort();
    if (strcmp(text, "abcdef") != 0) abort();
    if (strchr(text, 'd') != text + 3) abort();
    if (strrchr(text, 'a') != text) abort();
    if (memcpy(dest, source, 0) != dest) abort();
    if (memset(dest, 0, 0) != dest) abort();

    /* Exercise every byte-pointer alignment, all small remainder counts,
     * and values whose upper 9-bit character bit is set. */
    {
        static const unsigned int fills[] = {0, 1, 0377, 0400, 0777};
        unsigned int offset, length, fill, j;
        for (offset = 0; offset < 4; ++offset)
            for (length = 0; length < 24; ++length)
                for (fill = 0; fill < 5; ++fill) {
                    for (j = 0; j < 48; ++j) dest[j] = 0123;
                    if (memset(dest + offset, fills[fill], length) !=
                        dest + offset) abort();
                    for (j = 0; j < 48; ++j) {
                        unsigned int expected =
                            (j >= offset && j < offset + length)
                            ? fills[fill] : 0123;
                        if (dest[j] != (unsigned char)expected) abort();
                    }
                }
    }
    return 0;
}
