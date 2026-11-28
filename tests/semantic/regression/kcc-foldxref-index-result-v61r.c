/* An indexed address may reuse a previous input AC. The following store
 * must still use the computed address, not the rewritten input index. */
static unsigned a[0105];
static volatile unsigned index_value = 0100;
static volatile unsigned predicate = 1;
static volatile unsigned calls;

static unsigned source(unsigned i, unsigned v)
{
    ++calls;
    return i ^ v;
}

static void clear_pair(unsigned i, unsigned v)
{
    a[i+1] = v ? 1 : 0;
    a[i+2] = 0;
}

static void fill_pair(unsigned i, unsigned v)
{
    a[i+1] = v ? 1 : 0;
    a[i+2] = ~0U;
}

static void clear_after_call(unsigned i, unsigned v)
{
    a[i] = source(i,v);
    a[i+1] = v ? 1 : 0;
    a[i+2] = 0;
}

int main(void)
{
    unsigned i = index_value;
    unsigned v = predicate;
    a[i] = 0123456701234UL;
    a[i+1] = 077;
    a[i+2] = 0765432107654UL;
    a[i+3] = 0123456;
    clear_pair(i,v);
    if (a[i] != 0123456701234UL || a[i+1] != 1 ||
        a[i+2] != 0 || a[i+3] != 0123456) return 1;
    predicate=0;
    fill_pair(i,predicate);
    if (a[i] != 0123456701234UL || a[i+1] != 0 ||
        a[i+2] != 0777777777777UL || a[i+3] != 0123456) return 2;
    predicate=7;
    clear_after_call(i,predicate);
    if (a[i] != (i ^ 7U) || a[i+1] != 1 || a[i+2] != 0 ||
        a[i+3] != 0123456 || calls != 1) return 3;
    return 0;
}
