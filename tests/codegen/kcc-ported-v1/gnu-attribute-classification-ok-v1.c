/* codegen-kcc-diagnostic-forbid-regex: "\[Internal error\]" */
struct P { char a; char b; } __attribute__((packed));
struct A { char a; char b __attribute__((aligned(2))); };
static int __attribute__((unused)) u;
static int __attribute__((deprecated)) d;
static int __attribute__((noinline)) f(void) { return sizeof(struct P) + sizeof(struct A) + u + d; }
int main(void) { return f() == 0; }
