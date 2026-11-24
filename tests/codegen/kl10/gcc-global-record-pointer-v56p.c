/* Native record subobjects and signed pointer differences in sectioned C.
 * Dynamic indices, byte positions and side effects must survive lowering. */
struct item { char op; unsigned char ix; char data[9]; };
struct pair { int tag; short data[5]; };
static struct item items[5];
static struct pair pairs[4];
volatile int fail_id;
volatile int vi, vj, calls;
volatile int result;

static char *byte_at(struct item *p, int j) __attribute__((noinline));
static char *byte_at(struct item *p, int j) { return &p->data[j]; }
static short *half_at(struct pair *p, int j) __attribute__((noinline));
static short *half_at(struct pair *p, int j) { return &p->data[j]; }
static int next(int x) __attribute__((noinline));
static int next(int x) { ++calls; return x; }

int main(void)
{
    struct item local[2];
    struct pair lp[2];
    char *p, *q;
    short *h, *k;
    int i,j;
    fail_id=1;
    for(i=0;i<5;++i) {
        items[i].op=i+1;
        items[i].ix=i+2;
        for(j=0;j<9;++j) items[i].data[j]=10+i*10+j;
    }
    for(i=0;i<5;++i) {
        if(items[i].op!=i+1 || items[i].ix!=i+2) return 1;
        for(j=0;j<9;++j) if(items[i].data[j]!=10+i*10+j) return 1;
    }
    fail_id=2;
    vi=3; vj=5;
    p=byte_at(&items[vi],vj); q=byte_at(&items[vi],1);
    if(*p!=45 || *q!=41 || p-q!=4 || q-p!=-4) return 2;
    for(i=0;i<9;++i) for(j=0;j<9;++j) {
        p=byte_at(&items[vi],i); q=byte_at(&items[vi],j);
        if(p-q!=i-j) return 2;
    }
    fail_id=3;
    for(i=0;i<4;++i) for(j=0;j<5;++j) pairs[i].data[j]=100+i*10+j;
    for(i=0;i<5;++i) for(j=0;j<5;++j) {
        h=half_at(&pairs[vi],i); k=half_at(&pairs[vi],j);
        if(*h!=130+i || h-k!=i-j) return 3;
    }
    fail_id=4;
    calls=0;
    items[next(vi)].data[next(vj)]=77;
    if(calls!=2 || items[3].data[5]!=77) return 4;
    fail_id=5;
    vi=1; vj=4;
    local[vi].data[vj]=55;
    lp[vi].data[vj]=321;
    p=byte_at(&local[vi],vj); h=half_at(&lp[vi],vj);
    if(*p!=55 || *h!=321) return 5;
    if(p-byte_at(&local[vi],0)!=4 || h-half_at(&lp[vi],0)!=4) return 5;
    fail_id=0; result=765;
    return 0;
}
