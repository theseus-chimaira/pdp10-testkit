/* codegen-kcc-policy-only: yes */
/* KCC DImode original assembly policy. */
/* codegen-require-regex: "(?ims)^addmul71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:MUL)" "(?ims)^muladd71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:MUL)" */
/* codegen-forbid-regex: "(?ims)^addmul71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:MOVE\\s+3,2\\s*$)" "(?ims)^addmul71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:MOVE\\s+4,3\\s*$)" "(?ims)^addmul71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movem.*-1\\(17\\))" "(?ims)^muladd71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movem.*-1\\(17\\))" */
long long addmul71(long long a, long long b)
{
    return (a + b) * 3LL;
}
long long muladd71(long long a, long long b)
{
    return (a * b) + 1LL;
}
