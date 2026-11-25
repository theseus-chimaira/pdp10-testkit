/* Native and continuous exact16 objects share a typed one-word pointer.
 * The packed field begins at bit 5; its elements cross word boundaries. */
typedef unsigned int u16 __attribute__((size (16)));
typedef signed int s16 __attribute__((size (16)));
struct rec { unsigned pre:5; u16 a[4]; s16 b[3]; unsigned post:4; } __attribute__((packed));
static struct rec rec;
static u16 words[4];
static u16 scalar;
static u16 * volatile scalar_initial=&scalar;
static s16 signed_words[3];
static u16 * volatile initial=&rec.a[1];
static u16 * volatile native_initial=&words[1];
static u16 * volatile native_plus=&words[0]+3;
static u16 * volatile native_minus=&words[3]-2;
static u16 * volatile packed_plus=rec.a+3;
static u16 * volatile packed_minus=&rec.a[3]-2;
volatile int fail_id, result, vi;
static u16 get(u16 *p) __attribute__((noinline));
static u16 get(u16 *p) { return *p; }
static void put(u16 *p,u16 x) __attribute__((noinline));
static void put(u16 *p,u16 x) { *p=x; }
static int check(u16 *p) __attribute__((noinline));
static int check(u16 *p) {
    u16 *q;
    int i,j;
    for(i=0;i<4;++i) put(p+i,012345U+i);
    for(i=0;i<4;++i) if(get(p+i)!=012345U+i) return 1;
    for(i=0;i<=4;++i) for(j=0;j<=4;++j) if((p+i)-(p+j)!=i-j || ((p+i)<(p+j))!=(i<j) || ((p+i)>=(p+j))!=(i>=j)) return 2;
    q=p+2; if(*q--!=012347U || q!=p+1) return 3;
    if(*++q!=012347U) return 4;
    *q=0177777U; if(++*q!=0 || *q!=0) return 5;
    return 0;
}
static int check_signed(s16 *p) __attribute__((noinline));
static int check_signed(s16 *p) {
    p[0]=-1; p[1]=-0100000; p[2]=0100000-1;
    return p[0]==-1 && p[1]==-0100000 && p[2]==0100000-1;
}
static u16 *member(struct rec *p, int i) __attribute__((noinline));
static u16 *member(struct rec *p,int i) { return &p->a[i]; }
int main(void) {
    struct rec local;
    u16 *p;
    int r;
    rec.pre=021; rec.post=013;
    fail_id=1; put(initial,123); if(rec.a[1]!=123) return 1;
    fail_id=2; put(native_initial,234); if(words[1]!=234) return 2;
    fail_id=3; r=check(rec.a); if(r) return 10+r;
    fail_id=4; r=check(words); if(r) return 20+r;
    fail_id=5; if(!check_signed(rec.b)) return 5;
    fail_id=6; if(!check_signed(signed_words)) return 6;
    fail_id=7; if(rec.pre!=021 || rec.post!=013 || rec.a[0]!=012345U || rec.a[1]!=012346U || rec.a[2]!=0 || rec.a[3]!=012350U) return 7;
    fail_id=8; local.pre=031; local.post=07; vi=2;
    put(&local.a[vi],4321); p=member(&local,vi);
    if(p!=&local.a[2] || get(p)!=4321 || local.pre!=031 || local.post!=07) return 8;
    put(member(&rec,vi),54321);
    if(rec.a[2]!=54321 || get(&rec.a[vi])!=54321 || rec.pre!=021 || rec.post!=013) return 9;
    fail_id=10; put(scalar_initial,065432); if(scalar!=065432 || get(&scalar)!=065432) return 10;
    fail_id=11;
    if(native_plus!=&words[3] || native_minus!=&words[1]
        || packed_plus!=&rec.a[3] || packed_minus!=&rec.a[1]) return 11;
    if(get(native_plus)!=012350U || get(native_minus)!=012346U
        || get(packed_plus)!=012350U || get(packed_minus)!=012346U) return 12;
    fail_id=12; vi=-3;
    if(native_plus+vi!=&words[0] || packed_plus+vi!=&rec.a[0]) return 13;
    fail_id=0; result=765; return 0;
}
