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

static int
write_guard_object(const char *name, unsigned int op)
{
    struct dobj_object o;
    FILE *f;
    unsigned long i;

    memset(&o, 0, sizeof(o));
    o.text_words = 12UL;
    o.reloc_count = 2UL;
    o.text = (struct dobj_word *)calloc((size_t)o.text_words,
                                        sizeof(*o.text));
    o.relocs = (struct dobj_reloc *)calloc((size_t)o.reloc_count,
                                            sizeof(*o.relocs));
    if (o.text == NULL || o.relocs == NULL) {
        dobj_free(&o);
        return -1;
    }

    for (i = 0UL; i < 2UL; i++) {
        unsigned long base = i * 6UL;

        o.text[base] = instruction(op, 1U, 0UL);
        o.text[base + 1UL] = instruction(0254U, 0U, base + 4UL);
        o.text[base + 2UL] = instruction(0201U, 2U, 1UL);
        o.text[base + 3UL] = instruction(0263U, 017U, 0UL);
        o.text[base + 4UL] = instruction(0201U, 2U, 2UL);
        o.text[base + 5UL] = instruction(0263U, 017U, 0UL);

        o.relocs[i].loc_sec = DOBJ_SEC_TEXT;
        o.relocs[i].type = DOBJ_RELOC_LOCAL_RH18;
        o.relocs[i].target_sec = DOBJ_SEC_TEXT;
        o.relocs[i].offset = base + 1UL;
        o.relocs[i].addend = dobj_word_halves(0UL, base + 4UL);
    }

    f = fopen(name, "wb");
    if (f == NULL) {
        dobj_free(&o);
        return -1;
    }
    if (dobj_write(f, &o) != 0 || fclose(f) != 0) {
        dobj_free(&o);
        return -1;
    }
    dobj_free(&o);
    return 0;
}

int
main(int argc, char **argv)
{
    char *end;
    unsigned long op;

    if (argc != 3)
        return 2;
    op = strtoul(argv[2], &end, 8);
    if (*argv[2] == '\0' || *end != '\0' || op > 0777UL)
        return 2;
    return write_guard_object(argv[1], (unsigned int)op) == 0 ? 0 : 1;
}
