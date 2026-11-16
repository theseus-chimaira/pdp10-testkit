/* GCC execute/20011115-1.c: equality of function designators. */
/* The optimized dead branch must not pull in undefined_reference. */
static inline int foo(void)
{
#ifdef __OPTIMIZE__
    extern int undefined_reference;
    return undefined_reference;
#else
    return 0;
#endif
}
static inline int bar(void)
{
    if (foo == foo)
        return 1;
    return foo();
}
int main(void)
{
    return bar() != 1;
}
