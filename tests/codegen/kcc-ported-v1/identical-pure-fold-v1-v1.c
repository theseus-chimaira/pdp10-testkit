/* codegen-kcc-policy-only: yes */
/* codegen-kcc-check: "identical-pure-fold-v1" */
extern int side(void);

int add_self(x) int x; { return x + x; }
int sub_self(x) int x; { return x - x; }
int and_self(x) int x; { return x & x; }
int or_self(x) int x; { return x | x; }
int xor_self(x) int x; { return x ^ x; }
int xor_calls(void) { return side() ^ side(); }
int xor_volatile(p) volatile int *p; { return *p ^ *p; }
