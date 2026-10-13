/* codegen-kcc-policy-only: yes */
/* Original KCC assembly policies. */
/* codegen-require-regex: "(?ims)^mm:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movmm\\s+)" "(?ims)^ms_used:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movms\\s+)" "(?ims)^ms_discard:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movms\\s+)" "(?ims)^ptr_load:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+1,)" "(?ims)^ptr_mm:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movmm\\s+1,)" "(?ims)^ptr_ms:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movms\\s+)" */
/* codegen-forbid-regex: "(?ims)^mm:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^ms_used:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movem\\s+)" "(?ims)^ms_discard:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movem\\s+)" "(?ims)^no_mm_used:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movmm\\s+)" "(?ims)^no_volatile:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm[m|s]?\\s+)" "(?ims)^ptr_load:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skipl|jump|jrst)\\s+)" "(?ims)^ptr_mm:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*move\\s+[^\\n]*,1$)" "(?ims)^ptr_ms:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movem\\s+)" */
int a, b;
volatile int va;

void mm()
{
    b = a < 0 ? -a : a;
}

int ms_used()
{
    return (a = a < 0 ? -a : a);
}

void ms_discard()
{
    a = a < 0 ? -a : a;
}

void no_mm_used()
{
    a = (b = a < 0 ? -a : a);
}

void no_volatile()
{
    b = va < 0 ? -va : va;
}

int ptr_load(p)
int *p;
{
    return *p < 0 ? -*p : *p;
}

void ptr_mm(a, p)
int a;
int *p;
{
    *p = a < 0 ? -a : a;
}

int ptr_ms(p)
int *p;
{
    return (*p = *p < 0 ? -*p : *p);
}
