#define DAS_NO_MAIN 1
#include "das.c"

#define COLLISION_NAMES 12U
#define CACHE_COLLISION_NAMES 6U

static int
same_sym(struct sym *s, const char *name, int sec, unsigned int off)
{
    return s != 0 && strcmp(s->name, name) == 0 &&
        s->sec == sec && s->off == off;
}

int
main(void)
{
    struct asmctx c;
    struct sym s;
    char name[DAS_MAX_NAME + 1];
    char expr[DAS_MAX_LINE];
    char long_expr[131];
    char bucket_names[COLLISION_NAMES][DAS_MAX_NAME + 1];
    char cache_names[CACHE_COLLISION_NAMES][DAS_MAX_NAME + 1];
    unsigned int bucket;
    unsigned int cache_index;
    unsigned int candidate;
    unsigned int count;
    unsigned int i;
    unsigned int expected_records;
    unsigned int expected_lit_words;
    unsigned int ir_pos;
    unsigned int ir_type;
    char ir_line[DAS_MAX_LINE];
    das_word_t ir_magic;

    memset(&c, 0, sizeof(c));
    if (store_init(&c, "das-store-selftest") != 0)
        return 1;

    expected_records = 0U;
    for (i = 0U; i < DAS_SYM_CACHE_ENTRIES * 5U; i++) {
        sprintf(name, "SYM%05u", i);
        add_sym(&c, name, (i & 1U) ? DAS_SEC_TEXT : DAS_SEC_DATA,
            i & DAS_HALF_MASK);
        expected_records++;
    }
    if (!find_sym(&c, "SYM00000", &s) ||
        !same_sym(&s, "SYM00000", DAS_SEC_DATA, 0U))
        return 2;
    sprintf(name, "SYM%05u", DAS_SYM_CACHE_ENTRIES * 5U - 1U);
    if (!find_sym(&c, name, &s) ||
        !same_sym(&s, name, DAS_SEC_DATA, DAS_SYM_CACHE_ENTRIES * 5U - 1U))
        return 3;

    add_sym(&c, "SYM00000", DAS_SEC_BSS, 0777U);
    expected_records++;
    if (!find_sym(&c, "SYM00000", &s) ||
        !same_sym(&s, "SYM00000", DAS_SEC_BSS, 0777U))
        return 4;

    bucket = (unsigned int)(sym_hash("COL00000") &
        (DAS_SYM_BUCKETS - 1U));
    candidate = 0U;
    count = 0U;
    while (count < COLLISION_NAMES && candidate < 1000000U) {
        sprintf(name, "COL%06u", candidate++);
        if ((unsigned int)(sym_hash(name) &
                (DAS_SYM_BUCKETS - 1U)) == bucket) {
            strcopy(bucket_names[count], name, sizeof(bucket_names[count]));
            add_sym(&c, name, DAS_SEC_TEXT, 01000U + count);
            expected_records++;
            count++;
        }
    }
    if (count != COLLISION_NAMES)
        return 5;
    for (i = COLLISION_NAMES; i != 0U; i--) {
        count = i - 1U;
        if (!find_sym(&c, bucket_names[count], &s) ||
            !same_sym(&s, bucket_names[count], DAS_SEC_TEXT,
                01000U + count))
            return 6;
    }
    for (;;) {
        sprintf(name, "COL%06u", candidate++);
        if ((unsigned int)(sym_hash(name) &
                (DAS_SYM_BUCKETS - 1U)) == bucket)
            break;
        if (candidate >= 1000000U)
            return 7;
    }
    if (find_sym(&c, name, &s))
        return 8;

    cache_index = sym_cache_index(sym_hash("CAC00000"));
    candidate = 0U;
    count = 0U;
    while (count < CACHE_COLLISION_NAMES && candidate < 1000000U) {
        sprintf(name, "CAC%06u", candidate++);
        if (sym_cache_index(sym_hash(name)) == cache_index) {
            strcopy(cache_names[count], name, sizeof(cache_names[count]));
            add_sym(&c, name, DAS_SEC_DATA, 02000U + count);
            expected_records++;
            count++;
        }
    }
    if (count != CACHE_COLLISION_NAMES)
        return 9;
    for (i = 0U; i < CACHE_COLLISION_NAMES; i++) {
        if (!find_sym(&c, cache_names[i], &s) ||
            !same_sym(&s, cache_names[i], DAS_SEC_DATA, 02000U + i))
            return 10;
    }

    add_lit_text(&c, "POINT 9,@BUF(2),35",
        strlen("POINT 9,@BUF(2),35"));
    add_lit_text(&c, "OWGBP 70,PTR", strlen("OWGBP 70,PTR"));
    add_lit_text(&c, "POINT 9,@BUF(2),35",
        strlen("POINT 9,@BUF(2),35"));
    for (i = 0U; i < sizeof(long_expr) - 1U; i++)
        long_expr[i] = (char)('A' + (i % 26U));
    long_expr[sizeof(long_expr) - 1U] = 0;
    add_lit_text(&c, long_expr, strlen(long_expr));
    expected_lit_words = 1U +
        ((unsigned int)strlen("POINT 9,@BUF(2),35") + 3U) / 4U;
    expected_lit_words += 1U +
        ((unsigned int)strlen("OWGBP 70,PTR") + 3U) / 4U;
    expected_lit_words += 1U +
        ((unsigned int)strlen(long_expr) + 3U) / 4U;
    lit_stream_reset(&c);
    if (lit_read_next(&c, expr, sizeof(expr)) != 0 ||
        strcmp(expr, "POINT 9,@BUF(2),35") != 0)
        return 11;
    if (lit_read_next(&c, expr, sizeof(expr)) != 0 ||
        strcmp(expr, "OWGBP 70,PTR") != 0)
        return 12;
    if (lit_read_next(&c, expr, sizeof(expr)) != 0 ||
        strcmp(expr, long_expr) != 0)
        return 13;
    if (lit_read_next(&c, expr, sizeof(expr)) == 0)
        return 18;
    if (c.lit_store.words != expected_lit_words)
        return 17;

    if (c.sym_store.records != expected_records)
        return 14;
    if (c.lit_store.records != 3U)
        return 15;
    if (c.sym_store.probes == 0U)
        return 16;

    if (ir_store_begin(&c) != 0)
        return 19;
    if (ir_store_append_line(&c, "MOVEI 1,1") != 0)
        return 20;
    if (ir_store_control(&c, DAS_IR_RESET) != 0)
        return 21;
    if (ir_store_append_line(&c, "JRST DONE") != 0)
        return 22;
    if (ir_store_control(&c, DAS_IR_GUARD) != 0)
        return 23;
    if (wordfile_read(&c.ir_spill, 0U, &ir_magic, 1U) != 0 ||
        ir_magic != DAS_IR_MAGIC)
        return 24;
    ir_pos = 1U;
    if (ir_store_read_line(&c, &ir_pos, ir_line, &ir_type) != 0 ||
        ir_type != DAS_IR_LINE || strcmp(ir_line, "MOVEI 1,1") != 0)
        return 25;
    if (ir_store_read_line(&c, &ir_pos, ir_line, &ir_type) != 0 ||
        ir_type != DAS_IR_RESET)
        return 26;
    if (ir_store_read_line(&c, &ir_pos, ir_line, &ir_type) != 0 ||
        ir_type != DAS_IR_LINE || strcmp(ir_line, "JRST DONE") != 0)
        return 27;
    if (ir_store_read_line(&c, &ir_pos, ir_line, &ir_type) != 0 ||
        ir_type != DAS_IR_GUARD || ir_pos != c.ir_spill.words)
        return 28;

    store_close(&c);
    return 0;
}
