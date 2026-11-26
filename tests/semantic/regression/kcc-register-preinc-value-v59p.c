/* Prefix update returns a value, not ownership of the variable's AC.
   Keep both the updated scalar and its derived address live. */
static int words[8];
static int *volatile address;
static volatile int scalar;
volatile unsigned fail_id;

static int index_update(int *p, register int i)
{
    address = &p[++i];
    return i;
}

static int index_decrement(int *p, register int i)
{
    address = &p[--i];
    return i;
}

static int pointer_update(register int *p)
{
    address = ++p + 2;
    return p == &words[1];
}

static int scalar_update(register int n)
{
    scalar = ++n * 7;
    return n;
}

int main(void)
{
    fail_id = 1;
    if (index_update(words, 2) != 3 || address != &words[3]) return 1;
    fail_id = 2;
    if (index_decrement(words, 5) != 4 || address != &words[4]) return 2;
    fail_id = 3;
    if (!pointer_update(words) || address != &words[3]) return 3;
    fail_id = 4;
    if (scalar_update(5) != 6 || scalar != 42) return 4;
    fail_id = 0;
    return 0;
}
