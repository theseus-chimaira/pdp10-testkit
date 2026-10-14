#define DAS_NATIVE 1
#define DAS_NATIVE_CORE_ONLY 1
#define DAS_NO_MAIN 1
#include "das.c"

struct mem_chars {
    const unsigned int *data;
    unsigned int count;
    unsigned int pos;
};

struct mem_words {
    const das_word_t *data;
    unsigned int count;
    unsigned int pos;
};

static int
mem_char_get(void *arg, unsigned int *ch)
{
    struct mem_chars *m;

    m = (struct mem_chars *)arg;
    if (m->pos >= m->count)
        return DAS_INPUT_EOF;
    *ch = m->data[m->pos++];
    return DAS_INPUT_OK;
}

static int
mem_word_get(void *arg, das_word_t *word)
{
    struct mem_words *m;

    m = (struct mem_words *)arg;
    if (m->pos >= m->count)
        return DAS_INPUT_EOF;
    *word = m->data[m->pos++];
    return DAS_INPUT_OK;
}

static int
same_string(const char *a, const char *b)
{
    while (*a != 0 && *a == *b) {
        a++;
        b++;
    }
    return *a == *b;
}

static int
test_utf9_mask(void)
{
    static const unsigned int input[] = {
        'M' | 0000U, 'O' | 0200U, 'V' | 0400U, 'E' | 0600U,
        'I' | 0000U, ' ' | 0200U, '1' | 0400U, ',' | 0600U,
        '7' | 0000U, '\n' | 0600U
    };
    struct mem_chars mem;
    struct das_char_reader reader;
    char line[32];
    int rc;

    mem.data = input;
    mem.count = (unsigned int)(sizeof(input) / sizeof(input[0]));
    mem.pos = 0U;
    reader.get = mem_char_get;
    reader.arg = &mem;
    rc = das_read_line(&reader, line, sizeof(line));
    if (rc != DAS_INPUT_OK)
        return 1;
    if (!same_string(line, "MOVEI 1,7"))
        return 2;
    if (das_read_line(&reader, line, sizeof(line)) != DAS_INPUT_EOF)
        return 3;
    return 0;
}

static int
test_s6rec(void)
{
    static const das_word_t input[] = {
        (1ULL << 30) | (03ULL << 24) | 9ULL,
        0555766455100ULL,
        0211427000000ULL,
        (1ULL << 30) | 4ULL,
        0526263640000ULL,
        (1ULL << 30)
    };
    struct mem_words mem;
    struct das_s6reader s6;
    struct das_char_reader reader;
    char line[32];
    int rc;

    mem.data = input;
    mem.count = (unsigned int)(sizeof(input) / sizeof(input[0]));
    mem.pos = 0U;
    das_s6_init(&s6, mem_word_get, &mem);
    reader.get = das_s6_get;
    reader.arg = &s6;
    rc = das_read_line(&reader, line, sizeof(line));
    if (rc != DAS_INPUT_OK || !same_string(line, "MOVEI 1,7"))
        return 10;
    rc = das_read_line(&reader, line, sizeof(line));
    if (rc != DAS_INPUT_OK || !same_string(line, "JRST"))
        return 11;
    rc = das_read_line(&reader, line, sizeof(line));
    if (rc != DAS_INPUT_OK || !same_string(line, ""))
        return 12;
    if (das_read_line(&reader, line, sizeof(line)) != DAS_INPUT_EOF)
        return 13;
    return 0;
}

static int
test_long_line(void)
{
    static const unsigned int input[] = {
        'A', 'B', 'C', 'D', 'E', '\n', 'X', '\n'
    };
    struct mem_chars mem;
    struct das_char_reader reader;
    char line[4];

    mem.data = input;
    mem.count = (unsigned int)(sizeof(input) / sizeof(input[0]));
    mem.pos = 0U;
    reader.get = mem_char_get;
    reader.arg = &mem;
    if (das_read_line(&reader, line, sizeof(line)) != DAS_INPUT_TOOLONG)
        return 20;
    if (!same_string(line, "ABC"))
        return 21;
    if (das_read_line(&reader, line, sizeof(line)) != DAS_INPUT_OK)
        return 22;
    if (!same_string(line, "X"))
        return 23;
    return 0;
}


static int
test_truncated_s6rec(void)
{
    static const das_word_t input[] = {
        7ULL,
        0555766455100ULL
    };
    struct mem_words mem;
    struct das_s6reader s6;
    struct das_char_reader reader;
    char line[32];

    mem.data = input;
    mem.count = (unsigned int)(sizeof(input) / sizeof(input[0]));
    mem.pos = 0U;
    das_s6_init(&s6, mem_word_get, &mem);
    reader.get = das_s6_get;
    reader.arg = &s6;
    if (das_read_line(&reader, line, sizeof(line)) != DAS_INPUT_ERROR)
        return 30;
    return 0;
}

static int
test_nontext_s6rec(void)
{
    static const das_word_t input[] = {
        (2ULL << 30) | 1ULL,
        0100000000000ULL
    };
    struct mem_words mem;
    struct das_s6reader s6;
    struct das_char_reader reader;
    char line[8];

    mem.data = input;
    mem.count = (unsigned int)(sizeof(input) / sizeof(input[0]));
    mem.pos = 0U;
    das_s6_init(&s6, mem_word_get, &mem);
    reader.get = das_s6_get;
    reader.arg = &s6;
    if (das_read_line(&reader, line, sizeof(line)) != DAS_INPUT_ERROR)
        return 40;
    return 0;
}

int
main(void)
{
    int rc;

    rc = test_utf9_mask();
    if (rc != 0)
        return rc;
    rc = test_s6rec();
    if (rc != 0)
        return rc;
    rc = test_long_line();
    if (rc != 0)
        return rc;
    rc = test_truncated_s6rec();
    if (rc != 0)
        return rc;
    return test_nontext_s6rec();
}
