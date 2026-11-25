/* Real typed field accesses across sparse-mapped KL10B sections.
 * The host oracle supplies raw words and expected adjacent-bit values.
 * Volatile lvalues make every actual access observable to the emulators. */
typedef unsigned long word;
typedef signed long index_t;
typedef unsigned int u16 __attribute__((size (16)));
typedef signed int s16 __attribute__((size (16)));
typedef unsigned int u32 __attribute__((size (32)));
typedef signed int s32 __attribute__((size (32)));
extern word memory_cases[], memory_count, guard_cases[], guard_count;
volatile word fail_id, result, checked, observed, expected;

static word get16(volatile u16 *p) __attribute__((noinline));
static word get16(volatile u16 *p) { return *p; }
static word get32(volatile u32 *p) __attribute__((noinline));
static word get32(volatile u32 *p) { return *p; }
static word gets16(volatile s16 *p) __attribute__((noinline));
static word gets16(volatile s16 *p) { return (index_t)*p; }
static word gets32(volatile s32 *p) __attribute__((noinline));
static word gets32(volatile s32 *p) { return (index_t)*p; }
static void put16(volatile u16 *p,u16 v) __attribute__((noinline));
static void put16(volatile u16 *p,u16 v) { *p=v; }
static void put32(volatile u32 *p,u32 v) __attribute__((noinline));
static void put32(volatile u32 *p,u32 v) { *p=v; }
static void puts16(volatile s16 *p,s16 v) __attribute__((noinline));
static void puts16(volatile s16 *p,s16 v) { *p=v; }
static void puts32(volatile s32 *p,s32 v) __attribute__((noinline));
static void puts32(volatile s32 *p,s32 v) { *p=v; }

static int verify(word a,word b) {
    if(a==b) return 1;
    observed=a; expected=b; return 0;
}
int main(void) {
    word *c,i,p,w,sgn;
    volatile word *a;
    for(i=0,c=memory_cases;i<memory_count;++i,c+=12) {
        fail_id=i+1; w=c[0]; p=c[1]; a=(volatile word *)c[2]; sgn=c[3];
        a[0]=c[4]; a[1]=c[5];
        if(w==16) {
            if(!verify(sgn?gets16((volatile s16 *)p):get16((volatile u16 *)p),c[6])) return 1;
            if(sgn) puts16((volatile s16 *)p,(s16)c[7]);
            else put16((volatile u16 *)p,(u16)c[7]);
            if(!verify(sgn?gets16((volatile s16 *)p):get16((volatile u16 *)p),c[8])) return 2;
        } else {
            if(!verify(sgn?gets32((volatile s32 *)p):get32((volatile u32 *)p),c[6])) return 3;
            if(sgn) puts32((volatile s32 *)p,(s32)c[7]);
            else put32((volatile u32 *)p,(u32)c[7]);
            if(!verify(sgn?gets32((volatile s32 *)p):get32((volatile u32 *)p),c[8])) return 4;
        }
        if(!verify(a[0],c[9]) || !verify(a[1],c[10])) return 5;
        if(!verify(a[-1],c[11]) || !verify(a[2],c[11])) return 6;
        ++checked;
    }
    /* The following section has no page table. A non-crossing field
       must not access a[1], even as a speculative load or store. */
    for(i=0,c=guard_cases;i<guard_count;++i,c+=12) {
        fail_id=memory_count+i+1; w=c[0]; p=c[1]; a=(volatile word *)c[2]; sgn=c[3];
        a[0]=c[4];
        if(w==16) {
            if(!verify(sgn?gets16((volatile s16 *)p):get16((volatile u16 *)p),c[6])) return 7;
            if(sgn) puts16((volatile s16 *)p,(s16)c[7]);
            else put16((volatile u16 *)p,(u16)c[7]);
            if(!verify(sgn?gets16((volatile s16 *)p):get16((volatile u16 *)p),c[8])) return 8;
        } else {
            if(!verify(sgn?gets32((volatile s32 *)p):get32((volatile u32 *)p),c[6])) return 9;
            if(sgn) puts32((volatile s32 *)p,(s32)c[7]);
            else put32((volatile u32 *)p,(u32)c[7]);
            if(!verify(sgn?gets32((volatile s32 *)p):get32((volatile u32 *)p),c[8])) return 10;
        }
        if(!verify(a[0],c[9]) || !verify(a[-1],c[11])) return 11;
        ++checked;
    }
    fail_id=0; result=765; return 0;
}
