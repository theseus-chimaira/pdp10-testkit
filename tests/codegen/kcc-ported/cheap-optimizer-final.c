/* codegen-kcc-policy-only: yes */
/* codegen-kcc-check: "cheap-optimizer-final" */
int eqc(x) int x; { return x == 7; }
int nec(x) int x; { return x != 7; }
int ltc(x) int x; { return x < 7; }
int csub(x) int x; { return 7 - x; }
int idx1(p,i) int *p; int i; { return p[i + 1]; }
int idx3(p,i) int *p; int i; { return p[i + 3]; }
int asgn(p,x) int *p; int x; { return (*p = x); }
int asadd(p,x) int *p; int x; { return (*p = x + 1); }
int casadd(p,x) int *p; int x; { return (*p += x); }
int casand(p,x) int *p; int x; { return (*p &= x); }
int casor(p,x) int *p; int x; { return (*p |= x); }
int casxor(p,x) int *p; int x; { return (*p ^= x); }
int dupidx(p,i) int *p; int i; { return p[i] + p[i]; }
int dupand(p,i) int *p; int i; { return p[i] & p[i]; }
int dupor(p,i) int *p; int i; { return p[i] | p[i]; }
signed char ret_sc(x) int x; { return (signed char) x; }
int cmp_sc(x) int x; { signed char y; y = ret_sc(x); return y == (signed char) x; }
