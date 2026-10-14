/* codegen-kcc-check: "dimode-compare-registers" */
/* codegen-kcc-policy-only: yes */
typedef long long Dint;
typedef unsigned long long Uint;
int slt(a, b) Dint a, b; { return a < b; }
int sle(a, b) Dint a, b; { return a <= b; }
int ult(a, b) Uint a, b; { return a < b; }
int ule(a, b) Uint a, b; { return a <= b; }
