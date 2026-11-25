/* Exercise compiler-generated typed operations, not the integer model.
 * Integer-forged pointers are target ABI probes. The host chooses valid
 * coordinates on a single conceptual array, without dereferencing them. */
typedef unsigned long word;
typedef signed long index_t;
typedef unsigned int u16 __attribute__((size (16)));
typedef unsigned int u32 __attribute__((size (32)));
extern word arithmetic_cases[], arithmetic_count;
volatile word fail_id, result, checked, observed, expected;

/* Separate parameters prevent the front end folding same-base offsets. */
static u16 *add16(u16 *p, index_t n) __attribute__((noinline));
static u16 *add16(u16 *p, index_t n) { return p+n; }
static u32 *add32(u32 *p, index_t n) __attribute__((noinline));
static u32 *add32(u32 *p, index_t n) { return p+n; }
static u16 *sub16(u16 *p, index_t n) __attribute__((noinline));
static u16 *sub16(u16 *p, index_t n) { return p-n; }
static u32 *sub32(u32 *p, index_t n) __attribute__((noinline));
static u32 *sub32(u32 *p, index_t n) { return p-n; }
static index_t diff16(u16 *p,u16 *q) __attribute__((noinline));
static index_t diff16(u16 *p,u16 *q) { return p-q; }
static index_t diff32(u32 *p,u32 *q) __attribute__((noinline));
static index_t diff32(u32 *p,u32 *q) { return p-q; }
static int order16(u16 *p,u16 *q) __attribute__((noinline));
static int order16(u16 *p,u16 *q) { return (p>q)-(p<q); }
static int order32(u32 *p,u32 *q) __attribute__((noinline));
static int order32(u32 *p,u32 *q) { return (p>q)-(p<q); }
static int branch16(u16 *p,u16 *q) __attribute__((noinline));
static int branch16(u16 *p,u16 *q) { if(p<q) return -1; if(p>q) return 1; return 0; }
static int branch32(u32 *p,u32 *q) __attribute__((noinline));
static int branch32(u32 *p,u32 *q) { if(p<q) return -1; if(p>q) return 1; return 0; }

static int verify(word a,word b) {
    if(a==b) return 1;
    observed=a; expected=b; return 0;
}
int main(void) {
    word *c,i,p,q; index_t n; int sign;
    for(i=0,c=arithmetic_cases;i<arithmetic_count;++i,c+=4) {
        fail_id=i+1; p=c[1]; n=(index_t)c[2]; q=c[3];
        sign=(n>0)-(n<0);
        if(c[0]==16) {
            if(!verify((word)add16((u16 *)p,n),q)) return 1;
            if(!verify((word)add16((u16 *)q,-n),p)) return 2;
            if(!verify((word)sub16((u16 *)q,n),p)) return 3;
            if(!verify(diff16((u16 *)q,(u16 *)p),n)) return 4;
            if(!verify(diff16((u16 *)p,(u16 *)q),-n)) return 5;
            if(!verify(order16((u16 *)q,(u16 *)p),sign)) return 6;
            if(!verify(branch16((u16 *)q,(u16 *)p),sign)) return 7;
        } else {
            if(!verify((word)add32((u32 *)p,n),q)) return 11;
            if(!verify((word)add32((u32 *)q,-n),p)) return 12;
            if(!verify((word)sub32((u32 *)q,n),p)) return 13;
            if(!verify(diff32((u32 *)q,(u32 *)p),n)) return 14;
            if(!verify(diff32((u32 *)p,(u32 *)q),-n)) return 15;
            if(!verify(order32((u32 *)q,(u32 *)p),sign)) return 16;
            if(!verify(branch32((u32 *)q,(u32 *)p),sign)) return 17;
        }
        ++checked;
    }
    fail_id=0; result=765; return 0;
}
