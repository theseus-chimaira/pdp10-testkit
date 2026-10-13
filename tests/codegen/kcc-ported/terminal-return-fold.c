/* codegen-kcc-policy-only: yes */
/* Migrated original KCC assembly-pattern regression. */
/* codegen-require-regex: "(?im)^\\s*hlrz\\s+1,0\\(1\\)" "(?im)^\\s*movni\\s+1,2" "(?im)^\\s*setz\\s+1," */
/* codegen-forbid-regex: "(?im)^\\s*move\\s+1,[2-7]" */
int half(unsigned long *p)
{
    return (int)(*p >> 18);
}

int neg(void)
{
    return -2;
}

int zero(void)
{
    return 0;
}
