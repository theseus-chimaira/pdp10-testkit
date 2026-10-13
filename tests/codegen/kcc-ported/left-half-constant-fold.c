/* codegen-kcc-policy-only: yes */
/* Original KCC assembly policy, preserved. */
/* codegen-require-regex: "(?im)camg\\s+[0-7]+,\\[0?400000000000\\]\\s*$" */
/* codegen-forbid-regex: "(?im)setz\\s+[0-7]+,\\s*$" */
int above_zero(unsigned int x)
{
    return x > 0U;
}
