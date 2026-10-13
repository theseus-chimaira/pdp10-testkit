/* codegen-kcc-policy-only: yes */
/* Original KCC assembly policies. */
/* codegen-require-regex: "(?ims)^dies:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:pushj\\s+17,sink)" "(?ims)^later:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:pushj\\s+17,sink)" "(?ims)^predies:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:pushj\\s+17,sink)" "(?ims)^lives:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+1[01],1\\s*$)" */
/* codegen-forbid-regex: "(?ims)^dies:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+1[01],1\\s*$)" "(?ims)^later:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+1[01],1\\s*$)" "(?ims)^predies:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:move\\s+1[01],1\\s*$)" */
extern int sink();

int dies(a, b)
int a, b;
{
    sink(a);
    return b + 1;
}

int later(a, b)
int a, b;
{
    b += 3;
    a ^= 1;
    sink(a);
    return b + 1;
}

int predies(a, b)
int a, b;
{
    a ^= 1;
    b += a;
    sink(b);
    return b + 1;
}

int lives(a, b)
int a, b;
{
    sink(a);
    return a + b;
}
