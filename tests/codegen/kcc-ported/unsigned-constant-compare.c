/* codegen-kcc-policy-only: yes */
/* KCC source and original assembly policies. */
/* codegen-require-regex: "(?im)camle\\s+[0-7]+,\\[0?400000000007\\]\\s*$" "(?im)caml\\s+[0-7]+,\\[0?400000000173\\]\\s*$" "(?ims)\\A(?:(?!^\\s*tlc\\s+[0-7]+,0?400000\\s*$).)*^\\s*tlc\\s+[0-7]+,0?400000\\s*$[^\\n]*\\n(?:(?!^\\s*tlc\\s+[0-7]+,0?400000\\s*$).)*^\\s*tlc\\s+[0-7]+,0?400000\\s*$[^\\n]*\\n(?:(?!^\\s*tlc\\s+[0-7]+,0?400000\\s*$).)*\\Z" */
/* codegen-forbid-regex: "(?i)movei\\s+[0-7]+,(7|173)\\s*$" */
int in_range(unsigned int x)
{
    return x >= 1U && x <= 7U;
}

int less_than(unsigned int x)
{
    return x < 123U;
}
