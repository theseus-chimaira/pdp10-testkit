/* Original KCC assembly policy, preserved. */
/* codegen-require-regex: "(?ims)\\A(?:(?!^\\s*movn\\s+).)*^\\s*movn\\s+[^\\n]*\\n(?:(?!^\\s*movn\\s+).)*^\\s*movn\\s+[^\\n]*\\n" "(?im)^\\s*skipe\\s+" "(?im)^\\s*subi\\s+" "(?im)^\\s*and\\s+" */
/* codegen-forbid-regex: "(?im)^\\s*(SETZ|JUMPE)\\s+1[,\\s]" */
typedef long long Dint;
Dint negate(a) Dint a; { return -a; }
