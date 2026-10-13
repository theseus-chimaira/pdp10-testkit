/* codegen-kcc-check: "scratch-member-elision" */
/* codegen-kcc-policy-only: yes */
typedef unsigned long word_t;

struct pair {
    word_t first;
    word_t last;
};

struct pair pair0;
struct pair pairs[2];

word_t member_delta(void)
{
    if (pair0.last < pair0.first)
        return 0;
    return (pair0.last - pair0.first) + 1UL;
}

word_t pointer_member_delta(struct pair *p)
{
    if (p->last < p->first)
        return 0;
    return (p->last - p->first) + 1UL;
}

struct pair *second_pair(void)
{
    return &pairs[1];
}

int stack_byte_postinc(char *p)
{
    char *q;
    int c;

    q = p;
    c = *q++;
    return c;
}

typedef int (*call_fn)(int);

int indirect_call(call_fn fn, int value)
{
    return (*fn)(value);
}

word_t unsigned_divide(word_t a, word_t b)
{
    return a / b;
}
