#include <stdio.h>

int
main(int argc, char **argv)
{
    FILE *in;
    FILE *out;
    int ch;

    if (argc != 3) {
        fprintf(stderr, "usage: mkutf9 input output\n");
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
    while ((ch = fgetc(in)) != EOF) {
        if (ch != '\n' && ch != '\r')
            ch |= 0200;
        if (fputc(ch, out) == EOF) {
            perror(argv[2]);
            return 1;
        }
    }
    if (ferror(in)) {
        perror(argv[1]);
        return 1;
    }
    if (fclose(out) != 0) {
        perror(argv[2]);
        return 1;
    }
    fclose(in);
    return 0;
}
