/* KCC v32: emit only reachable static inline bodies and their dependencies.
 *
 * Non-reachable inline bodies may mention an intentionally missing
 * external symbol.  It must not enter the object file or link graph.
 * Actual function calls, transitive calls, mutual recursion, and an
 * address initializer must all retain the complete reachable closure.
 */

static inline int
deadchild_v32(void)
{
    extern volatile int missing_inline_provider_v32;
    return missing_inline_provider_v32;
}

static inline int
deadparent_v32(void)
{
    return deadchild_v32();
}

static inline int
leaf_v32(int x)
{
    return x * 3 + 1;
}

static inline int
middle_v32(int x)
{
    return leaf_v32(x) + 2;
}

static int (*entry_v32)(int) = middle_v32;

static inline int
external_leaf_v32(int x)
{
    extern void abort(void);
    if (x == -123)
        abort();
    return x + 4;
}

static inline int even_v32(int x);

static inline int
odd_v32(int x)
{
    if (x == 0)
        return 0;
    return even_v32(x - 1);
}

static inline int
even_v32(int x)
{
    if (x == 0)
        return 1;
    return odd_v32(x - 1);
}

int
main(void)
{
    if (entry_v32(5) != 18)
        return 1;
    if (middle_v32(4) != 15)
        return 2;
    if (even_v32(8) != 1 || odd_v32(7) != 1)
        return 3;
    if (even_v32(9) != 0 || odd_v32(8) != 0)
        return 4;
    if (deadparent_v32 != deadparent_v32)
        return 5;
    if (external_leaf_v32(5) != 9)
        return 6;
    return 0;
}
