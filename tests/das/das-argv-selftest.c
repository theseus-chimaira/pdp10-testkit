#define DAS_ARGV_SELFTEST 1
#define DAS_NO_MAIN 1
#include "das.c"

static das_word_t
pack6(const char *s)
{
    das_word_t word;
    unsigned int i;
    unsigned int ch;

    word = DAS_W(0);
    for (i = 0U; i < 6U; i++) {
        ch = s[i] == 0 ? 0U : (unsigned int)(unsigned char)s[i] - 040U;
        word = (word << 6) | (das_word_t)(ch & 077U);
    }
    return word;
}

int
main(void)
{
    das_word_t arg[4];
    char text[20];

    arg[0] = DAS_W(2);
    arg[1] = pack6("-F    ");
    if (das_counted_sixbit_arg_text(arg, text, sizeof(text)) != 0)
        return 1;
    if (strcmp(text, "-F") != 0)
        return 2;

    arg[0] = DAS_W(12);
    arg[1] = pack6("/TXT/I");
    arg[2] = pack6("NPUT.S");
    if (das_counted_sixbit_arg_text(arg, text, sizeof(text)) != 0)
        return 3;
    if (strcmp(text, "/TXT/INPUT.S") != 0)
        return 4;

    arg[0] = DAS_W(20);
    if (das_counted_sixbit_arg_text(arg, text, sizeof(text)) == 0)
        return 5;
    return 0;
}
