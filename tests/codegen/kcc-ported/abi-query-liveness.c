/* codegen-kcc-policy-only: yes */
/* Original KCC assembly policies. */
/* codegen-forbid-regex: "(?ims)^safe_max:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:push[^\\n]*,10)" "(?ims)^unsafe_after:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:push[^\\n]*,10)" "(?ims)^ac2_safe:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:push[^\\n]*,10)" "(?ims)^ac2_safe:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:push[^\\n]*,11)" "(?ims)^unsafe_after:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movei\\s+1,[12])" */
static int safe_max(x, y)
int x;
int y;
{
    return x > y ? x : y;
}

static int unsafe_after(x, q)
int x;
int q;
{
    return (q ? 1 : 2) + x;
}

static int ac2_safe(q, x)
int q;
int x;
{
    return (q ? 1 : 2) + x;
}
