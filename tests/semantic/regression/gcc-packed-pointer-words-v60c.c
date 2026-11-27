/* Packed pointer values are full machine words even when their storage
 * spans two physical words. Independently verify the containing words,
 * dynamic indexing, neighboring fields and function pointer calls.
 */
struct record {
    unsigned short prefix __attribute__((packed, aligned(2)));
    short *ptr[2] __attribute__((packed, aligned(2)));
    unsigned short suffix __attribute__((packed, aligned(2)));
};
union storage {
    struct record r;
    unsigned long raw[3];
};
union pointer_word {
    short *p;
    unsigned long word;
};
static union storage data[3];
static short a, b;
static volatile unsigned int index_value=1;
volatile unsigned int fail_id;

static int check(union storage *p, unsigned long a0, unsigned long a1)
{
    return p->raw[0] == ((012345UL << 18) | (a0 >> 18))
        && p->raw[1] == (((a0 & 0777777UL) << 18) | (a1 >> 18))
        && p->raw[2] == (((a1 & 0777777UL) << 18) | 054321UL);
}

static int target(int x) { return x+7; }
static struct callbacks {
    unsigned short prefix __attribute__((packed, aligned(2)));
    int (*fn[2])(int) __attribute__((packed, aligned(2)));
    unsigned short suffix __attribute__((packed, aligned(2)));
} callbacks;

int main(void)
{
    union storage local;
    union pointer_word pa,pb;
    unsigned int i=index_value,j,k;
    short *p;
    a=0123;
    b=-04321;
    pa.p=&a;
    pb.p=&b;
    fail_id=1;
    if(sizeof(local)!=12) return 1;
    local.r.prefix=012345;
    local.r.suffix=054321;
    local.r.ptr[0]=&a;
    local.r.ptr[i]=&b;
    if(!check(&local,pa.word,pb.word)) return 1;
    fail_id=2;
    if(local.r.ptr[i]!=&b || *local.r.ptr[i]!=-04321 ||
       local.r.ptr[0]!=&a || *local.r.ptr[0]!=0123) return 2;
    for(j=0;j<3;++j) {
        data[j].r.prefix=012345;
        data[j].r.suffix=054321;
        data[j].r.ptr[0]=&a;
        data[j].r.ptr[i]=&b;
    }
    fail_id=3;
    for(j=0;j<3;++j)
        if(!check(&data[j],pa.word,pb.word) ||
           data[j].r.ptr[i]!=&b) return 3;
    fail_id=4;
    k=0;
    p=(data[i].r.ptr[k++]=&b);
    if(k!=1 || p!=&b || !check(&data[i],pb.word,pb.word) ||
       !check(&data[0],pa.word,pb.word) ||
       !check(&data[2],pa.word,pb.word)) return 4;
    fail_id=5;
    data[i].r.ptr[i]=0;
    if(data[i].r.ptr[i]!=0 || !check(&data[i],pb.word,0)) return 5;
    fail_id=6;
    callbacks.prefix=012345;
    callbacks.suffix=054321;
    callbacks.fn[0]=target;
    callbacks.fn[i]=target;
    if(callbacks.fn[i](4)!=11 || callbacks.fn[0](8)!=15 ||
       callbacks.prefix!=012345 || callbacks.suffix!=054321) return 6;
    fail_id=0;
    return 0;
}
