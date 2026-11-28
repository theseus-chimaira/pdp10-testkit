/* Bounds discarded by array-to-pointer adjustment still run at entry.
 * Inner dimensions remain available for stride and sizeof. */
static volatile int calls;
static int bound(int n) { ++calls; return n; }
static int proto(int n, int a[bound(n++)]);
static int proto(int n, int a[bound(n++)])
{
    if (sizeof(a) != sizeof(int *)) return -1;
    return n + a[0];
}
static int rows(int n, int m, int a[bound(n++)][bound(m++)])
{
    if (sizeof(*a) != 3*sizeof(int)) return -2;
    return n*100+m*10+a[1][2];
}
static int pointer_row(int n, int (*p)[bound(n++)])
{
    if (sizeof(*p) != 3*sizeof(int)) return -3;
    return n+p[1][2];
}
int main(void)
{
    int a[2][3] = {{1,2,3},{4,5,6}};
    if (calls) return 1;
    if (proto(2,a[0]) != 4 || calls != 1) return 2;
    if (rows(2,3,a) != 346 || calls != 3) return 3;
    if (pointer_row(3,a) != 10 || calls != 4) return 4;
    if (proto(1,a[1]) != 6 || calls != 5) return 5;
    return 0;
}
