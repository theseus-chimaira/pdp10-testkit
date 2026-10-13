/* KCC instruction regression, migrated to native matrix. */
/* codegen-require-regex: "%DIDIV" "(?ims)\\A(?:(?!^\\s*SETZ\\s+).)*^\\s*SETZ\\s+[^\\n]*\\n(?:(?!^\\s*SETZ\\s+).)*^\\s*SETZ\\s+[^\\n]*\\n(?:(?!^\\s*SETZ\\s+).)*^\\s*SETZ\\s+[^\\n]*\\n(?:(?!^\\s*SETZ\\s+).)*^\\s*SETZ\\s+[^\\n]*\\n(?:(?!^\\s*SETZ\\s+).)*^\\s*SETZ\\s+[^\\n]*\\n(?:(?!^\\s*SETZ\\s+).)*^\\s*SETZ\\s+[^\\n]*\\n(?:(?!^\\s*SETZ\\s+).)*\\Z" */
unsigned long long q(unsigned long long a, unsigned long long b) { return a / b; }
unsigned long long r(unsigned long long a, unsigned long long b) { return a % b; }
