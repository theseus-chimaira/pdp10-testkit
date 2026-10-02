#include "dobj.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static struct dobj_word
instruction(unsigned int op, unsigned int ac, unsigned long y)
{
    return dobj_word_halves(((unsigned long)(op & 0777U) << 9) |
                            ((unsigned long)(ac & 017U) << 5), y);
}

static void
fill_block(struct dobj_word *p)
{
    p[0] = instruction(0201U, 1U, 1UL);
    p[1] = instruction(0201U, 2U, 2UL);
    p[2] = instruction(0201U, 3U, 3UL);
    p[3] = instruction(0263U, 017U, 0UL);
}

static void
fill_block_seed(struct dobj_word *p, unsigned long seed)
{
    p[0] = instruction(0201U, 1U, seed);
    p[1] = instruction(0201U, 2U, seed + 1UL);
    p[2] = instruction(0201U, 3U, seed + 2UL);
    p[3] = instruction(0263U, 017U, 0UL);
}

static int
save_object(const char *name, struct dobj_object *o)
{
    FILE *f = fopen(name, "wb");
    int rc;

    if (f == NULL)
        return -1;
    rc = dobj_write(f, o);
    if (fclose(f) != 0)
        rc = -1;
    return rc;
}

static int
make_same(const char *name)
{
    struct dobj_object o;
    int rc;

    memset(&o, 0, sizeof(o));
    o.text_words = 8UL;
    o.text = (struct dobj_word *)calloc(8U, sizeof(*o.text));
    if (o.text == NULL)
        return -1;
    fill_block(&o.text[0]);
    fill_block(&o.text[4]);
    rc = save_object(name, &o);
    dobj_free(&o);
    return rc;
}

static int
make_cross(const char *name)
{
    struct dobj_object o;
    int rc;

    memset(&o, 0, sizeof(o));
    o.text_words = 4UL;
    o.text = (struct dobj_word *)calloc(4U, sizeof(*o.text));
    if (o.text == NULL)
        return -1;
    fill_block(o.text);
    rc = save_object(name, &o);
    dobj_free(&o);
    return rc;
}

static int
make_skip_tail(const char *name)
{
    struct dobj_object o;
    int rc;

    memset(&o, 0, sizeof(o));
    o.text_words = 11UL;
    o.text = (struct dobj_word *)calloc(11U, sizeof(*o.text));
    if (o.text == NULL)
        return -1;

    /*
     * Offsets 1..4 and 6..9 are byte-for-byte identical and each appears to
     * end in JRST.  CAIN at the preceding word can skip that JRST, however,
     * so execution may fall through to offsets 5 and 10 respectively.  Those
     * continuations deliberately differ.  Folding either prefix onto the
     * other would therefore change control flow.
     */
    o.text[0] = instruction(0254U, 0U, 0100UL);
    o.text[1] = instruction(0201U, 1U, 1UL);
    o.text[2] = instruction(0201U, 2U, 2UL);
    o.text[3] = instruction(0306U, 4U, 1UL); /* CAIN 4,1 */
    o.text[4] = instruction(0254U, 0U, 0200UL);
    o.text[5] = instruction(0254U, 0U, 0300UL);
    o.text[6] = o.text[1];
    o.text[7] = o.text[2];
    o.text[8] = o.text[3];
    o.text[9] = o.text[4];
    o.text[10] = instruction(0254U, 0U, 0400UL);

    rc = save_object(name, &o);
    dobj_free(&o);
    return rc;
}

static int
make_xanchor(const char *name)
{
    struct dobj_object o;
    int rc;

    memset(&o, 0, sizeof(o));
    o.text_words = 12UL;
    o.text = (struct dobj_word *)calloc(12U, sizeof(*o.text));
    if (o.text == NULL)
        return -1;
    fill_block_seed(&o.text[0], 010UL);
    fill_block_seed(&o.text[4], 020UL);
    fill_block_seed(&o.text[8], 030UL);
    rc = save_object(name, &o);
    dobj_free(&o);
    return rc;
}

static int
make_xdonor(const char *name)
{
    struct dobj_object o;
    int rc;

    memset(&o, 0, sizeof(o));
    o.text_words = 13UL;
    o.symbol_count = 3UL;
    o.text = (struct dobj_word *)calloc(13U, sizeof(*o.text));
    o.symbols = (struct dobj_symbol *)calloc(3U, sizeof(*o.symbols));
    if (o.text == NULL || o.symbols == NULL) {
        dobj_free(&o);
        return -1;
    }
    fill_block_seed(&o.text[0], 010UL);
    fill_block_seed(&o.text[4], 020UL);
    o.text[8] = instruction(0254U, 0U, 12UL);
    fill_block_seed(&o.text[9], 030UL);

    strcpy(o.symbols[0].name, "cold_fn");
    o.symbols[0].kind = DOBJ_SYM_DEF;
    o.symbols[0].sec = DOBJ_SEC_TEXT;
    o.symbols[0].value = dobj_word_halves(0UL, 0UL);
    strcpy(o.symbols[1].name, "hot_fn");
    o.symbols[1].kind = DOBJ_SYM_DEF;
    o.symbols[1].sec = DOBJ_SEC_TEXT;
    o.symbols[1].value = dobj_word_halves(0UL, 4UL);
    strcpy(o.symbols[2].name, "zero_container");
    o.symbols[2].kind = DOBJ_SYM_DEF;
    o.symbols[2].sec = DOBJ_SEC_TEXT;
    o.symbols[2].value = dobj_word_halves(0UL, 8UL);

    rc = save_object(name, &o);
    dobj_free(&o);
    return rc;
}

static int
make_reloc_anchor(const char *name)
{
    struct dobj_object o;
    int rc;

    memset(&o, 0, sizeof(o));
    o.text_words = 5UL;
    o.symbol_count = 1UL;
    o.entry_symbol = 1UL;
    o.text = (struct dobj_word *)calloc(5U, sizeof(*o.text));
    o.symbols = (struct dobj_symbol *)calloc(1U, sizeof(*o.symbols));
    if (o.text == NULL || o.symbols == NULL) {
        dobj_free(&o);
        return -1;
    }
    fill_block(o.text);
    o.text[4] = instruction(0263U, 017U, 0UL);
    strcpy(o.symbols[0].name, "fold_start");
    o.symbols[0].kind = DOBJ_SYM_DEF;
    o.symbols[0].sec = DOBJ_SEC_TEXT;
    o.symbols[0].value = dobj_word_halves(0UL, 0UL);
    rc = save_object(name, &o);
    dobj_free(&o);
    return rc;
}

static int
make_reloc_donor(const char *name)
{
    struct dobj_object o;
    int rc;

    memset(&o, 0, sizeof(o));
    o.text_words = 7UL;
    o.symbol_count = 1UL;
    o.reloc_count = 2UL;
    o.text = (struct dobj_word *)calloc(7U, sizeof(*o.text));
    o.symbols = (struct dobj_symbol *)calloc(1U, sizeof(*o.symbols));
    o.relocs = (struct dobj_reloc *)calloc(2U, sizeof(*o.relocs));
    if (o.text == NULL || o.symbols == NULL || o.relocs == NULL) {
        dobj_free(&o);
        return -1;
    }
    o.text[0] = instruction(0254U, 0U, 6UL);
    fill_block(&o.text[1]);
    o.text[5] = dobj_word_halves(0UL, 0UL);
    o.text[6] = instruction(0263U, 017U, 0UL);
    strcpy(o.symbols[0].name, "after_fold");
    o.symbols[0].kind = DOBJ_SYM_DEF;
    o.symbols[0].sec = DOBJ_SEC_TEXT;
    o.symbols[0].value = dobj_word_halves(0UL, 6UL);

    o.relocs[0].loc_sec = DOBJ_SEC_TEXT;
    o.relocs[0].type = DOBJ_RELOC_LOCAL_LH18;
    o.relocs[0].target_sec = DOBJ_SEC_TEXT;
    o.relocs[0].offset = 5UL;
    o.relocs[0].addend = dobj_word_halves(0UL, 1UL);
    o.relocs[1].loc_sec = DOBJ_SEC_TEXT;
    o.relocs[1].type = DOBJ_RELOC_LOCAL_RH18;
    o.relocs[1].target_sec = DOBJ_SEC_TEXT;
    o.relocs[1].offset = 5UL;
    o.relocs[1].addend = dobj_word_halves(0UL, 3UL);

    rc = save_object(name, &o);
    dobj_free(&o);
    return rc;
}

static int
check_dxr(const char *name, unsigned long image_words,
          unsigned long text_words, int check_reloc)
{
    FILE *f;
    struct dobj_word w;
    unsigned long i;

    f = fopen(name, "rb");
    if (f == NULL)
        return -1;
    if (dobj_read_word(f, &w) != 0 ||
        dobj_read_word(f, &w) != 0 || w.lh != image_words ||
        dobj_read_word(f, &w) != 0 || w.lh != text_words) {
        fclose(f);
        return -1;
    }
    for (i = 0UL; i < image_words; i++) {
        if (dobj_read_word(f, &w) != 0) {
            fclose(f);
            return -1;
        }
        if (check_reloc && i == 6UL && (w.lh != 0UL || w.rh != 2UL)) {
            fclose(f);
            return -1;
        }
    }
    fclose(f);
    return 0;
}

int
main(int argc, char **argv)
{
    char *end;
    unsigned long iw, tw;

    if (argc >= 3 && strcmp(argv[1], "same") == 0)
        return argc == 3 && make_same(argv[2]) == 0 ? 0 : 1;
    if (argc >= 3 && strcmp(argv[1], "cross") == 0)
        return argc == 3 && make_cross(argv[2]) == 0 ? 0 : 1;
    if (argc >= 3 && strcmp(argv[1], "skip-tail") == 0)
        return argc == 3 && make_skip_tail(argv[2]) == 0 ? 0 : 1;
    if (argc >= 3 && strcmp(argv[1], "xanchor") == 0)
        return argc == 3 && make_xanchor(argv[2]) == 0 ? 0 : 1;
    if (argc >= 3 && strcmp(argv[1], "xdonor") == 0)
        return argc == 3 && make_xdonor(argv[2]) == 0 ? 0 : 1;
    if (argc >= 3 && strcmp(argv[1], "reloc-anchor") == 0)
        return argc == 3 && make_reloc_anchor(argv[2]) == 0 ? 0 : 1;
    if (argc >= 3 && strcmp(argv[1], "reloc-donor") == 0)
        return argc == 3 && make_reloc_donor(argv[2]) == 0 ? 0 : 1;
    if (argc == 5 && strcmp(argv[1], "check") == 0) {
        iw = strtoul(argv[3], &end, 0);
        if (*argv[3] == '\0' || *end != '\0')
            return 2;
        tw = strtoul(argv[4], &end, 0);
        if (*argv[4] == '\0' || *end != '\0')
            return 2;
        return check_dxr(argv[2], iw, tw, 0) == 0 ? 0 : 1;
    }
    if (argc == 3 && strcmp(argv[1], "check-reloc") == 0)
        return check_dxr(argv[2], 8UL, 8UL, 1) == 0 ? 0 : 1;
    return 2;
}
