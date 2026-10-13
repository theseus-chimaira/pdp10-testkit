/* codegen-kcc-check: "gnu-packed-internal-stream" */
typedef unsigned _KCCtype_char16 u16;
struct S {
    unsigned int pre:5;
    u16 x;
    unsigned int post:3;
} __attribute__((packed));
struct B {
    unsigned int a:5;
    unsigned int b:16;
    unsigned int c:7;
} __attribute__((packed));
static struct S s;
static struct B b;
u16 rds(void) { return s.x; }
void wrs(u16 x) { s.x = x; }
unsigned rdb(void) { return b.b; }
void wrb(unsigned x) { b.b = x; }
