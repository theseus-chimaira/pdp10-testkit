/* KCC ADJBP constant increment regression: pdp6. */
/* codegen-forbid-regex: "%ADJBPH" */
/* codegen-require-regex: "(?ims)\\A(?:(?!^\\s*ibp\\s).)*^\\s*ibp\\s[^\\n]*\\n(?:(?!^\\s*ibp\\s).)*^\\s*ibp\\s[^\\n]*\\n(?:(?!^\\s*ibp\\s).)*\\Z" */
char *f(char *p)
{
        return p + 2;
}
