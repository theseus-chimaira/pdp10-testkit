/* Architectural narrow byte arrays in nonzero sections. */
typedef signed int s6 __attribute__((size (6)));
typedef unsigned int u6 __attribute__((size (6)));
typedef signed int s7 __attribute__((size (7)));
typedef unsigned int u7 __attribute__((size (7)));
typedef signed int s8 __attribute__((size (8)));
typedef unsigned int u8 __attribute__((size (8)));
volatile int fail_id, result, vi;
static int words[4];
static int * volatile wordptr = words+1;
static int * volatile nullword;
#define DECL(W, S, U, N) \
static volatile S sa##W[19]; \
static volatile U ua##W[19]; \
static volatile S * volatile init##W = sa##W + N; \
static int diff##W(volatile S *p, volatile S *q) __attribute__((noinline)); \
static int diff##W(volatile S *p, volatile S *q) { return p-q; } \
static S *fromword##W(int *p) __attribute__((noinline)); \
static S *fromword##W(int *p) { return (S *)p; } \
static int *toword##W(S *p) __attribute__((noinline)); \
static int *toword##W(S *p) { return (int *)p; } \
static S * volatile constptr##W = (S *)(words+1); \
static int test##W(void) { \
    volatile S *p, *q; volatile U *r; int i,j; \
    for(i=0;i<19;++i) { sa##W[i]=i-10; ua##W[i]=(1<<W)-1-i; } \
    for(i=0;i<19;++i) { if(sa##W[i]!=i-10 || ua##W[i]!=(1<<W)-1-i) return 1; } \
    if(*init##W!=N-10) return 2; \
    vi=N; p=sa##W+vi; q=p; r=ua##W+vi; \
    if(*p++!=N-10 || *p!=N-9 || *--p!=N-10 || *r++!=(1<<W)-1-N || *r!=(1<<W)-2-N) return 3; \
    p+=3; if(*p!=N-7) return 4; p-=4; if(*p!=N-11 || diff##W(p,q)!=-1) return 5; \
    for(i=0;i<19;++i) for(j=0;j<19;++j) if(diff##W(sa##W+i,sa##W+j)!=i-j) return 6; \
    p=sa##W+19; if(diff##W(p,sa##W)!=19 || diff##W(sa##W,p)!=-19) return 7; \
    if(toword##W(fromword##W(wordptr))!=wordptr || fromword##W(wordptr)!=constptr##W) return 8; \
    if(fromword##W(nullword)!=0 || toword##W(fromword##W(nullword))!=0) return 9; \
    return 0; \
}
DECL(6,s6,u6,7)
DECL(7,s7,u7,6)
DECL(8,s8,u8,5)
int main(void) { int r; fail_id=6; r=test6(); if(r) return r; fail_id=7; r=test7(); if(r) return r; fail_id=8; r=test8(); if(r) return r; fail_id=0; result=765; return 0; }
