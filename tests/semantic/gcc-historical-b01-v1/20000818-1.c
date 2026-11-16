/* GCC execute/20000818-1.c: lexer loop termination. */
static void *temporary_obstack;
static int input(void) { return 0; }
static int isalnum_test(int ch)
{
    return (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') ||
           (ch >= '0' && ch <= '0');
}
static void grow(void **ptr, int ch)
{
    (void)ptr;
    (void)ch;
}
static int yylex(void)
{
    int ch;
    for (;;) {
        ch = input();
        if (isalnum_test(ch))
            grow(&temporary_obstack, ch);
        else if (ch != '_')
            break;
    }
    return ch;
}
int main(void)
{
    return yylex() != 0;
}
