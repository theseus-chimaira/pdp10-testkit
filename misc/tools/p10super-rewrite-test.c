#include "dobj.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static struct dobj_word
instruction(unsigned int op, unsigned int ac, unsigned int xr,
    unsigned long y)
{
    return dobj_word_halves(((unsigned long)(op & 0777U) << 9) |
                            ((unsigned long)(ac & 017U) << 5) |
                            (unsigned long)(xr & 017U), y);
}

int
main(int argc, char **argv)
{
    struct dobj_object o;
    FILE *f;
    unsigned int cai_xr = 0U;
    unsigned int jrst_ac = 0U;
    int rc;

    if (argc != 3)
        return 2;
    if (strcmp(argv[2], "ac-memory-dependency") == 0) {
        memset(&o, 0, sizeof(o));
        o.text_words = 4UL;
        o.symbol_count = 2UL;
        o.text = (struct dobj_word *)calloc(4U, sizeof(*o.text));
        o.symbols = (struct dobj_symbol *)calloc(2U, sizeof(*o.symbols));
        if (o.text == NULL || o.symbols == NULL) {
            dobj_free(&o);
            return 1;
        }
        /*
         * Direct addresses 1 and 2 are AC1 and AC2, not independent memory.
         * Left computes AC3 from the newly written AC2; right reads old AC2
         * before overwriting it.  The two source orders are not reorderable.
         */
        o.text[0] = instruction(0200U, 2U, 0U, 1UL); /* MOVE 2,1 */
        o.text[1] = instruction(0200U, 3U, 0U, 2UL); /* MOVE 3,2 */
        o.text[2] = instruction(0200U, 3U, 0U, 2UL); /* MOVE 3,2 */
        o.text[3] = instruction(0200U, 2U, 0U, 1UL); /* MOVE 2,1 */
        strcpy(o.symbols[0].name, "ac_dep_left");
        o.symbols[0].kind = DOBJ_SYM_DEF;
        o.symbols[0].sec = DOBJ_SEC_TEXT;
        o.symbols[0].value = dobj_word_halves(0UL, 0UL);
        strcpy(o.symbols[1].name, "ac_dep_right");
        o.symbols[1].kind = DOBJ_SYM_DEF;
        o.symbols[1].sec = DOBJ_SEC_TEXT;
        o.symbols[1].value = dobj_word_halves(0UL, 2UL);

        f = fopen(argv[1], "wb");
        if (f == NULL) {
            dobj_free(&o);
            return 1;
        }
        rc = dobj_write(f, &o);
        if (fclose(f) != 0)
            rc = -1;
        dobj_free(&o);
        return rc == 0 ? 0 : 1;
    } else if (strcmp(argv[2], "schedule-fold") == 0) {
        memset(&o, 0, sizeof(o));
        o.text_words = 8UL;
        o.text = (struct dobj_word *)calloc(8U, sizeof(*o.text));
        if (o.text == NULL) {
            dobj_free(&o);
            return 1;
        }
        o.text[0] = instruction(0263U, 017U, 0U, 0UL);
        o.text[1] = instruction(0201U, 1U, 0U, 1UL);
        o.text[2] = instruction(0201U, 2U, 0U, 2UL);
        o.text[3] = instruction(0263U, 017U, 0U, 0UL);
        o.text[4] = instruction(0263U, 017U, 0U, 0UL);
        o.text[5] = instruction(0201U, 2U, 0U, 2UL);
        o.text[6] = instruction(0201U, 1U, 0U, 1UL);
        o.text[7] = instruction(0263U, 017U, 0U, 0UL);

        f = fopen(argv[1], "wb");
        if (f == NULL) {
            dobj_free(&o);
            return 1;
        }
        rc = dobj_write(f, &o);
        if (fclose(f) != 0)
            rc = -1;
        dobj_free(&o);
        return rc == 0 ? 0 : 1;
    } else if (strcmp(argv[2], "global-conflict") == 0) {
        memset(&o, 0, sizeof(o));
        o.text_words = 9UL;
        o.symbol_count = 3UL;
        o.text = (struct dobj_word *)calloc(9U, sizeof(*o.text));
        o.symbols = (struct dobj_symbol *)calloc(3U, sizeof(*o.symbols));
        if (o.text == NULL || o.symbols == NULL) {
            dobj_free(&o);
            return 1;
        }
        o.text[0] = instruction(0201U, 1U, 0U, 1UL);
        o.text[1] = instruction(0201U, 2U, 0U, 2UL);
        o.text[2] = instruction(0700U, 0U, 0U, 1UL);
        o.text[3] = instruction(0201U, 2U, 0U, 2UL);
        o.text[4] = instruction(0201U, 1U, 0U, 1UL);
        o.text[5] = instruction(0700U, 0U, 0U, 2UL);
        o.text[6] = instruction(0201U, 1U, 0U, 1UL);
        o.text[7] = instruction(0201U, 2U, 0U, 2UL);
        o.text[8] = instruction(0700U, 0U, 0U, 3UL);
        strcpy(o.symbols[0].name, "global_left");
        o.symbols[0].kind = DOBJ_SYM_DEF;
        o.symbols[0].sec = DOBJ_SEC_TEXT;
        o.symbols[0].value = dobj_word_halves(0UL, 0UL);
        strcpy(o.symbols[1].name, "global_mid");
        o.symbols[1].kind = DOBJ_SYM_DEF;
        o.symbols[1].sec = DOBJ_SEC_TEXT;
        o.symbols[1].value = dobj_word_halves(0UL, 3UL);
        strcpy(o.symbols[2].name, "global_right");
        o.symbols[2].kind = DOBJ_SYM_DEF;
        o.symbols[2].sec = DOBJ_SEC_TEXT;
        o.symbols[2].value = dobj_word_halves(0UL, 6UL);

        f = fopen(argv[1], "wb");
        if (f == NULL) {
            dobj_free(&o);
            return 1;
        }
        rc = dobj_write(f, &o);
        if (fclose(f) != 0)
            rc = -1;
        dobj_free(&o);
        return rc == 0 ? 0 : 1;
    } else if (strcmp(argv[2], "zero-form") == 0) {
        memset(&o, 0, sizeof(o));
        o.text_words = 6UL;
        o.symbol_count = 2UL;
        o.text = (struct dobj_word *)calloc(6U, sizeof(*o.text));
        o.symbols = (struct dobj_symbol *)calloc(2U, sizeof(*o.symbols));
        if (o.text == NULL || o.symbols == NULL) {
            dobj_free(&o);
            return 1;
        }
        o.text[0] = instruction(0201U, 2U, 0U, 2UL);
        o.text[1] = instruction(0201U, 1U, 0U, 0UL); /* MOVEI 1,0 */
        o.text[2] = instruction(0201U, 3U, 0U, 3UL);
        o.text[3] = instruction(0201U, 2U, 0U, 2UL);
        o.text[4] = instruction(0400U, 1U, 0U, 0UL); /* SETZ 1, */
        o.text[5] = instruction(0201U, 3U, 0U, 3UL);
        strcpy(o.symbols[0].name, "zero_left");
        o.symbols[0].kind = DOBJ_SYM_DEF;
        o.symbols[0].sec = DOBJ_SEC_TEXT;
        o.symbols[0].value = dobj_word_halves(0UL, 0UL);
        strcpy(o.symbols[1].name, "zero_right");
        o.symbols[1].kind = DOBJ_SYM_DEF;
        o.symbols[1].sec = DOBJ_SEC_TEXT;
        o.symbols[1].value = dobj_word_halves(0UL, 3UL);

        f = fopen(argv[1], "wb");
        if (f == NULL) {
            dobj_free(&o);
            return 1;
        }
        rc = dobj_write(f, &o);
        if (fclose(f) != 0)
            rc = -1;
        dobj_free(&o);
        return rc == 0 ? 0 : 1;
    } else if (strcmp(argv[2], "rename") == 0) {
        memset(&o, 0, sizeof(o));
        o.text_words = 10UL;
        o.symbol_count = 2UL;
        o.text = (struct dobj_word *)calloc(10U, sizeof(*o.text));
        o.symbols = (struct dobj_symbol *)calloc(2U, sizeof(*o.symbols));
        if (o.text == NULL || o.symbols == NULL) {
            dobj_free(&o);
            return 1;
        }
        o.text[0] = instruction(0201U, 1U, 0U, 1UL);
        o.text[1] = instruction(0201U, 2U, 0U, 2UL);
        o.text[2] = instruction(0201U, 1U, 0U, 7UL); /* kill AC1 */
        o.text[3] = instruction(0201U, 2U, 0U, 7UL); /* kill AC2 */
        o.text[4] = instruction(0263U, 017U, 0U, 0UL);
        o.text[5] = instruction(0201U, 3U, 0U, 1UL);
        o.text[6] = instruction(0201U, 4U, 0U, 2UL);
        o.text[7] = instruction(0201U, 3U, 0U, 7UL); /* kill AC3 */
        o.text[8] = instruction(0201U, 4U, 0U, 7UL); /* kill AC4 */
        o.text[9] = instruction(0263U, 017U, 0U, 0UL);
        strcpy(o.symbols[0].name, "rename_left");
        o.symbols[0].kind = DOBJ_SYM_DEF;
        o.symbols[0].sec = DOBJ_SEC_TEXT;
        o.symbols[0].value = dobj_word_halves(0UL, 0UL);
        strcpy(o.symbols[1].name, "rename_right");
        o.symbols[1].kind = DOBJ_SYM_DEF;
        o.symbols[1].sec = DOBJ_SEC_TEXT;
        o.symbols[1].value = dobj_word_halves(0UL, 5UL);

        f = fopen(argv[1], "wb");
        if (f == NULL) {
            dobj_free(&o);
            return 1;
        }
        rc = dobj_write(f, &o);
        if (fclose(f) != 0)
            rc = -1;
        dobj_free(&o);
        return rc == 0 ? 0 : 1;
    } else if (strcmp(argv[2], "schedule") == 0) {
        memset(&o, 0, sizeof(o));
        o.text_words = 4UL;
        o.symbol_count = 2UL;
        o.text = (struct dobj_word *)calloc(4U, sizeof(*o.text));
        o.symbols = (struct dobj_symbol *)calloc(2U, sizeof(*o.symbols));
        if (o.text == NULL || o.symbols == NULL) {
            dobj_free(&o);
            return 1;
        }
        o.text[0] = instruction(0201U, 1U, 0U, 1UL);
        o.text[1] = instruction(0201U, 2U, 0U, 2UL);
        o.text[2] = instruction(0201U, 2U, 0U, 2UL);
        o.text[3] = instruction(0201U, 1U, 0U, 1UL);
        strcpy(o.symbols[0].name, "left");
        o.symbols[0].kind = DOBJ_SYM_DEF;
        o.symbols[0].sec = DOBJ_SEC_TEXT;
        o.symbols[0].value = dobj_word_halves(0UL, 0UL);
        strcpy(o.symbols[1].name, "right");
        o.symbols[1].kind = DOBJ_SYM_DEF;
        o.symbols[1].sec = DOBJ_SEC_TEXT;
        o.symbols[1].value = dobj_word_halves(0UL, 2UL);

        f = fopen(argv[1], "wb");
        if (f == NULL) {
            dobj_free(&o);
            return 1;
        }
        rc = dobj_write(f, &o);
        if (fclose(f) != 0)
            rc = -1;
        dobj_free(&o);
        return rc == 0 ? 0 : 1;
    } else if (strcmp(argv[2], "valid") == 0) {
        /* Default operands form the legal CAIN/JRST peephole. */
    } else if (strcmp(argv[2], "indexed-cai") == 0) {
        cai_xr = 1U;
    } else if (strcmp(argv[2], "special-jrst") == 0) {
        jrst_ac = 1U;
    } else {
        return 2;
    }

    memset(&o, 0, sizeof(o));
    o.text_words = 3UL;
    o.symbol_count = 1UL;
    o.text = (struct dobj_word *)calloc(3U, sizeof(*o.text));
    o.symbols = (struct dobj_symbol *)calloc(1U, sizeof(*o.symbols));
    if (o.text == NULL || o.symbols == NULL) {
        dobj_free(&o);
        return 1;
    }
    o.text[0] = instruction(0306U, 5U, cai_xr, 0UL); /* CAIN 5,0 */
    o.text[1] = instruction(0254U, jrst_ac, 0U, 2UL); /* JRST 2 */
    o.text[2] = instruction(0263U, 017U, 0U, 0UL);    /* POPJ 17, */
    strcpy(o.symbols[0].name, "candidate");
    o.symbols[0].kind = DOBJ_SYM_DEF;
    o.symbols[0].sec = DOBJ_SEC_TEXT;
    o.symbols[0].value = dobj_word_halves(0UL, 0UL);

    f = fopen(argv[1], "wb");
    if (f == NULL) {
        dobj_free(&o);
        return 1;
    }
    rc = dobj_write(f, &o);
    if (fclose(f) != 0)
        rc = -1;
    dobj_free(&o);
    return rc == 0 ? 0 : 1;
}
