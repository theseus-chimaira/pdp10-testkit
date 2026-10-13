/* codegen-kcc-policy-only: yes */
/* Preserves the original KCC assembly checks. */
/* codegen-require-regex: "(?ims)^shl71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:lshc)" "(?ims)^shr71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:ashc)" "(?ims)^ushr71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:lshc)" "(?ims)^reused71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:movem.*-1\\(17\\)|dmovem.*-1\\(17\\))" "(?ims)^called71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:pushj)" */
/* codegen-forbid-regex: "(?ims)^shl71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:push\\s+17,16|movem.*-1\\(17\\)|dmovem.*-1\\(17\\))" "(?ims)^shr71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:push\\s+17,16|movem.*-1\\(17\\)|dmovem.*-1\\(17\\))" "(?ims)^ushr71:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:push\\s+17,16|movem.*-1\\(17\\)|dmovem.*-1\\(17\\))" */
long long shl71(long long a, int n) { return a << n; }
long long shr71(long long a, int n) { return a >> n; }
unsigned long long ushr71(unsigned long long a, int n) { return a >> n; }
long long reused71(long long a, int n) { return (a << n) + a; }
extern void sink(void);
long long called71(long long a, int n) { sink(); return a << n; }
