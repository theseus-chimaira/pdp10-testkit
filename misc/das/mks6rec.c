#include <stdio.h>
#include <stdlib.h>

#define WORD_MASK 0777777777777ULL
#define LINE_MAX 255
#define S6REC_TEXT (1ULL << 30)

static void
write_word(FILE *f, unsigned long long word)
{
    unsigned int i;

    word &= WORD_MASK;
    for (i = 0U; i < 8U; i++) {
        if (fputc((int)(word & 0377ULL), f) == EOF) {
            perror("mks6rec");
            exit(1);
        }
        word >>= 8;
    }
}

static void
write_record(FILE *out, const char *line, unsigned int len)
{
    unsigned int i;
    unsigned int slot;
    unsigned int ch;
    unsigned long long word;

    write_word(out, S6REC_TEXT | (unsigned long long)len);
    word = 0ULL;
    slot = 0U;
    for (i = 0U; i < len; i++) {
        ch = (unsigned int)(unsigned char)line[i];
        if (ch < 040U || ch > 0137U) {
            fprintf(stderr, "mks6rec: character outside SIXBIT range\n");
            exit(1);
        }
        word |= (unsigned long long)(ch - 040U) << (30U - 6U * slot);
        slot++;
        if (slot == 6U) {
            write_word(out, word);
            word = 0ULL;
            slot = 0U;
        }
    }
    if (slot != 0U)
        write_word(out, word);
}

int
main(int argc, char **argv)
{
    FILE *in;
    FILE *out;
    char line[LINE_MAX + 1];
    unsigned int len;
    int ch;

    if (argc != 3) {
        fprintf(stderr, "usage: mks6rec input output\n");
        return 1;
    }
    in = fopen(argv[1], "rb");
    if (in == NULL) {
        perror(argv[1]);
        return 1;
    }
    out = fopen(argv[2], "wb");
    if (out == NULL) {
        perror(argv[2]);
        fclose(in);
        return 1;
    }
    len = 0U;
    for (;;) {
        ch = fgetc(in);
        if (ch == EOF) {
            if (ferror(in)) {
                perror(argv[1]);
                return 1;
            }
            if (len != 0U)
                write_record(out, line, len);
            break;
        }
        ch &= 0177;
        if (ch == '\r')
            continue;
        if (ch == '\n') {
            write_record(out, line, len);
            len = 0U;
            continue;
        }
        if (len >= LINE_MAX) {
            fprintf(stderr, "mks6rec: input line too long\n");
            return 1;
        }
        line[len++] = (char)ch;
    }
    if (fclose(out) != 0) {
        perror(argv[2]);
        return 1;
    }
    fclose(in);
    return 0;
}
