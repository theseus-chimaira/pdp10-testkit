#define DAS_NATIVE 1
#define DAIMOS_DSYS_HOST_MOCK 1
#define DAS_NO_MAIN 1
#include "das.c"

#define FD_BYTES 10
#define FD_WORDS 11
#define FD_SCRATCH 12
#define FD_OUTPUT 13
#define MOCK_WORD_CAP 1024U

static char byte_data[400];
static unsigned int byte_count;
static unsigned int byte_pos;
static kword_t input_words[100];
static unsigned int input_word_count;
static unsigned int input_word_pos;
static kword_t scratch_words[MOCK_WORD_CAP];
static kword_t output_words[MOCK_WORD_CAP];
static unsigned int fd_pos[16];
static unsigned int byte_read_calls;
static unsigned int word_read_calls;
static unsigned int word_write_calls;
static unsigned int seek_calls;

static void
copy_chars(char *dst, const char *src, unsigned int n)
{
    while (n != 0U) {
        *dst++ = *src++;
        n--;
    }
}

static void
copy_words(kword_t *dst, const kword_t *src, unsigned int n)
{
    while (n != 0U) {
        *dst++ = *src++;
        n--;
    }
}

int
__syscall(int num, kword_t a0, kword_t a1, kword_t a2)
{
    int fd;
    unsigned int n;
    unsigned int avail;
    unsigned int pos;
    char *cbuf;
    kword_t *wbuf;
    kword_t *store;

    fd = (int)a0;
    n = (unsigned int)a2;
    if (num == SYS_read && fd == FD_BYTES) {
        byte_read_calls++;
        if (byte_pos >= byte_count)
            return 0;
        avail = byte_count - byte_pos;
        if (n > avail)
            n = avail;
        cbuf = (char *)(unsigned long)a1;
        copy_chars(cbuf, byte_data + byte_pos, n);
        byte_pos += n;
        return (int)n;
    }
    if (num == SYS_read_words && fd == FD_WORDS) {
        word_read_calls++;
        if (input_word_pos >= input_word_count)
            return 0;
        avail = input_word_count - input_word_pos;
        if (n > avail)
            n = avail;
        wbuf = (kword_t *)(unsigned long)a1;
        copy_words(wbuf, input_words + input_word_pos, n);
        input_word_pos += n;
        return (int)n;
    }
    if (num == SYS_seek) {
        seek_calls++;
        if ((int)a2 != SYS_SEEK_SET)
            return -1;
        fd_pos[fd] = (unsigned int)a1;
        return (int)a1;
    }
    if (num == SYS_write_words &&
        (fd == FD_SCRATCH || fd == FD_OUTPUT)) {
        word_write_calls++;
        if ((fd_pos[fd] & 3U) != 0U)
            return -1;
        pos = fd_pos[fd] >> 2;
        if (pos > MOCK_WORD_CAP || n > MOCK_WORD_CAP - pos)
            return -1;
        store = fd == FD_SCRATCH ? scratch_words : output_words;
        wbuf = (kword_t *)(unsigned long)a1;
        copy_words(store + pos, wbuf, n);
        fd_pos[fd] += n << 2;
        return (int)n;
    }
    if (num == SYS_read_words && fd == FD_SCRATCH) {
        word_read_calls++;
        if ((fd_pos[fd] & 3U) != 0U)
            return -1;
        pos = fd_pos[fd] >> 2;
        if (pos > MOCK_WORD_CAP || n > MOCK_WORD_CAP - pos)
            return -1;
        wbuf = (kword_t *)(unsigned long)a1;
        copy_words(wbuf, scratch_words + pos, n);
        fd_pos[fd] += n << 2;
        return (int)n;
    }
    return -1;
}

static int
test_word_buffer(void)
{
    FILE file;
    struct host_word_input input;
    das_word_t buffer[DAS_WORD_INPUT_BUFFER];
    das_word_t word;
    unsigned int i;

    for (i = 0U; i < 70U; i++)
        input_words[i] = (kword_t)(01000U + i);
    input_word_count = 70U;
    input_word_pos = 0U;
    word_read_calls = 0U;
    file.fd = FD_WORDS;
    file.error = 0;
    file.used = 1;
    input.file = &file;
    input.buffer = buffer;
    input.pos = 0U;
    input.count = 0U;
    for (i = 0U; i < 70U; i++) {
        if (host_word_get(&input, &word) != DAS_INPUT_OK)
            return 10;
        if (word != (das_word_t)(01000U + i))
            return 11;
    }
    if (host_word_get(&input, &word) != DAS_INPUT_EOF)
        return 12;
    if (word_read_calls != 4U)
        return 13;
    return 0;
}

static int
test_scratch_blocks(void)
{
    FILE file;
    struct das_wordfile wf;
    das_word_t in[DAS_SYM_RECORD_WORDS];
    das_word_t out[DAS_SYM_RECORD_WORDS];
    unsigned int i;

    file.fd = FD_SCRATCH;
    file.error = 0;
    file.used = 1;
    wf.file = &file;
    wf.words = 0U;
    fd_pos[FD_SCRATCH] = 0U;
    word_write_calls = 0U;
    word_read_calls = 0U;
    seek_calls = 0U;
    for (i = 0U; i < DAS_SYM_RECORD_WORDS; i++)
        in[i] = (das_word_t)(02000U + i);
    if (wordfile_append(&wf, in, DAS_SYM_RECORD_WORDS) != 0)
        return 20;
    if (word_write_calls != 1U)
        return 21;
    if (wordfile_read(&wf, 0U, out, DAS_SYM_RECORD_WORDS) != 0)
        return 22;
    if (word_read_calls != 1U)
        return 23;
    for (i = 0U; i < DAS_SYM_RECORD_WORDS; i++) {
        if (out[i] != in[i])
            return 24;
    }
    return 0;
}

static int
test_output_blocks(void)
{
    FILE file;
    struct das_output out;
    das_word_t relmap[3];
    unsigned int i;

    file.fd = FD_OUTPUT;
    file.error = 0;
    file.used = 1;
    fd_pos[FD_OUTPUT] = 0U;
    word_write_calls = 0U;
    seek_calls = 0U;
    memset(output_words, 0, sizeof(output_words));
    memset(relmap, 0, sizeof(relmap));
    if (output_begin(&out, &file, 0U, 100U, 0U,
            relmap, 3U) != 0)
        return 30;
    for (i = 0U; i < 100U; i++) {
        if (output_emit(&out, i, (das_word_t)(04000U + i),
                i == 37U) != 0)
            return 31;
    }
    if (output_finish(&out) != 0)
        return 32;
    if (word_write_calls != 4U)
        return 33;
    if (output_words[0] != DAS_WORD(DAS_MAGIC_DXR, 0U) ||
        output_words[1] != DAS_WORD(100U, 0U))
        return 34;
    for (i = 0U; i < 100U; i++) {
        if (output_words[2U + i] != (das_word_t)(04000U + i))
            return 35;
    }
    if (output_words[102U] != relmap[0] ||
        output_words[103U] != relmap[1] ||
        output_words[104U] != relmap[2])
        return 36;
    if ((relmap[1] & (DAS_W(1) << 34U)) == DAS_W(0))
        return 37;
    return 0;
}

int
main(void)
{
    int rc;

    rc = test_word_buffer();
    if (rc != 0)
        return rc;
    rc = test_scratch_blocks();
    if (rc != 0)
        return rc;
    return test_output_blocks();
}
