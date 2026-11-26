/* A user-defined internal function is not the GNU allocation builtin. */
static unsigned char data[8];
static volatile unsigned calls;
volatile unsigned fail_id;

static void *alloca(unsigned int n)
{
    ++calls;
    return &data[n];
}

int main(void)
{
    unsigned char *p;
    void *(*volatile f)(unsigned int) = alloca;
    fail_id = 1;
    p = alloca(2);
    if (p != &data[2] || calls != 1) return 1;
    *p = 123;
    fail_id = 2;
    p = f(3);
    if (p != &data[3] || calls != 2 || data[2] != 123) return 2;
    fail_id = 0;
    return 0;
}
