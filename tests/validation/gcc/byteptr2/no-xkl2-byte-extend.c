typedef int short18 __attribute__ ((size (18)));

struct pair18
{
    int pad;
    short18 value[2];
};

short18
load18(struct pair18 *p, int i)
{
    return p->value[i & 1];
}
