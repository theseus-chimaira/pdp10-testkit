/* KCC instruction regression, migrated to native matrix. */
/* codegen-require-regex: "(?ims)\\A(?:(?!^\\s*jumpge\\s+).)*^\\s*jumpge\\s+[^\\n]*\\n(?:(?!^\\s*jumpge\\s+).)*^\\s*jumpge\\s+[^\\n]*\\n(?:(?!^\\s*jumpge\\s+).)*^\\s*jumpge\\s+[^\\n]*\\n" "(?ims)\\A(?:(?!^\\s*and\\s+[^\\n]*\\[(1|7|37777777777)\\]$).)*^\\s*and\\s+[^\\n]*\\[(1|7|37777777777)\\]$[^\\n]*\\n(?:(?!^\\s*and\\s+[^\\n]*\\[(1|7|37777777777)\\]$).)*^\\s*and\\s+[^\\n]*\\[(1|7|37777777777)\\]$[^\\n]*\\n(?:(?!^\\s*and\\s+[^\\n]*\\[(1|7|37777777777)\\]$).)*^\\s*and\\s+[^\\n]*\\[(1|7|37777777777)\\]$[^\\n]*\\n" "(?ims)\\A(?:(?!^\\s*seto\\s+).)*^\\s*seto\\s+[^\\n]*\\n(?:(?!^\\s*seto\\s+).)*^\\s*seto\\s+[^\\n]*\\n(?:(?!^\\s*seto\\s+).)*^\\s*seto\\s+[^\\n]*\\n" */
/* codegen-forbid-regex: "DIDIV" */
typedef long long Dint;
Dint m2(Dint x) { return x % 2; }
Dint m8(Dint x) { return x % 8; }
Dint m34(Dint x) { return x % 17179869184LL; }
