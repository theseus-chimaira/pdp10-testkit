/* Native and continuous exact32 objects share a typed one-word pointer.
 * The packed field begins at bit 5; its elements cross word boundaries. */
typedef unsigned int u32 __attribute__((size (32)));
typedef signed int s32 __attribute__((size (32)));
struct rec { unsigned pre:5; u32 a[4]; s32 b[3]; unsigned post:4; } __attribute__((packed));
static struct rec rec;
static u32 words[4];
static s32 signed_words[3];
static u32 * volatile initial=&rec.a[1];
static u32 * volatile native_initial=&words[1];
volatile int fail_id, result, vi;
static u32 get(u32 *p) __attribute__((noinline));
static u32 get(u32 *p) { return *p; }
static void put(u32 *p,u32 x) __attribute__((noinline));
static void put(u32 *p,u32 x) { *p=x; }
static int check(u32 *p) __attribute__((noinline));
static int check(u32 *p) {
    u32 *q;
    int i,j;
    for(i=0;i<4;++i) put(p+i,012345670123U+i);
    for(i=0;i<4;++i) if(get(p+i)!=012345670123U+i) return 1;
    for(i=0;i<=4;++i) for(j=0;j<=4;++j) if((p+i)-(p+j)!=i-j || ((p+i)<(p+j))!=(i<j) || ((p+i)>=(p+j))!=(i>=j)) return 2;
    q=p+2; if(*q--!=012345670125U || q!=p+1) return 3;
    if(*++q!=012345670125U) return 4;
    *q=037777777777U; if(++*q!=0 || *q!=0) return 5;
    return 0;
}
static int check_signed(s32 *p) __attribute__((noinline));
static int check_signed(s32 *p) {
    p[0]=-1; p[1]=-020000000000; p[2]=020000000000-1;
    return p[0]==-1 && p[1]==-020000000000 && p[2]==020000000000-1;
}
static u32 *member(struct rec *p, int i) __attribute__((noinline));
static u32 *member(struct rec *p,int i) { return &p->a[i]; }
int main(void) {
    struct rec local;
    u32 *p;
    int r;
    rec.pre=021; rec.post=013;
    fail_id=1; put(initial,123); if(rec.a[1]!=123) return 1;
    fail_id=2; put(native_initial,234); if(words[1]!=234) return 2;
    fail_id=3; r=check(rec.a); if(r) return 10+r;
    fail_id=4; r=check(words); if(r) return 20+r;
    fail_id=5; if(!check_signed(rec.b)) return 5;
    fail_id=6; if(!check_signed(signed_words)) return 6;
    fail_id=7; if(rec.pre!=021 || rec.post!=013 || rec.a[0]!=012345670123U || rec.a[1]!=012345670124U || rec.a[2]!=0 || rec.a[3]!=012345670126U) return 7;
    fail_id=8; local.pre=031; local.post=07; vi=2;
    put(&local.a[vi],4321); p=member(&local,vi);
    if(p!=&local.a[2] || get(p)!=4321 || local.pre!=031 || local.post!=07) return 8;
    put(member(&rec,vi),54321);
    if(rec.a[2]!=54321 || get(&rec.a[vi])!=54321 || rec.pre!=021 || rec.post!=013) return 9;
    fail_id=0; result=765; return 0;
}
