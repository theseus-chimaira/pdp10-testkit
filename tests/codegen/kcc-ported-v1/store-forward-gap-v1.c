/* codegen-kcc-policy-only: yes */
/* Original KCC assembly requirements. */
/* codegen-require-regex: "(?ims)^safe_gap:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movem\\s+[0-7]+,0\\(1\\))" "(?ims)^memory_barrier:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+1,0\\(1\\))" "(?ims)^call_barrier:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+[0-7]+,0\\([0-7]+\\))" "(?ims)^volatile_barrier:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+[0-7]+,0\\([0-7]+\\))" */
/* codegen-forbid-regex: "(?ims)^safe_gap:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+1,0\\(1\\))" */
extern void side(void);
volatile int vg;
int gh;

int safe_gap(int *p, int x, int y)
{
    *p = x;
    y += 3;
    return *p + y;
}

int memory_barrier(int *p, int x)
{
    *p = x;
    gh = 3;
    return *p;
}

int call_barrier(int *p, int x)
{
    *p = x;
    side();
    return *p;
}

int volatile_barrier(volatile int *p, int x)
{
    *p = x;
    return *p;
}
