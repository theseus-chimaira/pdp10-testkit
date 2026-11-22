/* Native DAS phase-2 relocation bitmap: bounded, disk-backed output. */
#define DAS_NATIVE 1
#define DAS_NATIVE_PHASE2_ONLY 1
#define DAS_NO_MAIN 1
#define DAIMOS_DSYS_HOST_MOCK 1
#include "das.c"

#define MAP_FD 12
#define OUTPUT_FD 13
#define MAP_CAP 3000U
#define OUTPUT_CAP 104000U

static kword_t map_words[MAP_CAP];
static kword_t output_words[OUTPUT_CAP];
static unsigned int map_pos;
static unsigned int output_pos;
static unsigned int map_length;
static unsigned int output_length;
static int fail_next_read;

/* Native DAS diagnostics write to descriptor 2 even in a source-linked
 * host test.  Supply that syscall as a bounded mock instead of leaving
 * the existing output_emit error path with an unresolved reference.
 * Word-I/O assertions below remain unchanged.
 */
static char diag_bytes[256];
static unsigned int diag_used;

int dsys_writechar(int fd, int ch)
{
    if (fd != DSYS_STDERR || ch < 0 || ch > 127 ||
        diag_used >= sizeof(diag_bytes))
        return -1;
    diag_bytes[diag_used++] = (char)ch;
    return 0;
}

static kword_t *mock_store(int fd, unsigned int **pos,
                            unsigned int **length, unsigned int *cap)
{
    if (fd == MAP_FD) {
        *pos = &map_pos;
        *length = &map_length;
        *cap = MAP_CAP;
        return map_words;
    }
    if (fd == OUTPUT_FD) {
        *pos = &output_pos;
        *length = &output_length;
        *cap = OUTPUT_CAP;
        return output_words;
    }
    return 0;
}

kword_t dsys_seek(int fd, kword_t off, unsigned int whence)
{
    unsigned int *pos;
    unsigned int *length;
    unsigned int cap;

    if (whence != SYS_SEEK_SET || off > OUTPUT_CAP ||
        mock_store(fd, &pos, &length, &cap) == 0 || off > cap)
        return (kword_t)-1;
    *pos = (unsigned int)off;
    return off;
}

int dsys_write_words(int fd, kword_t *data, unsigned int n)
{
    unsigned int *pos;
    unsigned int *length;
    unsigned int cap;
    kword_t *store;
    unsigned int i;

    store = mock_store(fd, &pos, &length, &cap);
    if (store == 0 || *pos > cap || n > cap - *pos)
        return -1;
    for (i = 0U; i < n; i++)
        store[*pos + i] = data[i];
    *pos += n;
    if (*length < *pos)
        *length = *pos;
    return (int)n;
}

int dsys_read_words(int fd, kword_t *data, unsigned int n)
{
    unsigned int *pos;
    unsigned int *length;
    unsigned int cap;
    kword_t *store;
    unsigned int i;

    store = mock_store(fd, &pos, &length, &cap);
    if (store == 0 || *pos > *length)
        return -1;
    if (fail_next_read) {
        fail_next_read = 0;
        return -1;
    }
    if (n > *length - *pos)
        n = *length - *pos;
    for (i = 0U; i < n; i++)
        data[i] = store[*pos + i];
    *pos += n;
    return (int)n;
}

static void init_files(FILE *output, FILE *map,
                       struct das_wordfile *spill)
{
    output->fd = OUTPUT_FD;
    output->error = 0;
    output->used = 1;
    map->fd = MAP_FD;
    map->error = 0;
    map->used = 1;
    spill->file = map;
    spill->words = 0U;
    map_pos = 0U;
    output_pos = 0U;
    map_length = 0U;
    output_length = 0U;
}

static int check_small(void)
{
    FILE output;
    FILE map;
    struct das_wordfile spill;
    struct das_output out;
    unsigned int i;

    init_files(&output, &map, &spill);
    if (output_begin(&out, &output, 0U, 100U, 0U, 0, 3U) != 0 ||
        output_begin_reloc_spill(&out, &spill) != 0)
        return 10;
    for (i = 0U; i < 100U; i++) {
        if (output_emit(&out, i, (das_word_t)(04000U + i),
                i == 0U || i == 71U || i == 99U) != 0)
            return 11;
    }
    /* Literal-style late emission to an earlier relocation bitmap word. */
    if (output_emit(&out, 37U, (das_word_t)(04000U + 37U), 1) != 0 ||
        output_finish(&out) != 0)
        return 12;
    if (map_length != 3U || output_length != 105U)
        return 13;
    for (i = 0U; i < 100U; i++) {
        if (output_words[2U + i] != (kword_t)(04000U + i))
            return 14;
    }
    if (map_words[0] != (DAS_W(1) << 35U) ||
        map_words[1] != ((DAS_W(1) << 34U) | DAS_W(1)) ||
        map_words[2] != (DAS_W(1) << 8U))
        return 15;
    for (i = 0U; i < 3U; i++) {
        if (output_words[102U + i] != map_words[i])
            return 16;
    }
    return 0;
}

static int check_maximum(void)
{
    FILE output;
    FILE map;
    struct das_wordfile spill;
    struct das_output out;
    unsigned int count;
    unsigned int last;

    init_files(&output, &map, &spill);
    last = EXEC_DXR_MAX_IMAGE_WORDS - 1U;
    count = (EXEC_DXR_MAX_IMAGE_WORDS + 35U) / 36U;
    if (count > MAP_CAP ||
        output_begin(&out, &output, 0U, EXEC_DXR_MAX_IMAGE_WORDS,
            0U, 0, count) != 0 ||
        output_begin_reloc_spill(&out, &spill) != 0)
        return 20;
    if (spill.words != count ||
        output_emit(&out, 0U, DAS_W(1), 1) != 0 ||
        output_emit(&out, last, DAS_W(2), 1) != 0 ||
        output_finish(&out) != 0)
        return 21;
    if (output_length != 2U + EXEC_DXR_MAX_IMAGE_WORDS + count ||
        map_words[0] != (DAS_W(1) << 35U) ||
        map_words[count - 1U] !=
            (DAS_W(1) << (35U - last % 36U)) ||
        output_words[2U + EXEC_DXR_MAX_IMAGE_WORDS] != map_words[0] ||
        output_words[output_length - 1U] != map_words[count - 1U])
        return 22;

    /* A failed scratch read must fail the output, not silently drop bits. */
    fail_next_read = 1;
    if (output_emit(&out, 1U, DAS_W(3), 1) == 0)
        return 23;
    return 0;
}

int main(void)
{
    int rc;

    rc = check_small();
    if (rc != 0)
        return rc;
    return check_maximum();
}
