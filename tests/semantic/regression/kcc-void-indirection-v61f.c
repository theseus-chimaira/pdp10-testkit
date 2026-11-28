/* GNU void indirection has no object value. Its pointer expression
** must nevertheless be evaluated exactly once in the selected branch.
*/
static int object;
static volatile int calls;
static void *volatile saved = &object;

static void *produce(int n)
{
    calls = calls * 10 + n;
    return &object;
}

static volatile void *qualified(int n)
{
    return produce(n);
}

static void finish(void)
{
    return *produce(6);
}

int main(void)
{
    void *p = &object;
    const void *cp = p;
    volatile void *vp = p;

    *p;
    *cp;
    *vp;
    *saved;
    *produce(1);
    if (calls != 1)
        return 1;
    calls == 1 ? *qualified(2) : *produce(9);
    calls == 0 ? *produce(9) : *qualified(3);
    (*produce(4), *produce(5));
    finish();
    if (calls != 123456)
        return 2;
    if (&*p != p || &*cp != cp || &*vp != vp)
        return 3;
    if (&*produce(7) != p || calls != 1234567)
        return 4;
    if (sizeof(*produce(8)) != 1 || sizeof(void) != 1)
        return 5;
    if (calls != 1234567)
        return 6;
    return 0;
}
