/* codegen-kcc-policy-only: yes */
/* Original KCC assembly policy, preserved. */
/* codegen-require-regex: "(?ims)\\A(?:(?!^\\s*skipn\\s+).)*^\\s*skipn\\s+[^\\n]*\\n(?:(?!^\\s*skipn\\s+).)*^\\s*skipn\\s+[^\\n]*\\n(?:(?!^\\s*skipn\\s+).)*^\\s*skipn\\s+[^\\n]*\\n(?:(?!^\\s*skipn\\s+).)*^\\s*skipn\\s+[^\\n]*\\n(?:(?!^\\s*skipn\\s+).)*^\\s*skipn\\s+[^\\n]*\\n(?:(?!^\\s*skipn\\s+).)*^\\s*skipn\\s+[^\\n]*\\n" "(?ims)\\A(?:(?!^\\s*skipe\\s+).)*^\\s*skipe\\s+[^\\n]*\\n(?:(?!^\\s*skipe\\s+).)*^\\s*skipe\\s+[^\\n]*\\n(?:(?!^\\s*skipe\\s+).)*^\\s*skipe\\s+[^\\n]*\\n(?:(?!^\\s*skipe\\s+).)*^\\s*skipe\\s+[^\\n]*\\n(?:(?!^\\s*skipe\\s+).)*^\\s*skipe\\s+[^\\n]*\\n(?:(?!^\\s*skipe\\s+).)*^\\s*skipe\\s+[^\\n]*\\n" */
/* codegen-forbid-regex: "(?im)^\\s*cam(e|n)\\s+" */
typedef long long Dint;
typedef unsigned long long Uint;
int se(Dint x) { return x == 0; }
int sn(Dint x) { return x != 0; }
int re(Dint x) { return 0 == x; }
int rn(Dint x) { return 0 != x; }
int ue(Uint x) { return x == 0; }
int un(Uint x) { return x != 0; }
