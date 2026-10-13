/* codegen-kcc-policy-only: yes */
/* KCC compiler-specific instruction assertions. */
/* codegen-require-regex: "(?ims)\\A(?:(?!^%DIDIV[0-9]+SUB:).)*^%DIDIV[0-9]+SUB:\\s*\\n(?:(?!^%DIDIV[0-9]+NS:|^\\s*(?:SETZ|MOVEI)\\s+).)*?^\\s*SUB\\s+[^\\n]*\\n(?:(?!^%DIDIV[0-9]+NS:|^\\s*(?:SETZ|MOVEI|SUBI)\\s+).)*?^\\s*SUBI\\s+[^\\n]*\\n(?:(?!^%DIDIV[0-9]+NS:|^\\s*(?:SETZ|MOVEI|SUBI)\\s+).)*?^\\s*SUB\\s+[^\\n]*\\n(?:(?!^%DIDIV[0-9]+NS:|^\\s*(?:SETZ|MOVEI|SUBI|SUB)\\s+).)*?^%DIDIV[0-9]+NS:(?:(?!^%DIDIV[0-9]+SUB:).)*^%DIDIV[0-9]+SUB:\\s*\\n(?:(?!^%DIDIV[0-9]+NS:|^\\s*(?:SETZ|MOVEI)\\s+).)*?^\\s*SUB\\s+[^\\n]*\\n(?:(?!^%DIDIV[0-9]+NS:|^\\s*(?:SETZ|MOVEI|SUBI)\\s+).)*?^\\s*SUBI\\s+[^\\n]*\\n(?:(?!^%DIDIV[0-9]+NS:|^\\s*(?:SETZ|MOVEI|SUBI)\\s+).)*?^\\s*SUB\\s+[^\\n]*\\n(?:(?!^%DIDIV[0-9]+NS:|^\\s*(?:SETZ|MOVEI|SUBI|SUB)\\s+).)*?^%DIDIV[0-9]+NS:" */
unsigned long long q(unsigned long long a, unsigned long long b) { return a / b; }
long long r(long long a, long long b) { return a % b; }
