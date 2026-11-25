/* Native typed pointer operations through independently mapped words.
 * The oracle supplies valid architectural selectors and word addresses.
 * Synthetic high coordinates are used only in the arithmetic probes. */
typedef unsigned long word;
typedef signed long offset;
typedef unsigned int u6 __attribute__((size (6)));
typedef signed int s6 __attribute__((size (6)));
typedef unsigned int u7 __attribute__((size (7)));
typedef signed int s7 __attribute__((size (7)));
typedef unsigned int u8 __attribute__((size (8)));
typedef signed int s8 __attribute__((size (8)));
typedef unsigned char u9;
typedef signed char s9;
typedef unsigned short u18;
typedef signed short s18;
typedef unsigned long u36;
typedef signed long s36;
extern word arithmetic_cases[], arithmetic_count, memory_cases[], memory_count;
volatile word fail_id, checked, observed, expected, result;
static int verify(word a,word b) {
    if(a==b) return 1;
    observed=a; expected=b; return 0;
}
#define DECL(W,U,S) \
static int arith##W(U *p,U *q,offset n) __attribute__((noinline)); \
static int arith##W(U *p,U *q,offset n) { \
    U *r=p; int order=(n>0)-(n<0); \
    if(!verify((word)(p+n),(word)q)) return 1; \
    if(!verify((word)(q-n),(word)p)) return 2; \
    if(!verify(q-p,n) || !verify(p-q,-n)) return 3; \
    if(!verify((q>p)-(q<p),order)) return 4; \
    if(q<p) { if(order!=-1) return 5; } \
    else if(q>p) { if(order!=1) return 5; } \
    else if(order) return 5; \
    r+=n; if(!verify((word)r,(word)q)) return 6; \
    r-=n; if(!verify((word)r,(word)p)) return 7; \
    return 0; \
} \
static int memory##W(volatile U *p,volatile S *s,word *c) __attribute__((noinline)); \
static int memory##W(volatile U *p,volatile S *s,word *c) { \
    if(!verify(*p,c[4]) || !verify((offset)*s,c[5])) return 1; \
    *p=(U)c[6]; \
    if(!verify(*p,c[6])) return 2; \
    *s=(S)c[7]; \
    if(!verify((offset)*s,c[8]) || !verify(*p,c[7])) return 3; \
    return 0; \
} \
static int step##W(volatile U *p,volatile U *q,word a,word b) __attribute__((noinline)); \
static int step##W(volatile U *p,volatile U *q,word a,word b) { \
    if(!verify(*p++,a) || !verify((word)p,(word)q)) return 1; \
    if(!verify(*p--,b) || !verify(*p,a)) return 2; \
    if(!verify(*++p,b) || !verify(*--p,a)) return 3; \
    return 0; \
}
DECL(6,u6,s6)
DECL(7,u7,s7)
DECL(8,u8,s8)
DECL(9,u9,s9)
DECL(18,u18,s18)
DECL(36,u36,s36)
#define ARITH(W) case W: r=arith##W((u##W *)c[1],(u##W *)c[2],(offset)c[3]); break
#define MEMORY(W) case W: r=memory##W((volatile u##W *)c[1],(volatile s##W *)c[1],c); break
#define STEP(W) case W: r=step##W((volatile u##W *)c[1],(volatile u##W *)c[11],c[7],c[12]); break
int main(void) {
    word *c,i; int r; volatile word *a;
    for(i=0,c=arithmetic_cases;i<arithmetic_count;++i,c+=4) {
        fail_id=i+1;
        switch(c[0]) { ARITH(6); ARITH(7); ARITH(8); ARITH(9); ARITH(18); ARITH(36); default:return 99; }
        if(r) return r;
        ++checked;
    }
    for(i=0,c=memory_cases;i<memory_count;++i,c+=14) {
        fail_id=arithmetic_count+i+1; a=(volatile word *)c[2];
        *a=c[3];
        switch(c[0]) { MEMORY(6); MEMORY(7); MEMORY(8); MEMORY(9); MEMORY(18); MEMORY(36); default:return 99; }
        if(r) return 10+r;
        if(!verify(*a,c[9])) return 14;
        if(c[11]) {
            a[1]=c[10];
            switch(c[0]) { STEP(6); STEP(7); STEP(8); STEP(9); STEP(18); STEP(36); default:return 99; }
            if(r) return 20+r;
            if(!verify(a[1],c[10])) return 24;
        }
        if(!verify(a[-1],c[13])) return 25;
        ++checked;
    }
    fail_id=0; result=765; return 0;
}
