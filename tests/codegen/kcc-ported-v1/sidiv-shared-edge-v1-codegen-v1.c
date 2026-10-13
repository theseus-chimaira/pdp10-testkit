/* codegen-kcc-check: "sidiv-shared-edge-v1" */
volatile int __test_exit;
volatile int va,vb,vc,vd,ve,vf;
int f1(a,b) int a,b; { return a/b; }
int f2(a,b,c,d) int a,b,c,d; { return (a/b)+(c/d); }
int f3(a,b,c,d,e,f) int a,b,c,d,e,f; { return (a/b)+(c/d)+(e/f); }
int f4(a,b,c,d) int a,b,c,d; { return (a%b) + (c%d); }
int f5(a,b,c,d) int a,b,c,d; { int x=a/b; int y=c%d; return x-y; }
int main(void)
{
 int m=(-34359738367L-1L);
 va=m; vb=3; vc=m; vd=-3; ve=m; vf=5;
 if (f1(va,vb) != -11453246122L) return 1;
 if (f2(va,vb,vc,vd) != 0) return 2;
 if (f3(va,vb,vc,vd,ve,vf) != -6871947673L) return 3;
 if (f4(va,vb,ve,vf) != -5) return 4;
 if (f5(va,vb,ve,vf) != -11453246119L) return 5;
 return 0;
}
