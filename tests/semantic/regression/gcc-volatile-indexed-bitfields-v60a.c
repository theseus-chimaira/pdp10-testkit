/* Direct volatile record arrays: check raw physical storage independently,
 * signed and unsigned assignment values, and evaluated-once subscripts.
 * The named noinline functions also support exact access-count auditing.
 */
struct record {
    unsigned int high:8;
    signed int middle:5;
    unsigned int low:23;
    unsigned long guard;
};
static volatile struct record data[3];
static struct mixed {
    unsigned int prefix:8;
    volatile unsigned int half:16;
    unsigned int suffix:12;
} mixed[3];
static volatile unsigned int index_value=1;
static volatile unsigned long input=0377;
volatile unsigned int fail_id;

unsigned int volatile_store(unsigned int i, unsigned int v)
    __attribute__((noinline));
unsigned int volatile_store(unsigned int i, unsigned int v)
{
    return data[i].high=v;
}
int volatile_signed_store(unsigned int i, int v)
    __attribute__((noinline));
int volatile_signed_store(unsigned int i, int v)
{
    return data[i].middle=v;
}
unsigned int volatile_reads(unsigned int i)
    __attribute__((noinline));
unsigned int volatile_reads(unsigned int i)
{
    unsigned int a=data[i].high;
    unsigned int b=data[i].high;
    return a+b;
}
void volatile_discard(unsigned int i) __attribute__((noinline));
void volatile_discard(unsigned int i)
{
    (void)data[i].middle;
}
unsigned int volatile_update(unsigned int i, unsigned int v)
    __attribute__((noinline));
unsigned int volatile_update(unsigned int i, unsigned int v)
{
    return data[i].high+=v;
}
unsigned int volatile_middle16(unsigned int i, unsigned int v)
    __attribute__((noinline));
unsigned int volatile_middle16(unsigned int i, unsigned int v)
{
    mixed[i].half=v;
    return mixed[i].half;
}

int main(void)
{
    union { struct record r; unsigned long raw[2]; } snapshot;
    unsigned int i=index_value,j,k;
    const volatile unsigned char *src;
    unsigned char *dst=(unsigned char *)&snapshot;
    fail_id=1;
    data[0].high=012;
    data[2].high=034;
    data[i].high=0201;
    data[i].middle=-7;
    data[i].low=012345;
    data[i].guard=012345670;
    src=(const volatile unsigned char *)&data[i];
    for(j=0;j<sizeof(snapshot);++j) dst[j]=src[j];
    if(snapshot.raw[0]!=((0201UL<<28)|(031UL<<23)|012345UL) ||
       snapshot.raw[1]!=012345670UL) return 1;
    fail_id=2;
    if(volatile_store(i,input+2)!=1 || data[i].high!=1 ||
       volatile_signed_store(i,037)!=-1 || data[i].middle!=-1)
        return 2;
    fail_id=3;
    if(volatile_reads(i)!=2 || volatile_update(i,3)!=4 ||
       data[i].high!=4) return 3;
    volatile_discard(i);
    fail_id=4;
    k=i;
    if((data[k++].middle=-9)!=-9 || k!=i+1 ||
       data[i].middle!=-9) return 4;
    k=i;
    if((data[k++].low+=7)!=012354 || k!=i+1 ||
       data[i].low!=012354) return 4;
    fail_id=5;
    if(data[0].high!=012 || data[2].high!=034 ||
       data[i].guard!=012345670) return 5;
    fail_id=6;
    mixed[i].prefix=0123;
    mixed[i].suffix=04567;
    if(volatile_middle16(i,0123456)!=0123456 ||
       mixed[i].prefix!=0123 || mixed[i].suffix!=04567) return 6;
    fail_id=0;
    return 0;
}
