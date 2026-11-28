/* codegen-kcc-policy-only: yes */
extern int f();
int g(void) { { extern int f(int); } return f(1,2); }
