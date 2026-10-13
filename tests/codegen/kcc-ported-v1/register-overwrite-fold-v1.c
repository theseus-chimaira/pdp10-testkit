/* codegen-kcc-check: "register-overwrite-fold" */
/* codegen-kcc-policy-only: yes */
typedef unsigned long kword_t;

#define ID_MASK 07777UL
#define CHARS_SHIFT 12U
#define CHARS_MASK 077UL

struct name {
    kword_t words[8];
    unsigned int chars;
};

struct key {
    kword_t meta;
    kword_t words[2];
};

extern int sink();
extern void zero_words(kword_t *, unsigned int);

struct block {
    kword_t words[5];
};

void reverse_move(struct block *p)
{
    zero_words((kword_t *)p, 5U);
}

extern void put_sixbit(kword_t *, unsigned int, unsigned int);

int resolved_reverse(path, nwords, index, c)
kword_t *path;
unsigned int nwords;
unsigned int index;
unsigned int c;
{
    unsigned int slot;

    if (path == 0)
        return -1;
    if (c < 040U || c > 0137U)
        return -1;
    slot = 1U + index / 6U;
    if (slot >= nwords)
        return -1;
    put_sixbit(path + 1U, index, c);
    return 0;
}

int test(name, table, count, id)
struct name *name;
const struct key *table;
unsigned int count;
unsigned int id;
{
    unsigned int i;

    for (i = 0; i < count; ++i) {
        if ((unsigned int)(table[i].meta & ID_MASK) == id)
            return sink(name, table[i].words,
                (unsigned int)((table[i].meta >> CHARS_SHIFT) & CHARS_MASK));
    }
    return -1;
}
