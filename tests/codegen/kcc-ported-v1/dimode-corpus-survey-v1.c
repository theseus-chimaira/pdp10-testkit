/* codegen-kcc-check: "dimode-corpus-survey" */
/* codegen-kcc-policy-only: yes */
typedef long long D;
typedef unsigned long long U;
D da(D a,D b) { return a+b; }
D ds(D a,D b) { return a-b; }
D dm(D a,D b) { return a*b; }
D dd(D a,D b) { return a/b; }
D dr(D a,D b) { return a%b; }
U ud(U a,U b) { return a/b; }
U ur(U a,U b) { return a%b; }
D ba(D a,D b) { return a&b; }
D bo(D a,D b) { return a|b; }
D bx(D a,D b) { return a^b; }
D sl(D a,int n) { return a<<n; }
D sr(D a,int n) { return a>>n; }
U us(U a,int n) { return a>>n; }
int ce(D a,D b) { return a==b; }
int cl(D a,D b) { return a<b; }
int ul(U a,U b) { return a<b; }
D ld(D *p) { return *p; }
void st(D *p,D v) { *p=v; }
D call(D (*f)(D),D a) { return (*f)(a); }
D cv(int a) { return a; }
int ci(D a) { return (int)a; }
D mix(D a,D b,D c,D d,D e,D f) { return ((a+b)^(c|d))+(e*f); }
