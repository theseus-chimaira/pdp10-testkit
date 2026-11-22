/*
 * Keep a self-loop label live when an earlier unreachable entry is removed.
 *
 * The GCC PDP-10 backend used to delete both labels when optimizing the
 * untaken branch to the infinite loop, emitting an undefined %L15 on -O2
 * and -Os.  The test never enters the infinite loop at run time.
 */
static char *
skip_field(int tab, char *ptr, char *lim, int words, int chars)
{
    if (tab) {
        while (ptr < lim && words--) {
            while (ptr < lim && *ptr != tab)
                ++ptr;
            if (ptr < lim)
                ++ptr;
        }
    } else {
        for (;;) { }
    }
    if (ptr + chars <= lim)
        ptr += chars;
    return ptr;
}

int
main(void)
{
    char s[] = ":ab";
    return skip_field(':', s, s + 3, 1, 1) == s + 2 ? 0 : 1;
}
