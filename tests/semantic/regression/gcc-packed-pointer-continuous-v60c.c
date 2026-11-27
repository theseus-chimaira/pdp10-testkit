/* Probe continuous record pointers at nonzero byte positions. */
struct rec {
    unsigned char lead;
    int *p[2];
    unsigned short tail;
} __attribute__((packed));
static struct rec r[3];
static int a,b;
static volatile unsigned idx=1;
volatile unsigned fail_id;
static void store(struct rec *p, unsigned i, int *v)
    __attribute__((noinline));
static void store(struct rec *p, unsigned i, int *v) { p->p[i]=v; }
static int *load(struct rec *p, unsigned i)
    __attribute__((noinline));
static int *load(struct rec *p, unsigned i) { return p->p[i]; }
int main(void)
{
    unsigned i=idx;
    a=012345;
    b=054321;
    r[i].lead=0123;
    r[i].tail=02345;
    r[i].p[0]=&a;
    r[i].p[i]=&b;
    fail_id=1;
    if(r[i].p[i]!=&b || r[i].p[0]!=&a) return 1;
    fail_id=2;
    store(&r[i],i,&a);
    if(load(&r[i],i)!=&a || r[i].p[i]!=&a) return 2;
    fail_id=3;
    if(r[i].lead!=0123 || r[i].tail!=02345) return 3;
    fail_id=0;
    return 0;
}
