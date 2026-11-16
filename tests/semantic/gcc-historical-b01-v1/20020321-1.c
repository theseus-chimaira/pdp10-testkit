/* GCC execute/20020321-1.c: sibling-call widened argument list. */
/* Exactly representable floating values avoid IEEE-only expectations. */
float __attribute__((noinline)) g(void *a, void *b, int e, int c, float d)
{
    (void)a;
    (void)b;
    (void)e;
    (void)c;
    return d;
}
float __attribute__((noinline)) f(void *a, void *b, int c, float d)
{
    return g(a, b, 0, c, d);
}
int main(void)
{
    if (f(0, 0, 1, 1.0f) != 1.0f)
        return 1;
    if (f(0, 0, 2, 2.0f) != 2.0f)
        return 2;
    return 0;
}
