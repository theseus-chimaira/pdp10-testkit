/* codegen-kcc-policy-only: yes */
/* KCC instruction assertions from original shell regression. */
/* codegen-require-regex: "(?ims)\\A(?:(?!^\\s*AND\\s+).)*^\\s*AND\\s+[^\\n]*\\n(?:(?!^\\s*AND\\s+).)*^\\s*AND\\s+[^\\n]*\\n(?:(?!^\\s*AND\\s+).)*\\Z" "(?ims)\\A(?:(?!^\\s*IOR\\s+).)*^\\s*IOR\\s+[^\\n]*\\n(?:(?!^\\s*IOR\\s+).)*^\\s*IOR\\s+[^\\n]*\\n(?:(?!^\\s*IOR\\s+).)*\\Z" "(?ims)\\A(?:(?!^\\s*XOR\\s+).)*^\\s*XOR\\s+[^\\n]*\\n(?:(?!^\\s*XOR\\s+).)*^\\s*XOR\\s+[^\\n]*\\n(?:(?!^\\s*XOR\\s+).)*\\Z" */
/* codegen-forbid-regex: "SUB\\s*17,\\[2,,2\\]" */
typedef long long Dint;
Dint aand(a,b) Dint a,b; { return a & b; }
Dint oor(a,b) Dint a,b; { return a | b; }
Dint xxor(a,b) Dint a,b; { return a ^ b; }
