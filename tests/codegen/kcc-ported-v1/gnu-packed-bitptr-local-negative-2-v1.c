/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "ordinary\\ pointer\\ cannot\\ replace\\ a\\ non\\-byte\\-aligned\\ GNU\\ packed\\ logical\\ pointer" */
typedef unsigned _KCCtype_char16 u16;
struct outer { unsigned int pre:5; u16 a[2]; } __attribute__((packed));
static u16 x;
void f(struct outer *p)
{
    u16 *q = p->a;
    q = &x;
}
