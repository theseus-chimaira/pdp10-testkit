/* PDP-6 bare-metal freestanding search-library regression, C89.
 * Execute with both KCC and GCC and compare actual byte-pointer results.
 * The loops cross 36-bit word boundaries and use nonzero 9-bit bytes.
 * Do not replace library calls with private test implementations.
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

static int
check_strpbrk(void)
{
    char text[80];
    char set[8];
    int off;
    int i;

    /* Initialize every target byte through stores.  The separate GCC
     * section-emission regression covers packed initializers spanning
     * the .data/.text transition; this tests the search ABI itself. */
    hello[0] = 'h';
    hello[1] = 'e';
    hello[2] = 'l';
    hello[3] = 'l';
    hello[4] = 'o';
    hello[5] = 0;

    if (strpbrk("", "x") != 0)
        return 201;
    if (strpbrk("xyz", "") != 0)
        return 202;
    if (strpbrk("aaa", "z") != 0)
        return 203;
    if (strpbrk(hello, "l") != hello + 2)
        return 204;
    search_observed_ptr = strpbrk(hello, "zyo");
    search_expected_ptr = hello + 4;
    if (search_observed_ptr != search_expected_ptr)
        return 205;

    set[0] = 0377;
    set[1] = 0;
    for (off = 0; off != 12; ++off) {
        for (i = 0; i != 72; ++i)
            text[i] = 'a';
        text[72] = 0;
        text[off + 21] = 0377;
        if (strpbrk(text + off, set) != text + off + 21)
            return 210 + off;
        if (strpbrk(text + off, "z") != 0)
            return 230 + off;
    }
    return 0;
}

static int
check_strspn(void)
{
    char text[80];
    char set[8];
    int off;
    int i;

    if (strspn("", "a") != 0U)
        return 301;
    if (strspn("aaa", "") != 0U)
        return 302;
    if (strspn("ababababx", "ab") != 8U)
        return 303;
    if (strspn("abc", "cbaxyz") != 3U)
        return 304;
    if (strspn("xyz", "zyx") != 3U)
        return 305;

    set[0] = 'a';
    set[1] = 0377;
    set[2] = 0;
    for (off = 0; off != 12; ++off) {
        for (i = 0; i != 72; ++i)
            text[i] = 'a';
        text[72] = 0;
        text[off + 21] = 0377;
        text[off + 24] = 'z';
        if (strspn(text + off, set) != 24U)
            return 310 + off;
        if (strspn(text + off, "a") != 21U)
            return 330 + off;
    }
    return 0;
}

int
main(void)
{
    int result;

    semantic_fail_id = 0;
    result = check_strstr();
    if (result == 0)
        result = check_strpbrk();
    if (result == 0)
        result = check_strspn();
    semantic_fail_id = result;
    return result != 0;
}
