/* A real assembly caller verifies saved ACs and SP on every exit. */
/* Only an actual tail transfer must restore the outer caller's ACs
 * before entry. An ordinary nested call may use its own saved registers. */
#ifdef INDUCTION_NOOPT
#define ind_tail_target ind_call_target
#endif
extern int ind_tail_target(int);
int ind_return(int x)
{
    int i, a[8];
    for (i = 0; i < 8; ++i)
        a[i] = i & 1 ? x : x + i;
    return a[6];
}
int ind_tail(int x)
{
    int i, a[8];
    for (i = 0; i < 8; ++i)
        a[i] = i & 1 ? x : x + i;
    return ind_tail_target(a[7]);
}
int ind_vla(int n)
{
    int dyn[n], a[8], i, sum = 0;
    dyn[0] = 17;
    dyn[n-1] = 29;
    for (i = 0; i < 8; ++i) {
        a[i] = i < n ? dyn[0] + i : dyn[n-1];
        sum += a[i];
    }
    return sum;
}
