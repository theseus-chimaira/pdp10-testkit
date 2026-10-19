/* PDP-6 GCC -O1 ADDRESSOF ICE reproducer, C89 (2026-10-19).
 * GCC 3.2 can turn a pseudo-register into SUBREG/ZERO_EXTRACT/MEM for
 * a 9-bit local slot, then abort while purging ADDRESSOF. Keep this
 * source intact until the compiler fix is independently verified.
 */
extern char *strstr(const char *, const char *);
extern char *strpbrk(const char *, const char *);
extern unsigned int strspn(const char *, const char *);

int semantic_fail_id;
char *search_observed_ptr;
char *search_expected_ptr;
static char overlap1[] = "aababa";
static char overlap2[] = "ababababx";
static char hello[6];

static int
check_strstr(void)
{
    char empty[1];
    char text[96];
    char needle[12];
    int off;
    int i;

    empty[0] = 0;
    if (strstr(empty, empty) != empty)
        return 101;
    if (strstr(empty, "a") != 0)
        return 102;
    if (strstr("abc", "abcd") != 0)
        return 103;
    if (strstr("aaaaaa", "ba") != 0)
        return 104;
    search_observed_ptr = strstr(overlap1, "aba");
    search_expected_ptr = overlap1 + 1;
    if (search_observed_ptr != search_expected_ptr)
        return 105;
    search_observed_ptr = strstr(overlap2, "ababx");
    search_expected_ptr = overlap2 + 4;
    if (search_observed_ptr != search_expected_ptr)
        return 106;

    for (off = 0; off != 12; ++off) {
        for (i = 0; i != 80; ++i)
            text[i] = 'a';
        text[80] = 0;
        text[off + 23] = 'z';
        needle[0] = 'a';
        needle[1] = 'a';
        needle[2] = 'z';
        needle[3] = 0;
        if (strstr(text + off, needle) != text + off + 21)
            return 110 + off;
        if (strstr(text + off, "z") != text + off + 23)
            return 130 + off;
        if (strstr(text + off, empty) != text + off)
            return 150 + off;
    }
    return 0;
}

int main(void) { return check_strstr(); }
