typedef unsigned u16 __attribute__((size (16)));
typedef signed s16 __attribute__((size (16)));
typedef unsigned u32 __attribute__((size (32)));
typedef signed s32 __attribute__((size (32)));
struct rec { unsigned pre:5; u16 a[3]; s16 b; u32 c[2]; s32 d; unsigned post:4; } __attribute__((packed));
static struct rec x;
volatile int fail_id, result;
volatile unsigned input;
int main(void) {
 fail_id=1; x.pre=021; x.post=013;
 input=012345; x.a[0]=input; input=054321; x.a[1]=input; input=065432; x.a[2]=input;
 if(x.a[0]!=012345 || x.a[1]!=054321 || x.a[2]!=065432) return 1;
 fail_id=2; x.b=-12345; if(x.b!=-12345) return 2;
 fail_id=3; input=037777777776U; x.c[0]=input; input=012345670123U; x.c[1]=input;
 if(x.c[0]!=037777777776U || x.c[1]!=012345670123U) return 3;
 fail_id=4; x.d=-020000000000; if(x.d!=-020000000000) return 4;
 fail_id=5; if(x.pre!=021 || x.post!=013 || x.a[1]!=054321 || x.b!=-12345 || x.c[1]!=012345670123U) return 5;
 fail_id=0; result=765; return 0;
}
