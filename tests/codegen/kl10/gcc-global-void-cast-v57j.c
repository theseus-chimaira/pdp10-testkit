/* Extended object pointer conversions, through real calls and storage. */
typedef unsigned int u16 __attribute__((size (16)));
typedef unsigned int u32 __attribute__((size (32)));
typedef unsigned char u6 __attribute__((size (6)));
typedef unsigned char u7 __attribute__((size (7)));
typedef unsigned char u8 __attribute__((size (8)));
struct rec { unsigned pre:5; u16 a[4]; u32 b[3]; unsigned post:4; } __attribute__((packed));
static struct rec rec;
static u16 native16[4], scalar16;
static u32 native32[4], scalar32;
static unsigned char bytes[4];
static unsigned short halves[4];
static unsigned long words[4];
static u6 six[6]; static u7 seven[5]; static u8 eight[4];
static void *volatile vp16=(void *)&rec.a[2];
static void *volatile vp32=(void *)&rec.b[1];
static void *volatile vp_native16=(void *)&native16[1];
static void *volatile vp_native32=(void *)&native32[1];
static void *volatile vp_byte=(void *)&bytes[2];
static void *volatile vp_half=(void *)&halves[1];
static void *volatile vp_word=(void *)&words[1];
volatile int fail_id,result;
static void *identity(void *p) __attribute__((noinline));
static void *identity(void *p) { void *volatile saved=p; return saved; }
static void *(*volatile call)(void *)=identity;
static int eq(void *a,void *b) __attribute__((noinline));
static int eq(void *a,void *b) { return a==b; }
static int neq(void *a,void *b) __attribute__((noinline));
static int neq(void *a,void *b) { if(a!=b) return 1; return 0; }
static u16 *back16(void *p) __attribute__((noinline));
static u16 *back16(void *p) { return (u16 *)p; }
static u32 *back32(void *p) __attribute__((noinline));
static u32 *back32(void *p) { return (u32 *)p; }
static unsigned char *back9(void *p) __attribute__((noinline));
static unsigned char *back9(void *p) { return (unsigned char *)p; }
static unsigned short *back18(void *p) __attribute__((noinline));
static unsigned short *back18(void *p) { return (unsigned short *)p; }
static unsigned long *back36(void *p) __attribute__((noinline));
static unsigned long *back36(void *p) { return (unsigned long *)p; }
static u32 *widen(u16 *p) __attribute__((noinline));
static u32 *widen(u16 *p) { return (u32 *)p; }
static u16 *narrow(u32 *p) __attribute__((noinline));
static u16 *narrow(u32 *p) { return (u16 *)p; }
int main(void) {
    int i;
    u16 *p16; u32 *p32;
    rec.pre=021; rec.post=013;
    scalar16=065432; scalar32=012345670123U;
    for(i=0;i<4;++i) {
        native16[i]=01234+i; native32[i]=012345670123U+i;
        bytes[i]=0400+i; halves[i]=0400000+i; words[i]=0400000000000UL+i;
    }
    for(i=0;i<4;++i) rec.a[i]=06543+i;
    for(i=0;i<3;++i) rec.b[i]=023456701234U+i;
    fail_id=1;
    if(back16(vp16)!=&rec.a[2] || *back16(vp16)!=06545) return 1;
    if(back32(vp32)!=&rec.b[1] || *back32(vp32)!=023456701235U) return 2;
    if(back16(vp_native16)!=&native16[1] || *back16(vp_native16)!=01235) return 3;
    if(back32(vp_native32)!=&native32[1] || *back32(vp_native32)!=012345670124U) return 4;
    if(back9(vp_byte)!=&bytes[2] || *back9(vp_byte)!=0402) return 5;
    if(back18(vp_half)!=&halves[1] || *back18(vp_half)!=0400001) return 6;
    if(back36(vp_word)!=&words[1] || *back36(vp_word)!=0400000000001UL) return 7;
    fail_id=2;
    for(i=0;i<4;++i) {
        p16=back16((*call)(native16+i));
        if(p16!=native16+i || *p16!=01234+i) return 8;
        p16=back16((*call)(rec.a+i));
        if(p16!=rec.a+i || *p16!=06543+i) return 9;
        p32=back32((*call)(native32+i));
        if(p32!=native32+i || *p32!=012345670123U+i) return 10;
        if(back9((*call)(bytes+i))!=bytes+i || back18((*call)(halves+i))!=halves+i || back36((*call)(words+i))!=words+i) return 11;
    }
    for(i=0;i<3;++i) if(back32((*call)(rec.b+i))!=rec.b+i || *back32((*call)(rec.b+i))!=023456701234U+i) return 12;
    fail_id=3;
    if(back16((*call)(&scalar16))!=&scalar16 || *back16((*call)(&scalar16))!=065432) return 13;
    if(back32((*call)(&scalar32))!=&scalar32 || *back32((*call)(&scalar32))!=012345670123U) return 14;
    if(back16((*call)(0)) || back32((*call)(0)) || back9((*call)(0)) || back18((*call)(0)) || back36((*call)(0))) return 15;
    fail_id=4;
    for(i=0;i<6;++i) if((u6 *)(*call)(six+i)!=six+i) return 16;
    for(i=0;i<5;++i) if((u7 *)(*call)(seven+i)!=seven+i) return 17;
    for(i=0;i<4;++i) if((u8 *)(*call)(eight+i)!=eight+i) return 18;
    fail_id=5;
    /* The standard C void/character carrier remains canonical. */
    if((unsigned long)vp_word!=(unsigned long)(unsigned char *)&words[1]
        || (unsigned long)vp_half!=(unsigned long)(unsigned char *)&halves[1]
        || (unsigned long)vp_native32!=(unsigned long)(unsigned char *)&native32[1]) return 26;
    if((unsigned long)(*call)(words)!=(unsigned long)(unsigned char *)words
        || (unsigned long)(*call)(halves+1)!=(unsigned long)(unsigned char *)(halves+1)
        || (unsigned long)(*call)(native32)!=(unsigned long)(unsigned char *)native32) return 27;
    if(!eq(words,(unsigned char *)words) || neq(words,(unsigned char *)words)) return 19;
    if(!eq(native16,(unsigned char *)native16) || neq(native16,(unsigned char *)native16)) return 20;
    if(eq(rec.a,rec.a+1) || !neq(rec.a,rec.a+1) || eq(rec.a,0)) return 21;
    fail_id=6;
    for(i=0;i<4;++i) if(narrow(widen(rec.a+i))!=rec.a+i) return 22;
    for(i=0;i<3;++i) if(widen(narrow(rec.b+i))!=rec.b+i) return 23;
    if(narrow(widen(native16))!=native16 || widen(narrow(native32))!=native32) return 24;
    if(rec.pre!=021 || rec.post!=013) return 25;
    fail_id=7;
    p16=rec.a; p32=rec.b;
    if(!eq((void *)p16++,rec.a) || p16!=rec.a+1) return 28;
    if(!eq((void *)p32++,rec.b) || p32!=rec.b+1) return 29;
    {
        unsigned char *c=bytes;
        void *volatile v=(void *)bytes;
        if((void *)c++!=v || c!=bytes+1) return 30;
        v=(void *)(halves+1);
        if(!eq(v,(void *)(unsigned char *)(halves+1))) return 31;
    }
    fail_id=0; result=765; return 0;
}
