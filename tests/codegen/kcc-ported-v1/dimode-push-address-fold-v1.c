/* Original KCC source and codegen assertions. */
/* codegen-forbid-regex: "(?im)^\\s*setm\\s+(\\d+),(\\d+)\\s*\\n\\s*push\\s+17,0\\(\\1\\)\\s*\\n\\s*push\\s+17,1\\(\\2\\)" */
typedef long long Dint;
Dint loadpair(Dint *p) { Dint x = *p; return x; }
