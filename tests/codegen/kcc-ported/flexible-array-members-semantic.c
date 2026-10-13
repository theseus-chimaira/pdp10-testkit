volatile int __test_exit;

struct flex_char {
    int n;
    char data[];
};

struct flex_int {
    char tag;
    int data[];
};

struct flex_packed {
    char tag;
    char data[];
} __attribute__((packed));

int
main(void)
{
    int raw[8];
    struct flex_char *c;
    struct flex_int *i;

    if (sizeof(struct flex_char) != 4) return 1;
    if (sizeof(struct flex_int) != 4) return 2;
    if (sizeof(struct flex_packed) != 1) return 3;

    c = (struct flex_char *)raw;
    c->n = 3;
    c->data[0] = 11;
    c->data[1] = 22;
    c->data[2] = 33;
    if (c->n != 3 || c->data[0] != 11 || c->data[1] != 22
        || c->data[2] != 33) return 4;

    i = (struct flex_int *)raw;
    i->tag = 7;
    i->data[0] = 101;
    i->data[1] = 202;
    if (i->tag != 7 || i->data[0] != 101 || i->data[1] != 202) return 5;

    return 0;
}
