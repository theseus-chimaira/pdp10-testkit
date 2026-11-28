/* codegen-kcc-policy-only: yes */
int g(void)
{
    { extern int f(int); f(1); }
    { extern int f(); return f(1,2); }
}
