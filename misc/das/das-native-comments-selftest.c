#define DAS_NATIVE 1
#define DAS_NATIVE_CORE_ONLY 1
#include "das.c"

struct test_input {
    const char *text;
    unsigned int pos;
};

static int test_get(void *arg, unsigned int *ch)
{
    struct test_input *in;

    in = (struct test_input *)arg;
    if (in->text[in->pos] == 0)
        return DAS_INPUT_EOF;
    *ch = (unsigned int)(unsigned char)in->text[in->pos++];
    return DAS_INPUT_OK;
}

static int same_text(const char *a, const char *b)
{
    while (*a != 0 && *a == *b) {
        a++;
        b++;
    }
    return *a == *b;
}

static int expect_line(struct das_char_reader *reader, const char *want)
{
    char line[96];

    if (das_read_line(reader, line, sizeof(line)) != DAS_INPUT_OK)
        return 1;
    return same_text(line, want) ? 0 : 1;
}

int main(void)
{
    static const char source[] =
        "MOVEI 1,1 /* trailing */\n"
        "MOVEI /* embedded */ 2,2\n"
        "ASCII \\\"A/*B\\\"\n"
        "ASCII \\\"A\\\\\\\"/*B\\\"\n"
        "/* multi-line begins\n"
        "continues */ JRST DONE\n"
        "A/B\n";
    static const char unterminated[] = "MOVEI 1,1 /* bad";
    struct test_input input;
    struct das_char_reader reader;
    char line[96];

    input.text = source;
    input.pos = 0U;
    reader.get = test_get;
    reader.arg = &input;
    reader.cstate = 0U;
    if (expect_line(&reader, "MOVEI 1,1  ") != 0)
        return 1;
    if (expect_line(&reader, "MOVEI   2,2") != 0)
        return 2;
    if (expect_line(&reader, "ASCII \\\"A/*B\\\"") != 0)
        return 3;
    if (expect_line(&reader, "ASCII \\\"A\\\\\\\"/*B\\\"") != 0)
        return 4;
    if (expect_line(&reader, " ") != 0)
        return 5;
    if (expect_line(&reader, " JRST DONE") != 0)
        return 6;
    if (expect_line(&reader, "A/B") != 0)
        return 7;
    if (das_read_line(&reader, line, sizeof(line)) != DAS_INPUT_EOF)
        return 8;
    if ((reader.cstate & DAS_CSTATE_COMMENT) != 0U)
        return 9;

    input.text = unterminated;
    input.pos = 0U;
    reader.cstate = 0U;
    if (expect_line(&reader, "MOVEI 1,1  ") != 0)
        return 10;
    if (das_read_line(&reader, line, sizeof(line)) != DAS_INPUT_EOF)
        return 11;
    if ((reader.cstate & DAS_CSTATE_COMMENT) == 0U)
        return 12;
    return 0;
}
