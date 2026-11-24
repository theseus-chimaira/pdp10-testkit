/* Explicit unsigned suffix typing and implicit GNU libc prototypes. */
static unsigned long maximum = ~0UL;
static unsigned long repeated = (~0UL / (unsigned char)~0) * ' ';
static char a[12], b[12];
static void copy_words(int *x, int *y, int n) { memcpy(x,y,n); }
static void clear_words(int *x,int n) { memset(x,0,n); }
int main(void)
{
    int i;
    if (!(~0UL > 0L) || !(~0LU > 0L) || !(~0ul > 0L)) return 1;
    if (maximum != 0777777777777UL || repeated != 040040040040UL) return 2;
    for (i=0;i<12;++i) b[i]=i+1;
    copy_words((int *)a,(int *)b,11);
    clear_words((int *)a,5);
    for (i=0;i<12;++i)
        if (a[i] != (i<5 || i==11 ? 0 : i+1)) return 3;
    return 0;
}
