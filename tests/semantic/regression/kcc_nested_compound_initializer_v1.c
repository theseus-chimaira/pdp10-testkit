/*
 * A compound literal in a file-scope initializer invokes the initializer
 * parser recursively.  The outer unbounded array must retain its own
 * symbol and size while the nested compound literal is parsed.
 */
typedef struct {
    char *key;
    char *value;
} entry_t;

typedef struct {
    long type;
    char *value;
} payload_t;

static entry_t entries[] = {
    {"", (char *)&((payload_t){1, (char *)1})},
    {"x", (char *)&((payload_t){2, (char *)2})}
};

int
main(void)
{
    payload_t *p;

    if (sizeof(entries) / sizeof(entries[0]) != 2)
        return 1;
    if (entries[0].key[0] != 0 || entries[1].key[0] != 'x')
        return 2;
    p = (payload_t *)entries[0].value;
    if (p->type != 1 || p->value != (char *)1)
        return 3;
    p = (payload_t *)entries[1].value;
    if (p->type != 2 || p->value != (char *)2)
        return 4;
    return 0;
}
