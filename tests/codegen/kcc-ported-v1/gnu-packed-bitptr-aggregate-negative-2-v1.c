/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "cannot\\ yet\\ escape\\ its\\ local\\ logical\\ pointer\\ representation" */
struct inner { unsigned char x; } __attribute__((packed));
struct outer { unsigned int pre:5; struct inner in; } __attribute__((packed));
static void sink(struct inner *p) { (void)p; }
struct inner *ret(struct outer *p) { return &p->in; }
void call(struct outer *p) { sink(&p->in); }
