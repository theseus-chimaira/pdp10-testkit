/* Unsupported hardware hints still require valid GNU operands. */
void invalid_prefetch(int *p, int rw)
{
    __builtin_prefetch();
    __builtin_prefetch(7);
    __builtin_prefetch(p, rw, 0);
    __builtin_prefetch(p, 0, rw);
    __builtin_prefetch(p, 0, 0, 0);
}
