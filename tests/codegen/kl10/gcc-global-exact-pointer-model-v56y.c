/* Experimental exact-width global pointer model, not a compiler ABI.
 * Keep the full 30-bit address and all 36 physical bit positions.
 * Tags 045/054 denote native 16-bit array slots. Tag 0 denotes a
 * native exact32 word slot. Tags 1..044 denote continuous bit streams.
 * The testkit supplies independent mathematical and memory oracles.
 */
typedef unsigned long word;
typedef signed long index_t;
#define ADDRESS 07777777777UL
#define SLOT16_0 045U
#define SLOT16_1 054U
#define TAG_SHIFT 30

extern word arithmetic_cases[];
extern word memory_cases[];
extern word arithmetic_count, memory_count;
extern word fields[4];
volatile word fail_id, result, checked;

static word address(word p) { return p & ADDRESS; }
static word tag(word p) { return p >> TAG_SHIFT; }
static word encode(word a, word t) { return (t << TAG_SHIFT) | a; }
static word mask(word n) { return ((word)1 << n) - 1; }
static int native16(word p, word width)
{
    return width == 16 && (tag(p) == SLOT16_0 || tag(p) == SLOT16_1);
}

/* Advance by an integral C element count. Avoid n*width overflow:
 * nine exact-width elements occupy precisely width/4 machine words.
 * Correct negative C remainders to floor division. Valid input and
 * result addresses are assumed, as for ordinary C pointer arithmetic. */
static word advance(word p, index_t n, word width)
{
    index_t q, r, a, b;
    a = (index_t)address(p);
    if (native16(p,width)) {
        b = n + (tag(p) == SLOT16_1);
        q = b / 2; r = b % 2;
        if (r < 0) { --q; r += 2; }
        return encode((word)(a+q),r ? SLOT16_1 : SLOT16_0);
    }
    if (width == 32 && tag(p) == 0)
        return (word)(a+n);
    q = n / 9; r = n % 9;
    b = (index_t)tag(p)-1 + r*(index_t)width;
    a += q*(index_t)(width/4) + b/36;
    b %= 36;
    if (b < 0) { --a; b += 36; }
    return encode((word)a,(word)(b+1));
}

/* Same-array differences. Divide by gcd(36,width) first so even
 * the full 30-bit word-coordinate distance fits a signed 36-bit word. */
static index_t difference(word p, word q, word width)
{
    index_t d = (index_t)address(p)-(index_t)address(q);
    if (native16(p,width))
        return 2*d + (tag(p)==SLOT16_1) - (tag(q)==SLOT16_1);
    if (width==32 && tag(p)==0)
        return d;
    return (9*d + ((index_t)tag(p)-(index_t)tag(q))/4)/(index_t)(width/4);
}

static word bitpos(word p, word width)
{
    if (native16(p,width)) return tag(p)==SLOT16_0 ? 0 : 16;
    return tag(p)-1;
}

/* A software pointer must be decoded before any effective-address
 * operation. Never feed its tag to LDB, DPB, ADJBP or a word index. */
static word read_field(word p, word width)
{
    word *a = (word *)address(p);
    word pos, first, rest;
    if (width==32 && tag(p)==0) return a[0]&mask(32);
    pos=bitpos(p,width); first=36-pos;
    if (width<=first) return (a[0]>>(first-width))&mask(width);
    rest=width-first;
    return ((a[0]&mask(first))<<rest) | (a[1]>>(36-rest));
}

static void write_field(word p, word width, word v)
{
    word *a=(word *)address(p);
    word pos, first, rest, m, s;
    v &= mask(width);
    if (width==32 && tag(p)==0) { a[0]=v; return; }
    pos=bitpos(p,width); first=36-pos;
    if (width<=first) {
        s=first-width; m=mask(width)<<s;
        a[0]=(a[0]&~m)|(v<<s);
    } else {
        rest=width-first; m=mask(first);
        a[0]=(a[0]&~m)|(v>>rest);
        s=36-rest; m=mask(rest)<<s;
        a[1]=(a[1]&~m)|((v&mask(rest))<<s);
    }
}

int main(void)
{
    word i, *c, p, q, w;
    for (i=0,c=arithmetic_cases;i<arithmetic_count;++i,c+=4) {
        fail_id=i+1; w=c[0]; p=c[1]; q=c[3];
        if (advance(p,(index_t)c[2],w)!=q) return 1;
        if (advance(q,-(index_t)c[2],w)!=p) return 2;
        if (difference(q,p,w)!=(index_t)c[2]) return 3;
        if (difference(p,q,w)!=-(index_t)c[2]) return 4;
        ++checked;
    }
    for (i=0,c=memory_cases;i<memory_count;++i,c+=8) {
        fail_id=arithmetic_count+i+1; w=c[0]; p=c[1];
        fields[0]=012345670123UL; fields[3]=076543210765UL;
        fields[1]=c[2]; fields[2]=c[3];
        if (read_field(p,w)!=c[4]) return 5;
        write_field(p,w,c[5]);
        if (fields[1]!=c[6] || fields[2]!=c[7]) return 6;
        if (read_field(p,w)!=(c[5]&mask(w))) return 7;
        if (fields[0]!=012345670123UL || fields[3]!=076543210765UL) return 8;
        ++checked;
    }
    fail_id=0; result=765; return 0;
}
