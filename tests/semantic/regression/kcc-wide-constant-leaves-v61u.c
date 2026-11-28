/* Narrowing a wide literal can retain its original high limb in a node
 * union slot. Neither ABI query marking nor scratch analysis may follow
 * this payload as a child pointer. */
static volatile unsigned int value = 0765432107654U;
static volatile unsigned int predicate = 1U;
static unsigned int mask(unsigned int x)
{
    return x & (unsigned int)0777777777777ULL;
}
static unsigned int query(unsigned int x, unsigned int y)
{
    return (x ? 1U : 0U) + (y & (unsigned int)0777777777777ULL);
}
struct pair { unsigned int hi, lo; };
static void normalize(struct pair *p)
{
    p->hi = (p->hi & 1) ? ((p->lo & (unsigned int)0400000000000ULL)
                           ? 1U : (unsigned int)0777777777777ULL) : 0U;
}
int main(void)
{
    unsigned int x = value;
    struct pair p;
    if (mask(x) != x) return 1;
    if (query(predicate,x) != x+1U) return 2;
    predicate = 0;
    if (query(predicate,x) != x) return 3;
    p.hi=1; p.lo=0;
    normalize(&p);
    if (p.hi != 0777777777777U) return 4;
    p.lo=0400000000000U;
    normalize(&p);
    if (p.hi != 1) return 5;
    p.hi=0;
    normalize(&p);
    if (p.hi != 0) return 6;
    return 0;
}
