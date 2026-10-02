volatile int __test_exit;

struct packed3 {
    unsigned char a;
    unsigned char b;
    unsigned char c;
} __attribute__((packed));

static struct packed3 values[3];

static int check_pointer(struct packed3 *p)
{
    ++p;
    if (p->a != 4) return 1;
    if (p->b != 5) return 2;
    if (p->c != 6) return 3;
    return 0;
}

int main(void)
{
    if (sizeof(struct packed3) != 3) return 1;
    if (sizeof(values) != 9) return 2;

    values[0].a = 1; values[0].b = 2; values[0].c = 3;
    values[1].a = 4; values[1].b = 5; values[1].c = 6;
    values[2].a = 7; values[2].b = 8; values[2].c = 9;

    if (values[0].c != 3) return 4;
    if (values[1].a != 4) return 5;
    if (values[1].c != 6) return 6;
    if (values[2].a != 7) return 7;
    if (check_pointer(values) != 0) return 8;
    if ((char *)(values + 1) - (char *)values != 3) return 9;
    return 0;
}
