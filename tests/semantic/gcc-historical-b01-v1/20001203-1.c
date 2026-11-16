/* GCC execute/20001203-1.c: aggregate automatic initializer. */
static volatile long observed;
static void foo(void)
{
    struct {
        long a;
        char b[1];
    } x = { 2, { 0 } };
    observed = x.a;
    if (x.b[0] != 0)
        observed = -1;
}
int main(void)
{
    foo();
    return observed != 2;
}
