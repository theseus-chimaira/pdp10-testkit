/* codegen-kcc-policy-only: yes */
/* Original KCC assembly policies. */
/* codegen-require-regex: "(?im)^\\s*move\\s+[0-7]+,1\\s*$" "(?im)^\\s*movem\\s+[0-7]+,0\\([0-7]+\\)\\s*$" */
/* codegen-forbid-regex: "(?im)^\\s*subi\\s+1,1\\s*$" */
unsigned long span[8];

int store_level(unsigned int level)
{
    if ((unsigned int)(level - 1U) >= 7U)
        return -1;
    span[level] = 1UL;
    return 0;
}
