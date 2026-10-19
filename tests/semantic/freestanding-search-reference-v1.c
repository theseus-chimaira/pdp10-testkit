/* Comparison baseline for the PDP-6 assembler search routines (C89).
 * Link this instead of the assembler, never alongside it. This is not
 * production libc and is not compiled into libp10c-v2.a.
 */
char *
strstr(const char *text, const char *pattern)
{
    const char *a;
    const char *b;
    const char *candidate;

    if (*pattern == 0)
        return (char *)text;
    while (*text != 0) {
        candidate = text;
        a = text;
        b = pattern;
        while (*b != 0 && *a != 0 && *a == *b) {
            ++a;
            ++b;
        }
        if (*b == 0)
            return (char *)candidate;
        ++text;
    }
    return 0;
}

char *
strpbrk(const char *text, const char *accept)
{
    const char *p;

    while (*text != 0) {
        for (p = accept; *p != 0; ++p)
            if (*text == *p)
                return (char *)text;
        ++text;
    }
    return 0;
}

unsigned int
strspn(const char *text, const char *accept)
{
    const char *p;
    unsigned int count;

    count = 0;
    while (*text != 0) {
        for (p = accept; *p != 0; ++p)
            if (*text == *p)
                break;
        if (*p == 0)
            break;
        ++text;
        ++count;
    }
    return count;
}
