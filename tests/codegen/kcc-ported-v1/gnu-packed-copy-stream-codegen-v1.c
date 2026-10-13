/* KCC source and original assembly policies. */
/* codegen-require-regex: "(?im)^\\s*ibp\\s+" */
/* codegen-forbid-regex: "%ADJBPH" */
typedef unsigned _KCCtype_char16 u16;
struct p {
        unsigned char a, b, c;
        u16 d;
        unsigned char e;
} __attribute__((packed));
static struct p x[2];
struct inner {
        u16 x;
        unsigned int y:5;
        unsigned char z;
} __attribute__((packed));
struct outer {
        unsigned int pre:5;
        struct inner in;
        unsigned int post:6;
} __attribute__((packed));
static struct outer o[2];
void f(void)
{
        x[1] = x[0];
        o[1].in = o[0].in;
}
