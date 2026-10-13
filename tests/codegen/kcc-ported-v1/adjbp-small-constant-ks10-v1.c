/* codegen-kcc-policy-only: yes */
/* KCC ADJBP constant increment regression: ks10. */
/* codegen-require-regex: "(?im)^\\s*adjbp\\s+" */
char *f(char *p)
{
        return p + 2;
}
