/* codegen-kcc-policy-only: yes */
/* Original KCC assembly policy, preserved. */
/* codegen-require-regex: "(?im)^\\s*ashc\\s+[^,]+,-1$" "(?im)^\\s*ashc\\s+[^,]+,-3$" "(?im)^\\s*ashc\\s+[^,]+,-42$" "(?ims)\\A(?:(?!^\\s*jumpge\\s+).)*^\\s*jumpge\\s+[^\\n]*\\n(?:(?!^\\s*jumpge\\s+).)*^\\s*jumpge\\s+[^\\n]*\\n(?:(?!^\\s*jumpge\\s+).)*^\\s*jumpge\\s+[^\\n]*\\n" "(?ims)\\A(?:(?!^\\s*tlze\\s+[^\\n]*,400000$).)*^\\s*tlze\\s+[^\\n]*,400000$[^\\n]*\\n(?:(?!^\\s*tlze\\s+[^\\n]*,400000$).)*^\\s*tlze\\s+[^\\n]*,400000$[^\\n]*\\n(?:(?!^\\s*tlze\\s+[^\\n]*,400000$).)*^\\s*tlze\\s+[^\\n]*,400000$[^\\n]*\\n" */
/* codegen-forbid-regex: "DIDIV" */
typedef long long Dint;
Dint d2(Dint x) { return x / 2; }
Dint d8(Dint x) { return x / 8; }
Dint d34(Dint x) { return x / 17179869184LL; }
