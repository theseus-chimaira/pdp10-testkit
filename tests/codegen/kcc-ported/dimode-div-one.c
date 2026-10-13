/* codegen-kcc-policy-only: yes */
/* Migrated original KCC instruction assertions. */
/* codegen-require-regex: "(?ims)^sr:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*SETZ\\s+).)*^\\s*SETZ\\s+[^\\n]*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*SETZ\\s+).)*^\\s*SETZ\\s+[^\\n]*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*SETZ\\s+).)*(?=^[A-Za-z_][A-Za-z0-9_]*:|\\Z)" "(?ims)^ur:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*SETZ\\s+).)*^\\s*SETZ\\s+[^\\n]*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*SETZ\\s+).)*^\\s*SETZ\\s+[^\\n]*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:|^\\s*SETZ\\s+).)*(?=^[A-Za-z_][A-Za-z0-9_]*:|\\Z)" "(?ims)\\A(?:(?!^\\s*jrst\\s+(?:source|usource)$).)*^\\s*jrst\\s+(?:source|usource)$\\n(?:(?!^\\s*jrst\\s+(?:source|usource)$).)*^\\s*jrst\\s+(?:source|usource)$\\n(?:(?!^\\s*jrst\\s+(?:source|usource)$).)*\\Z" */
/* codegen-forbid-regex: "%DIDIV" "(?ims)^sq:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*SETZ\\s+)" "(?ims)^uq:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*SETZ\\s+)" */
extern long long source(void);
extern unsigned long long usource(void);
long long sq(long long x) { return x / 1; }
long long sr(long long x) { return x % 1; }
unsigned long long uq(unsigned long long x) { return x / 1U; }
unsigned long long ur(unsigned long long x) { return x % 1U; }
long long sideq(void) { return source() / 1; }
unsigned long long usideq(void) { return usource() / 1U; }
