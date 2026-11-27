/* Compare dynamic bitfield accesses with independent native word
 * patterns. Exercise local and global arrays, nested record strides,
 * signed fields, compound stores, and evaluated-once subscripts.
 */
typedef union {
    struct {
        unsigned int upper : 8;
        signed int middle : 5;
        unsigned int lower : 23;
        unsigned long guard;
    } f;
    unsigned long raw[2];
} word_oracle;
struct fields {
    unsigned int upper : 8;
    signed int middle : 5;
    unsigned int lower : 23;
    unsigned long guard;
};
static struct fields records[3];
static struct {
    unsigned long before;
    struct fields row[2][3];
    unsigned long after;
} nested;
static volatile unsigned int initial = 1;
volatile unsigned int fail_id;

int main(void)
{
    struct fields local[3];
    unsigned int i, j, k, n;
    word_oracle probe;
    unsigned long expect;
    n = initial;
    fail_id = 1;
    if (sizeof(struct fields) != 8 || sizeof(probe) != 8) return 1;
    for (i = 0; i < 3; ++i) {
        records[i].upper = 0200 + i;
        records[i].middle = -3 - (int)i;
        records[i].lower = 0123456 + i;
        records[i].guard = 076543210 + i;
        local[i] = records[i];
    }
    for (i = 0; i < 3; ++i) {
        /* Use character-wise copying into a union to read native
         * words without assuming that bitfield stores and loads
         * agree merely because both use the same faulty address. */
        const unsigned char *p = (const unsigned char *)&records[i];
        unsigned char *q = (unsigned char *)&probe;
        for (j = 0; j < sizeof(probe); ++j) q[j] = p[j];
        expect = ((0200UL+i) << 28) |
                 ((unsigned long)(-3-(int)i) & 037UL) << 23 |
                 (0123456UL+i);
        if (probe.raw[0] != expect || probe.raw[1] != 076543210UL+i)
            return 1;
        fail_id = 2;
        if (local[i].upper != 0200+i || local[i].middle != -3-(int)i ||
            local[i].lower != 0123456+i || local[i].guard != 076543210UL+i)
            return 2;
    }
    fail_id = 3;
    nested.before = 0123456701234UL;
    nested.after = 0765432107654UL;
    for (i = 0; i < 2; ++i)
        for (j = 0; j < 3; ++j) {
            k = 3*i+j;
            nested.row[i][j].upper = 040+k;
            nested.row[i][j].middle = -8+(int)k;
            nested.row[i][j].lower = 0100+k;
            nested.row[i][j].guard = 0200+k;
        }
    for (i = 0; i < 2; ++i)
        for (j = 0; j < 3; ++j) {
            k = 3*i+j;
            if (nested.row[i][j].upper != 040+k ||
                nested.row[i][j].middle != -8+(int)k ||
                nested.row[i][j].lower != 0100+k ||
                nested.row[i][j].guard != 0200+k) return 3;
        }
    fail_id = 4;
    i = n;
    if ((records[i++].middle = -9) != -9 || i != n+1 ||
        records[n].middle != -9) return 4;
    i = n;
    if ((records[i++].lower += 7) != 0123456+n+7 ||
        i != n+1 || records[n].lower != 0123456+n+7) return 4;
    fail_id = 5;
    if (nested.before != 0123456701234UL ||
        nested.after != 0765432107654UL ||
        records[n-1].middle != -3 ||
        records[n+1].middle != -5 ||
        records[n].upper != 0200+n ||
        records[n].guard != 076543210UL+n) return 5;
    fail_id = 0;
    return 0;
}
